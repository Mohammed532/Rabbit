#!/usr/bin/env bash
set -e

if [[ $EUID -eq 0 ]]; then
  echo "Don't run this script as root."
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_ROOT"

source ~/Rabbit/software/ros2_ws/install/setup.sh

ros2 launch wabbit_bringup wabbit.launch.py &
ROS_PID=$!

trap "kill $ROS_PID" EXIT

cd ~/Rabbit/software/burrowWEB
npx serve -s dist

