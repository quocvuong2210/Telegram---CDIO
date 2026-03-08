from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from werkzeug.exceptions import HTTPException

from ..controllers.user_controller import search_users, update_user_profile

user_bp = Blueprint("users", __name__)


@user_bp.errorhandler(HTTPException)
def handle_http_exception(error: HTTPException):
    response = {"error": error.description}
    return jsonify(response), error.code


@user_bp.route("/search", methods=["GET"])
def search():
    """
    Tìm kiếm người dùng theo username hoặc phone.
    
    Query params:
    - q: Chuỗi tìm kiếm (bắt buộc)
    - limit: Số kết quả tối đa (mặc định 10)
    """
    query = request.args.get('q', '')
    limit = request.args.get('limit', 10, type=int)
    
    body, status = search_users(query, limit)
    return jsonify(body), status


@user_bp.route("/profile", methods=["PUT"])
@jwt_required()
def update_profile():
    """
    Cập nhật thông tin profile của người dùng hiện tại.
    
    Body (JSON):
    - avatar_url: URL ảnh đại diện (optional)
    - bio: Tiểu sử (optional)
    - phone: Số điện thoại (optional)
    """
    user_id = get_jwt_identity()
    data = request.get_json() or {}
    
    body, status = update_user_profile(user_id, data)
    return jsonify(body), status
