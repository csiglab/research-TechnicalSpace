#!/usr/bin/env bash

echo "Building the project..."

# Check if the virtual environment exists
if [ ! -d ".venv" ]; then
    echo "Virtual environment not found. Running uv sync..."
    uv sync
fi

# Activate the virtual environment
source .venv/bin/activate

# Updating Repository
git pull origin main

# Build the project
cd web || { echo "Failed to enter web directory"; exit 1; }
mkdocs build
cd ..

# Deactivate the virtual environment
deactivate

echo "Build complete."
exit 0
