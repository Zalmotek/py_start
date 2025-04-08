#!/bin/bash
set -e # Exit immediately if a command exits with a non-zero status.

VENV_DIR="venv"
CLEAN_INSTALL=false

# Simple argument parsing for --clean
if [[ "$1" == "--clean" ]]; then
  CLEAN_INSTALL=true
  echo "Clean install requested. Removing existing venv and temporary files..."
fi

# Clean up function
clean_temp_files() {
  echo "Removing virtual environment: $VENV_DIR..."
  rm -rf "$VENV_DIR"
  echo "Removing __pycache__ directories..."
  find . -type d -name '__pycache__' -exec rm -rf {} +
  echo "Removing .pytest_cache..."
  rm -rf ".pytest_cache"
  # Add any other common temp files/dirs here if needed
  # e.g., rm -rf build/ dist/ *.egg-info/
  echo "Removing potential build artifacts (build/, dist/, *.egg-info/)..."
  rm -rf build/ dist/ *.egg-info/ src/*.egg-info/
  echo "Cleanup complete."
}

# Perform cleanup if --clean was specified
if [ "$CLEAN_INSTALL" = true ]; then
  clean_temp_files
fi

# Check if python3 is available
if ! command -v python3 &> /dev/null
then
    echo "Error: python3 could not be found. Please install Python 3."
    exit 1
fi

# Check if pip is available
# Use the python3 command found previously to check for its pip module
PYTHON_CMD=$(command -v python3)
if ! $PYTHON_CMD -m pip --version &> /dev/null
then
    echo "Error: pip could not be found for $PYTHON_CMD. Please ensure pip is installed."
    exit 1
fi

# Check if pyproject.toml exists
if [ ! -f "pyproject.toml" ]; then
    echo "Error: pyproject.toml not found in the current directory."
    echo "Please create pyproject.toml before running this script."
    exit 1
fi

# Check if the virtual environment directory exists OR if clean install requested
if [ ! -d "$VENV_DIR" ] || [ "$CLEAN_INSTALL" = true ]; then
    # Ensure it's gone if cleaning
    if [ "$CLEAN_INSTALL" = true ] && [ -d "$VENV_DIR" ]; then
        echo "Warning: $VENV_DIR still exists after clean attempt. Retrying removal."
        rm -rf "$VENV_DIR"
    fi
    echo "Creating virtual environment in $VENV_DIR using $($PYTHON_CMD --version)..."
    $PYTHON_CMD -m venv $VENV_DIR
    echo "Virtual environment created."
else
    echo "Virtual environment '$VENV_DIR' already exists. Use './install.sh --clean' to force recreation."
fi

# Activate virtual environment (or run pip from venv) and install dependencies
echo "Installing dependencies from pyproject.toml into $VENV_DIR..."

# Determine Python executable within venv
VENV_PYTHON="$VENV_DIR/bin/python"

# Upgrade pip within the virtual environment first
echo "Upgrading pip in venv..."
$VENV_PYTHON -m pip install --upgrade pip

# Install dependencies based on pyproject.toml structure
if grep -q '^\[project\]' pyproject.toml || grep -q '^\[tool.setuptools\]' pyproject.toml; then
    echo "Using pip to install project defined in pyproject.toml..."
    # Installs the project itself and its dependencies listed under [project].dependencies
    $VENV_PYTHON -m pip install .
    # Optionally, install development dependencies
    if grep -q '^\[project.optional-dependencies\]' pyproject.toml && grep -q 'dev = \[' pyproject.toml; then
        echo "Installing development dependencies..."
        $VENV_PYTHON -m pip install ".[dev]"
    fi
elif grep -q '^\[tool.poetry\]' pyproject.toml; then
     echo "Using poetry to install dependencies..."
     # Assumes poetry is installed and accessible in the PATH or installed via pip above
     # Activate venv temporarily for poetry or configure poetry to use the venv
     ( \
        source "$VENV_DIR/bin/activate"; \
        if ! command -v poetry &> /dev/null; then \
           echo "Poetry command not found, attempting to install it into venv..."; \
           pip install poetry; \
        fi; \
        poetry install --no-root $( [ -f "poetry.lock" ] && echo "" || echo "--no-lock" ) ; \
        # Add --with dev if you separate dev dependencies in poetry
     )
else
    echo "Warning: Could not determine build system (standard PEP 621 [project] or Poetry [tool.poetry]) in pyproject.toml."
    echo "Attempting 'pip install -r requirements.txt' if it exists..."
    if [ -f "requirements.txt" ]; then
         $VENV_PYTHON -m pip install -r requirements.txt
    else
        echo "No requirements.txt found either. Please check pyproject.toml or install dependencies manually within the venv."
    fi
fi

# --- Post-installation steps ---

# Check if .env file exists, if not, copy from template
if [ ! -f ".env" ]; then
    if [ -f ".env.template" ]; then
        echo "Creating .env file from .env.template..."
        cp .env.template .env
    else
        echo "Warning: .env.template not found. Cannot create .env automatically."
    fi
else
    echo ".env file already exists."
fi

echo ""
echo "--------------------------------------------------"
echo "Setup complete."
echo "Activate the virtual environment using:"
echo "  source $VENV_DIR/bin/activate"
echo ""
echo "Then, run the application using:"
echo "  py_start"
echo ""
echo "IMPORTANT: If a new .env file was created, please edit it now to add your configurations/secrets."
echo "--------------------------------------------------"

exit 0 