from flask import Blueprint, jsonify, request
from werkzeug.exceptions import HTTPException

from ..controllers.auth_controller import register_user, authenticate_user

auth_bp = Blueprint("auth", __name__)


@auth_bp.errorhandler(HTTPException)
def handle_http_exception(error: HTTPException):
    response = {"error": error.description}
    return jsonify(response), error.code


@auth_bp.route("/register", methods=["POST"])
def register():
    data = request.get_json() or {}
    body, status = register_user(data)
    return jsonify(body), status


@auth_bp.route("/login", methods=["POST"])
def login():
    data = request.get_json() or {}
    body, status = authenticate_user(data)
    return jsonify(body), status

