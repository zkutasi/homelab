#!/usr/bin/env python3

import argparse
import logging
import os
import re
import yaml
import requests


DRY_RUN = False

CATEGORY_FOLDER_MAP = {
    "Albums": "/volume1/music/Albums",
    "EPs": "/volume1/music/EPs",
    "Compilations": "/volume1/music/Compilations and Mixes",
    "Series": "/volume1/music/Series"
}

def handle_one_torrent(session, config, torrent_hash, discogs_id):
    get_torrent_info(session, config, torrent_hash)
    if discogs_id is None:
        discogs_id = input("Please enter Discogs release ID (or Enter if not available, or skip if just categorize): ").strip()

    if discogs_id:
        if discogs_id.lower() == "skip":
            new_folder_name = input("Please enter the new folder name: ").strip()
        else:
            release = fetch_release_from_discogs(discogs_id)
            new_folder_name = build_folder_name(release)

        category = None
        while True:
            print("\nAvailable categories:")
            for idx, cat in enumerate(CATEGORY_FOLDER_MAP.keys()):
                print(f"  {idx + 1}. {cat}")

            choice = input("Please select a category by number or name: ").strip()

            if choice.isdigit() and 1 <= int(choice) <= len(CATEGORY_FOLDER_MAP):
                category = list(CATEGORY_FOLDER_MAP.keys())[int(choice) - 1]
                break
            elif choice in CATEGORY_FOLDER_MAP:
                category = choice
                break
            else:
                logging.warning("Invalid category choice. Please try again.")
        rename_torrent_folder(session, config, torrent_hash, new_folder_name)
        categorize_torrent(session, config, torrent_hash, category)
        move_torrent_by_category(session, config, torrent_hash, category)
    else:
        category = "NotFoundOnDiscogs"
        categorize_torrent(session, config, torrent_hash, category)

def handle_multiple_torrents(session, config):
    qbit_url = config.get("qbit_url")

    # Get info about the list of torrents
    limit = 50
    info_url = "{url}/api/v2/torrents/info".format(url=qbit_url)
    info_params = {
        "filter": "seeding",
        "category": "",
        "limit": limit,
    }
    logging.info("Fetching list of torrents with limit=%s...", limit)
    info_response = session.get(info_url, params=info_params, timeout=15)
    info_response.raise_for_status()
    torrent_list = info_response.json()
    logging.debug("Torrents fetched: %s", torrent_list)

    for torrent in torrent_list:
        logging.info("Processing torrent: %s (%s)", torrent["name"], torrent["hash"])
        handle_one_torrent(session, config, torrent["hash"], None)

def fetch_release_from_discogs(release_id):
    token = os.environ.get("DISCOGS_TOKEN")
    url = "https://api.discogs.com/releases/{id}".format(id=release_id)

    headers = {
        "User-Agent": "MusicFolderRenamer/1.0"
    }
    if token:
        headers["Authorization"] = "Discogs token={token}".format(token=token)

    response = requests.get(url, headers=headers, timeout=15)
    response.raise_for_status()
    discogs_release_data = response.json()
    logging.debug("Discogs release data fetched: %s", discogs_release_data)
    return discogs_release_data

