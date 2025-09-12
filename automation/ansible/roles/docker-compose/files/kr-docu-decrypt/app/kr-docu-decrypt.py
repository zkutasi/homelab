import base64
import logging
import sys
import tempfile
from flask import Flask, request

from selenium_worker import run_decrypt_logic
from docker_utils import selenium_container

logging.basicConfig(
    stream=sys.stderr,
    level=logging.INFO,
    format='%(asctime)s [%(levelname)s] %(message)s'
)

logger = logging.getLogger(__name__)

app = Flask(__name__)

@app.route("/decrypt", methods=["POST"])
def decrypt():
    filedata = request.json["filedata"]
    filename = request.json["filename"]

    logger.info("Save XML to a temporary file...")
    with tempfile.NamedTemporaryFile(delete=False, suffix=".xml") as f:
        f.write(base64.b64decode(filedata))
        f.flush()
        xml_path = f.name

    with selenium_container():
        return run_decrypt_logic(xml_path)

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
