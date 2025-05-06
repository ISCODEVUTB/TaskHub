from backend.api.Gateway.main import app  # noqa: F401

import sys
from pathlib import Path

# Dynamically add the project root to sys.path
project_root = Path(__file__).resolve().parents[3]
sys.path.append(str(project_root))
