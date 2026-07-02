#!/usr/bin/env bash
set -e

# checks if script is ran as super (it shouldn't be)
if [[ $EUID -eq 0 ]]; then
    echo "Don't run this script as root."
    exit 1
fi

sudo -v

echo "==================================================================="
echo "                          WABBIT Installer                         "
echo "   Wireless Autonomous Behavioral Bot with Intelligence and Traits "
echo "==================================================================="
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

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

echo ""
echo "Updating packages..."
sudo apt update
sudo apt upgrade -y

echo ""
echo "Installing dependencies..."

# ROS Prereqs
sudo apt install -y \
  curl \
  git \
  python3-pip \
  python3-colcon-common-extensions \
  python3-vcstool

# ROS Packages
sudo apt install -y \
    ros-jazzy-ros-base \
    ros-jazzy-rosbridge-server \
    ros-jazzy-geometry-msgs \

# GPIO
sudo apt install -y python3-gpiozero

# Node
sudo apt install -y nodejs npm

# Other installs
sudo apt install -y \
  python3-venv \
  git \
  wget \
  curl \
  ffmpeg \

# ---------------------------

# Python Packages

# ---------------------------

## WIP: Still need to work on whisper and Piper intergration
# echo ""
# echo "Installing Whisper..."
# 
# pip3 install openai-whisper
# 
# echo ""
# echo "Installing Piper..."
# 
# pip3 install piper-tts

# ---------------------------

# BUILDS
#
# ---------------------------

pwd

echo ""
echo "Building ROS packages..."
cd ~/Rabbit/software/ros2_ws
colcon build

echo ""
echo "Building BURROWWEB..."
cd ../burrowWEB
npm i
npm run build

# ---------------------------

# Completion

# ---------------------------

echo ""
echo "====================================="
echo " Installation Complete"
echo "====================================="
echo ""

echo "WABBIT is ready."
echo ""
