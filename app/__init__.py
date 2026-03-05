from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from .config import Config

db = SQLAlchemy()
bcrypt = Bcrypt()


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    db.init_app(app)
    bcrypt.init_app(app)

    from .routes.main_routes import main_bp
    from .routes.auth_routes import auth_bp

    app.register_blueprint(main_bp)
    app.register_blueprint(auth_bp, url_prefix="/api/auth")

    return app

