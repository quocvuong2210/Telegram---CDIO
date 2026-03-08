import os
from dotenv import load_dotenv

load_dotenv()


class Config:
    SECRET_KEY = os.getenv("SECRET_KEY", "dev_secret_key_change_me")

    # Allow overriding by env; default uses the connection string you provided.
    SQLALCHEMY_DATABASE_URI = os.getenv(
        "MYSQL_CONN",
        "mysql+mysqlconnector://root:123456@localhost/TELEGRAM_CDIO",
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # JWT Configuration
    JWT_SECRET_KEY = os.getenv("JWT_SECRET_KEY", "jwt_secret_key_change_me")
    JWT_ACCESS_TOKEN_EXPIRES = 86400  # 24 hours in seconds

