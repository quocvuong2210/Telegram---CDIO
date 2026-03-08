from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from werkzeug.exceptions import HTTPException

from ..controllers.auth_controller import register_user, authenticate_user, get_current_user

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


@auth_bp.route("/me", methods=["GET"])
@jwt_required()
def get_me():
    """
    Lấy thông tin cá nhân của người dùng hiện tại từ token.
    
    Cần gửi token trong header: Authorization: Bearer <access_token>
    """
    user_id = get_jwt_identity()
    user = get_current_user(user_id)
    return jsonify({"user": user.to_dict()}), 200

