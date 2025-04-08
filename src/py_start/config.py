import os
from dotenv import load_dotenv

# Load environment variables from .env file
# This should be called early in your application startup.
load_dotenv()

# --- Application Settings ---
# Load settings from environment variables, providing defaults where appropriate.

# Example: User name for greetings (used in cli.py)
# Default to 'World' if USERNAME is not set in the .env file
USERNAME = os.getenv("USERNAME", "World")

# Example: Logging level for the application
# Default to 'INFO' if LOG_LEVEL is not set in the .env file
LOG_LEVEL = os.getenv("LOG_LEVEL", "INFO").upper()

# Example: API Key (replace with actual needed config)
# Ensure this is set in your .env file for security
# No default provided, as it's likely required.
# API_KEY = os.getenv("API_KEY")
# if not API_KEY:
#     print("Warning: API_KEY environment variable not set.")
    # Depending on the application, you might raise an error here:
    # raise ValueError("API_KEY environment variable is required but not set.")

# Add more configuration variables as needed by your application
# Example: DATABASE_URL = os.getenv("DATABASE_URL")

# You can also add logic here, e.g., parsing boolean values:
# DEBUG = os.getenv("DEBUG", "False").lower() in ('true', '1', 't')

print(f"Configuration loaded: USERNAME='{USERNAME}', LOG_LEVEL='{LOG_LEVEL}'")
# Avoid printing sensitive values like API keys! 