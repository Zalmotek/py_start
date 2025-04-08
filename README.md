# py_start

An Python template for a clean containared with venv start.

This project demonstrates a basic Python setup using a `src` layout, a virtual environment, dependency management with `pyproject.toml`, and environment variable handling with `.env` files.

## Prerequisites

*   **Python:** Version 3.9 or higher. You can check your version using `python3 --version`.
*   **pip:** The Python package installer. Usually comes with Python. Check with `python3 -m pip --version`.
*   **Git:** For cloning the repository (if applicable).
*   **Bash:** The setup script (`install.sh`) is a Bash script, common on Linux and macOS. Windows users might need Git Bash or WSL.

## Setup Instructions

Follow these steps exactly to set up your development environment:

1.  **Clone the Repository (if you haven't already):**
    ```bash
    git clone https://github.com/Zalmotek/py_start
    cd py_start # Or your project directory name
    ```

2.  **Make the Installation Script Executable:**
    Give the `install.sh` script permission to run.
    ```bash
    chmod +x install.sh
    ```

3.  **Run the Installation Script:**
    This script will:
    *   Check for Python 3 and pip.
    *   Create a virtual environment named `venv` if it doesn't exist.
    *   If run with `./install.sh --clean`, it will first remove the existing `venv` and common temporary files (`__pycache__`, `.pytest_cache`, build artifacts) for a completely fresh start.
    *   Install the required dependencies listed in `pyproject.toml` and the `py_start` package itself into the `venv`.
    ```bash
    ./install.sh
    ```
    *(You should see output indicating the virtual environment creation and package installation.)*

    To force a clean installation (removes old environment first):
    ```bash
    ./install.sh --clean
    ```

4.  **Configure Environment Variables:**
    Copy the template file to create your local environment file.
    ```bash
    cp .env.template .env
    ```
    Now, **edit the `.env` file** with a text editor and replace placeholder values (like `USERNAME=YourName`) with your actual desired settings or secrets. **Do not commit the `.env` file to Git.**

5.  **Activate the Virtual Environment:**
    Before running the application or installing more packages, you need to activate the virtual environment created by the script.
    ```bash
    source venv/bin/activate
    ```
    Your terminal prompt should change, often showing `(venv)` at the beginning, indicating the virtual environment is active.

## Running the Application

Once the setup is complete and the virtual environment is activated, you can run the application using the command defined in `pyproject.toml` (`[project.scripts]`):

```bash
py_start
```

You should see output like:
```
Hello, [YourName from .env or World] from the Py_start project! (Using config.py)
Logging level set to: [LOG_LEVEL from .env or INFO]
```

## Project Structure

This project uses a `src` layout:

*   **`src/py_start/`**: Contains the main application code (`cli.py`, `config.py`).
*   **`pyproject.toml`**: Defines dependencies, project metadata, and build settings (including pointing to the `src` directory).
*   **`install.sh`**: Script for environment setup and installation.
*   **`.env` / `.env.template`**: For environment variables.

## Configuration (`src/py_start/config.py` and `.env`)

This project uses a `src/py_start/config.py` file to manage runtime configuration.

*   **`.env` file:** This file (which you create by copying `.env.template`) is used to store environment-specific variables and secrets (like API keys, database URLs, or user-specific settings like `USERNAME`). **It should *not* be committed to version control.**
*   **`config.py`:** This Python module (located in `src/py_start/`) automatically loads the variables defined in your `.env` file when the application starts. It then makes these settings available as Python variables (e.g., `config.USERNAME`, `config.LOG_LEVEL`). It can also provide default values if a variable is missing in `.env`.
*   **Usage:** Import the `config` module in other Python files within the `py_start` package (e.g., `from . import config`) and access settings directly (e.g., `api_key = config.API_KEY`). See `src/py_start/cli.py` for an example.

To add new configuration variables:
1.  Add the variable definition to your `.env` file (and ideally to `.env.template` with a placeholder or default).
2.  Add code to `src/py_start/config.py` to load this new variable using `os.getenv("YOUR_VARIABLE_NAME", "optional_default")`.

## Development

*   **Dependencies:** To add or remove dependencies, edit the `[project]` -> `dependencies` list in `pyproject.toml`.