def build_folder_name(release):
    def sanitize(text):
        output_text = text
        output_text = re.sub(r"\s+\(\d+\)$", "", output_text)
        output_text = re.sub(r'[<>:"/\\|?*]', '', output_text).strip()
        return output_text

    parts = {
        "artists": " & ".join(sanitize(a["name"]) for a in release.get("artists", [])),
        "title": release.get("title", "Unknown Title"). replace("/", "_"),
        "year": str(release.get("year", "Unknown Year")),
        "labels": next(sanitize(l["name"]) for l in release.get("labels", [])),
        "catno": next(l["catno"] for l in release.get("labels", [])),
    }

    if 'Various Artists' == parts['artists'] or \
        'Various' == parts['artists']:
        parts["artists"] = 'VA'
    if 'Kompakt Extra' in parts['labels']:
        parts['labels'] = 'Kompakt'
    if 'Not On Label' in parts['labels']:
        parts['labels'] = None
    if 'Unknown Artist' == parts['artists'] and 'Untitled' in parts['title']:
        parts['title'] = parts['catno']

    series_style = 0
    while True:
        if series_style == 1:
            new_folder_name = "{title} - {artists} ({others})".format(
                artists=parts["artists"],
                title=parts["title"],
                others="{year} - {label}".format(
                        year=parts["year"],
                        label=parts["labels"]
                    ) if parts['labels'] else parts["year"]
            )
        elif series_style == 2:
            new_folder_name = "{title} ({others})".format(
                title=parts["title"],
                others="{year} - {label}".format(
                        year=parts["year"],
                        label=parts["labels"]
                    ) if parts['labels'] else parts["year"]
            )
        else:
            new_folder_name = "{artists} - {title} ({others})".format(
                artists=parts["artists"],
                title=parts["title"],
                others="{year} - {label}".format(
                    year=parts["year"],
                    label=parts["labels"]
                ) if parts['labels'] else parts["year"]
            )
        logging.info("Proposed folder name:\n%s", new_folder_name)

        answer = input("\nIs the new folder name looks OK? [Y/N/S(eries1)/S(eries)2]: ").lower().strip()

        if answer in ["y", ""]:
            return new_folder_name
        elif answer == "s1":
            series_style = 1
        elif answer == "s2":
            series_style = 2
        elif answer == "n":
            while True:
                edit_choice = input("Which part to edit? (a)rtist, (t)itle, (y)ear, (l)abel: ").lower().strip()
                part_map = {
                    "a": "artists",
                    "t": "title",
                    "y": "year",
                    "l": "labels"
                }
                if edit_choice in part_map:
                    part_to_edit = part_map[edit_choice]
                    current_value = parts[part_to_edit]
                    new_value = input("Enter new value for {part} (current: '{current}'): ".format(
                        part=part_to_edit, current=current_value
                    ))
                    parts[part_to_edit] = sanitize(new_value)
                    break
                else:
                    logging.warning("Invalid choice. Please select from the available options.")
        else:
            logging.warning("Invalid input. Please answer with 'y' (or Enter) for yes, or 'n' for no.")

def login(session, config):
    qbit_url = config.get("qbit_url")
    qbit_user = config.get("qbit_username")
    qbit_pass = config.get("qbit_password")

    if not all([qbit_url, qbit_user, qbit_pass]):
        logging.error("qbit_url, qbit_username, and qbit_password must be set in the config file.")
        exit(1)

    login_url = "{url}/api/v2/auth/login".format(url=qbit_url)
    login_data = {"username": qbit_user, "password": qbit_pass}
    headers = {
        "Referer": qbit_url
    }

    logging.info("Logging into qBittorrent at %s...", qbit_url)
    login_response = session.post(login_url, data=login_data, headers=headers, timeout=15)
    login_response.raise_for_status()

    if login_response.text != "Ok.":
        logging.error("qBittorrent login failed: %s", login_response.text)
        exit(1)
    logging.info("Login successful.")

def get_torrent_info(session, config, torrent_hash):
    qbit_url = config.get("qbit_url")

    # Get info about the torrent
    info_url = "{url}/api/v2/torrents/properties".format(url=qbit_url)
    info_params = {
        "hash": torrent_hash
    }
    logging.info("Fetching torrent info for hash %s...", torrent_hash)
    info_response = session.get(info_url, params=info_params, timeout=15)
    info_response.raise_for_status()
    torrent_properties = info_response.json()
    logging.debug("Torrents properties fetched: %s", torrent_properties)

    # Get files associated with the torrent
    files_url = "{url}/api/v2/torrents/files".format(url=qbit_url)
    files_params = {
        "hash": torrent_hash
    }
    logging.info("Fetching files associated with torrent hash %s...", torrent_hash)
    files_response = session.get(files_url, params=files_params, timeout=15)
    files_response.raise_for_status()
    files_properties = files_response.json()
    logging.debug("Files properties fetched: %s", files_properties)
    current_folder_name = set()
    for files in files_properties:
        logging.debug("File: %s", files)
        current_folder_name.add(files["name"].split("/")[0])
    if len(current_folder_name) != 1:
        logging.error("Multiple root folders found for torrent %s: %s", torrent_hash, current_folder_name)
        exit(1)

    current_folder_name = current_folder_name.pop()
    logging.info("Current folder name: '%s'", current_folder_name)

    return (current_folder_name)

