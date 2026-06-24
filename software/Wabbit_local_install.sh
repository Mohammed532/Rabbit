#!/bin/bash

set -e

echo "====================================="
echo " WABBIT Installer"
echo " Wireless Autonomous Behavioral Bot with Intelligence and Traits"
echo "====================================="
echo ""

# ---------------------------

# Detect OS

# ---------------------------

if [ -f /etc/os-release ]; then
. /etc/os-release
echo "Detected OS: $PRETTY_NAME"
else
echo "Unable to detect operating system."
exit 1
fi

# ---------------------------

# Update System

# ---------------------------

echo ""
echo "Updating packages..."
sudo apt update

echo ""
echo "Installing dependencies..."

sudo apt install -y 
python3 
python3-pip 
python3-venv 
git 
wget 
curl 
ffmpeg

# ---------------------------

# Create WABBIT Structure

# ---------------------------

echo ""
echo "Creating WABBIT directories..."

mkdir -p ~/wabbit
mkdir -p ~/wabbit/config
mkdir -p ~/wabbit/memory
mkdir -p ~/wabbit/logs
mkdir -p ~/wabbit/piper/voices

# ---------------------------

# Create Virtual Environment

# ---------------------------

echo ""
echo "Creating Python environment..."

python3 -m venv ~/wabbit/venv

source ~/wabbit/venv/bin/activate

pip install --upgrade pip

# ---------------------------

# Install Python Packages

# ---------------------------

echo ""
echo "Installing Whisper..."

pip install openai-whisper

echo ""
echo "Installing Piper..."

pip install piper-tts

# ---------------------------

# Voice Selection

# ---------------------------

echo ""
echo "====================================="
echo " Piper Voice Setup"
echo "====================================="
echo ""
echo "Paste the direct download link to the"
echo "desired Piper .onnx voice model."
echo ""
echo "Example:"
echo "https://huggingface.co/rhasspy/piper-voices/resolve/main/en/en_GB/alba/medium/en_GB-alba-medium.onnx"
echo ""

read -p "Voice URL: " VOICE_URL

VOICE_FILE=$(basename "$VOICE_URL")

JSON_URL="${VOICE_URL}.json"

echo ""
echo "Downloading voice model..."

wget -O ~/wabbit/piper/voices/$VOICE_FILE "$VOICE_URL"

echo ""
echo "Downloading voice config..."

wget -O ~/wabbit/piper/voices/$VOICE_FILE.json "$JSON_URL"

# ---------------------------

# Create WABBIT Config

# ---------------------------

VOICE_NAME=$(basename "$VOICE_FILE" .onnx)

cat > ~/wabbit/config/wabbit.json << EOF
{
"voice": "$VOICE_NAME",
"memory_enabled": true,
"agent_provider": "gemini"
}
EOF

# ---------------------------

# Completion

# ---------------------------

echo ""
echo "====================================="
echo " Installation Complete"
echo "====================================="
echo ""

echo "Voice Installed:"
echo "$VOICE_NAME"

echo ""
echo "Voice Location:"
echo "~/wabbit/piper/voices"

echo ""
echo "Configuration:"
echo "~/wabbit/config/wabbit.json"

echo ""
echo "Activate environment with:"
echo ""
echo "source ~/wabbit/venv/bin/activate"
echo ""

echo "WABBIT is ready."
echo ""
