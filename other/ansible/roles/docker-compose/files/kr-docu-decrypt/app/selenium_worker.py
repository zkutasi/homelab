import base64
import logging
import os
import time

from flask import Flask, request, jsonify
from selenium import webdriver
from selenium.webdriver.common.action_chains import ActionChains
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

KR_PRINT_URL = "https://e-kerelem.mvh.allamkincstar.gov.hu/enter/krnyomtatas/krNyomtatas.xhtml"
SELENIUM_URL = os.environ.get("SELENIUM_URL", "http://selenium:4444/wd/hub")

logger = logging.getLogger(__name__)

def run_decrypt_logic(xml_path):
    # Create temporary download directory
    download_dir = "/downloads"

    logger.info("Set up Chrome...")    
    chrome_options = Options()
    chrome_options.add_experimental_option("prefs", {
        "download.default_directory": download_dir,
        "download.prompt_for_download": False,
        "download.directory_upgrade": True,
        "plugins.always_open_pdf_externally": True
    })
    chrome_options.add_argument("--no-sandbox")
    chrome_options.add_argument("--disable-dev-shm-usage")

    driver = webdriver.Remote(
        command_executor=SELENIUM_URL,
        options=chrome_options
    )

    try:
        wait = WebDriverWait(driver, 20)

        logger.info("Navigate to the page...")
        driver.get(KR_PRINT_URL)

        logger.info("Wait for file input to be present and upload XML file...")
        upload_input = wait.until(
            EC.presence_of_element_located((By.CSS_SELECTOR, "input[type=file]"))
        )
        upload_input.send_keys(xml_path)

        logger.info("Wait for the decrypt button to become clickable and click it...")
        decrypt_button = wait.until(
            EC.element_to_be_clickable(
                (By.XPATH, "//button[.//span[contains(text(), 'Nyomtatás')]]")
            )
        )
        decrypt_button.click()

        logger.info("Wait for PDF download to appear...")
        downloaded_file = None
        timeout = 60  # seconds
        poll_interval = 1
        for _ in range(timeout):
            files = os.listdir(download_dir)

            # Check for .pdf file without .crdownload
            pdfs = [f for f in files if f.endswith(".pdf")]
            if pdfs and not any(f.endswith(".crdownload") for f in files):
                downloaded_file = os.path.join(download_dir, pdfs[0])
                break
            time.sleep(poll_interval)

        if not downloaded_file or not os.path.exists(downloaded_file):
            return jsonify({"error": "PDF download failed"}), 500

        logger.info("Return PDF content as base64...")
        with open(downloaded_file, "rb") as f:
            encoded_pdf = base64.b64encode(f.read()).decode("utf-8")

        return jsonify({
            "filename": os.path.basename(downloaded_file),
            "pdf_base64": encoded_pdf
        })

    finally:
        logger.info("Cleanup...")
        driver.quit()
        os.unlink(xml_path)
        try:
            for f in os.listdir(download_dir):
                os.unlink(os.path.join(download_dir, f))
            os.rmdir(download_dir)
        except Exception:
            pass