def rename_torrent_folder(session, config, torrent_hash, new_folder_name):
    qbit_url = config.get("qbit_url")

    current_folder_name = get_torrent_info(session, config, torrent_hash)

    if current_folder_name == new_folder_name:
        logging.info("Current folder name is already '%s'. No rename needed.", new_folder_name)
        return

    # Rename
    rename_url = "{url}/api/v2/torrents/renameFolder".format(url=qbit_url)
    rename_data = {
        "hash": torrent_hash,
        "oldPath": current_folder_name,
        "newPath": new_folder_name
    }

    logging.info("Renaming torrent %s to '%s'...", torrent_hash, new_folder_name)
    if not DRY_RUN:
        rename_response = session.post(rename_url, data=rename_data, timeout=15)
        rename_response.raise_for_status()
        logging.info("Torrent rename command sent successfully.")

def categorize_torrent(session, config, torrent_hash, new_category):
    qbit_url = config.get("qbit_url")

    # Categorize
    categorize_url = "{url}/api/v2/torrents/setCategory".format(url=qbit_url)
    categorize_data = {
        "hashes": torrent_hash,
        "category": new_category
    }

    logging.info("Categorizing torrent %s to '%s'...", torrent_hash, new_category)
    if not DRY_RUN:
        categorize_response = session.post(categorize_url, data=categorize_data, timeout=15)
        categorize_response.raise_for_status()
        logging.info("Torrent categorization command sent successfully.")

def move_torrent_by_category(session, config, torrent_hash, new_category):
    qbit_url = config.get("qbit_url")

    new_location = CATEGORY_FOLDER_MAP[new_category]

    # Get the current save_path
    info_url = "{url}/api/v2/torrents/properties".format(url=qbit_url)
    info_params = {
        "hash": torrent_hash
    }
    logging.info("Fetching torrent info for hash %s...", torrent_hash)
    info_response = session.get(info_url, params=info_params, timeout=15)
    info_response.raise_for_status()
    torrent_properties = info_response.json()
    current_save_path = torrent_properties.get("save_path")
    logging.info("Current save path: %s", current_save_path)
    if current_save_path == new_location:
        logging.info("Current save path is already '%s'. No move needed.", new_location)
        return

    # Move
    move_url = "{url}/api/v2/torrents/setLocation".format(url=qbit_url)
    move_data = {
        "hashes": torrent_hash,
        "location": new_location
    }

    logging.info("Moving torrent %s to category folder '%s'...", torrent_hash, new_location)
    if not DRY_RUN:
        move_response = session.post(move_url, data=move_data, timeout=15)
        move_response.raise_for_status()
        logging.info("Torrent move command sent successfully.")

def load_config(config_path):
    try:
        with open(config_path, 'r') as f:
            config = yaml.safe_load(f)
            logging.debug("Configuration loaded from %s", config_path)
            return config.get('qbittorrent', {})
    except FileNotFoundError:
        logging.error("Configuration file not found at %s", config_path)
        exit(1)
    except yaml.YAMLError as e:
        logging.error("Error parsing YAML file %s: %s", config_path, e)
        exit(1)

def parse_args():
    parser = argparse.ArgumentParser(
        description="Rename a music release folder using Discogs metadata."
    )
    parser.add_argument(
        "--torrent_hash",
        help="The torrent hash to handle"
    )
    parser.add_argument(
        "--discogs_id",
        help="Discogs release ID"
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show the proposed rename without modifying anything yet"
    )
    parser.add_argument(
        "-v", "--verbose",
        action="store_true",
        help="Enable verbose logging (DEBUG level)"
    )
    parser.add_argument(
        "--config",
        default=os.path.expanduser("~/.config/qbt_renamer.yaml"),
        help="Path to the YAML configuration file (default: ~/.config/qbt_renamer.yaml)"
    )
    return parser.parse_args()

def main():
    global DRY_RUN

    args = parse_args()
    DRY_RUN = args.dry_run

    log_level = logging.DEBUG if args.verbose else logging.INFO
    logging.basicConfig(level=log_level,
                        format='%(asctime)s - %(levelname)s - %(message)s')
    config = load_config(args.config)

    with requests.Session() as session:
        login(session, config)

        if args.torrent_hash:
            handle_one_torrent(session, config, args.torrent_hash, args.discogs_id)
        else:
            handle_multiple_torrents(session, config)


if __name__ == "__main__":
    main()
