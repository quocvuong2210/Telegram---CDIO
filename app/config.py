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

