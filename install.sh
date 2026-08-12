#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
cd "$SCRIPT_DIR"

# Try to use ComfyUI's own venv first. Normal layout is
# ComfyUI/custom_nodes/<this>/ -> venv two levels up (../../venv).
# Some portable layouts nest one level deeper, so check that too
# (mirrors install.bat's ..\..\..\python_embeded lookup on Windows).
PYTHON=""
for CANDIDATE in "../../venv/bin/python" "../../.venv/bin/python" "../../../venv/bin/python" "../../../.venv/bin/python"; do
    if [ -x "$CANDIDATE" ]; then
        PYTHON="$CANDIDATE"
        break
    fi
done

if [ -z "$PYTHON" ]; then
    if command -v python3 >/dev/null 2>&1; then
        PYTHON_VERSION="$(python3 --version 2>&1)"
        echo "I couldn't find a ComfyUI venv (../../../venv), but I did find $PYTHON_VERSION in your PATH."
        read -r -p "Would you like to proceed with the install using that version? (y/N) " USE_PYTHON
        case "$USE_PYTHON" in
            [yY]*) PYTHON="python3" ;;
            *)
                echo "Okay. Please install manually."
                exit 1
                ;;
        esac
    else
        echo "I couldn't find a ComfyUI venv, nor python3 in your PATH. Please install manually."
        exit 1
    fi
fi

echo "Using: $PYTHON ($("$PYTHON" --version 2>&1))"
echo "Installing..."
"$PYTHON" install.py
echo "Done!"
