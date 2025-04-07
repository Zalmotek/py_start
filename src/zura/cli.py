from . import config # Import settings from config.py using relative import

def main():
    """Prints a greeting using the username from the config."""
    # No need to load_dotenv() here, config.py does it upon import
    # Access the username directly from the config module
    name = config.USERNAME
    print(f"Hello, {name} this is Zura ready for action in CLI format! (Using config.py)") # Updated message
    print(f"Logging level set to: {config.LOG_LEVEL}")

if __name__ == "__main__":
    # This allows running the script directly for testing (python src/zura/cli.py)
    # but the main entry point should be via the console script defined in pyproject.toml
    main() 