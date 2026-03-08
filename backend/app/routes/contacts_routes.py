from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from werkzeug.exceptions import HTTPException

from ..controllers.contacts_controller import add_contact, get_contacts, remove_contact

contacts_bp = Blueprint("contacts", __name__)


@contacts_bp.errorhandler(HTTPException)
def handle_http_exception(error: HTTPException):
    response = {"error": error.description}
    return jsonify(response), error.code


@contacts_bp.route("", methods=["GET"])
@jwt_required()
def list_contacts():
    """
    Lấy danh sách liên hệ của người dùng hiện tại.
    """
    user_id = get_jwt_identity()
    body, status = get_contacts(user_id)
    return jsonify(body), status


@contacts_bp.route("", methods=["POST"])
@jwt_required()
def create_contact():
    """
    Thêm một người dùng vào danh sách liên hệ.
    
    Body (JSON):
    - contact_user_id: ID của người dùng cần thêm (bắt buộc)
    """
    user_id = get_jwt_identity()
    data = request.get_json() or {}
    contact_user_id = data.get('contact_user_id')
    
    print(f"DEBUG: Adding contact - user_id={user_id}, contact_user_id={contact_user_id}")
    
    if not contact_user_id:
        return jsonify({"error": "contact_user_id is required"}), 400
    
    try:
        body, status = add_contact(user_id, contact_user_id)
        print(f"DEBUG: Contact added successfully - {body}")
        return jsonify(body), status
    except Exception as e:
        print(f"ERROR: Failed to add contact: {str(e)}")
        raise


@contacts_bp.route("/<int:contact_user_id>", methods=["DELETE"])
@jwt_required()
def delete_contact(contact_user_id: int):
    """
    Xóa một người dùng khỏi danh sách liên hệ.
    
    URL params:
    - contact_user_id: ID của contact cần xóa
    """
    user_id = get_jwt_identity()
    body, status = remove_contact(user_id, contact_user_id)
    return jsonify(body), status
