from flask import Flask, jsonify
from flask_sqlalchemy import SQLAlchemy
from flask_bcrypt import Bcrypt
from flask_cors import CORS
from werkzeug.exceptions import HTTPException
from .config import Config

db = SQLAlchemy()
bcrypt = Bcrypt()


def create_app():
    app = Flask(__name__)
    app.config.from_object(Config)

    # Enable CORS so frontend can call /api/*
    CORS(
        app,
        resources={r"/api/*": {"origins": "*"}},
    )

    db.init_app(app)
    bcrypt.init_app(app)

    from .routes.main_routes import main_bp
    from .routes.auth_routes import auth_bp
    from .routes.message_routes import message_bp

    app.register_blueprint(main_bp)
    app.register_blueprint(auth_bp, url_prefix="/api/auth")
    app.register_blueprint(message_bp, url_prefix="/api")

    # Global error handler to return JSON instead of HTML
    @app.errorhandler(HTTPException)
    def handle_exception(e):
        return jsonify({"error": str(e.description)}), e.code

    @app.errorhandler(Exception)
    def handle_generic_exception(e):
        print(f"ERROR: {str(e)}")
        import traceback
        traceback.print_exc()
        return jsonify({"error": f"Server error: {str(e)}"}), 500

    return app

