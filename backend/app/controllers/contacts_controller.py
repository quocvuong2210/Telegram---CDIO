from typing import Tuple, Optional
from werkzeug.exceptions import BadRequest, Unauthorized

from .. import db
from ..models import User, Contact


def add_contact(user_id: int, contact_user_id: int) -> Tuple[dict, int]:
    """
    Thêm một người dùng vào danh sách liên hệ.
    
    Args:
        user_id: ID của người dùng hiện tại
        contact_user_id: ID của người dùng cần thêm
    
    Returns:
        Contact info
    """
    # Kiểm tra user hiện tại
    user: Optional[User] = User.query.get(user_id)
    if not user:
        raise Unauthorized("User not found")
    
    # Kiểm tra contact user có tồn tại
    contact_user: Optional[User] = User.query.get(contact_user_id)
    if not contact_user:
        raise BadRequest("Contact user not found")
    
    # Không thể thêm chính mình
    if user_id == contact_user_id:
        raise BadRequest("Cannot add yourself as a contact")
    
    # Kiểm tra đã thêm chưa
    existing: Optional[Contact] = Contact.query.filter(
        Contact.user_id == user_id,
        Contact.contact_user_id == contact_user_id
    ).first()
    
    if existing:
        raise BadRequest("Contact already exists")
    
    # Tạo mới contact
    contact = Contact(
        user_id=user_id,
        contact_user_id=contact_user_id
    )
    
    # save primary contact first
    db.session.add(contact)
    db.session.commit()

    # also create reciprocal contact if it doesn't already exist.
    # we wrap in individual try/except so failure here won't break the
    # successful addition above (e.g. due to unique constraint).
    try:
        existing_recip = Contact.query.filter(
            Contact.user_id == contact_user_id,
            Contact.contact_user_id == user_id
        ).first()
        if not existing_recip:
            reciprocal = Contact(
                user_id=contact_user_id,
                contact_user_id=user_id
            )
            db.session.add(reciprocal)
            db.session.commit()
    except Exception as e:
        # log and ignore; the original contact is already committed
        print(f"WARNING: failed to create reciprocal contact: {e}")

    return {
        "contact": contact.to_dict(),
        "contact_user": contact_user.to_dict()
    }, 201


def get_contacts(user_id: int) -> Tuple[dict, int]:
    """
    Lấy danh sách liên hệ của người dùng.
    
    Args:
        user_id: ID của người dùng
    
    Returns:
        Danh sách contacts
    """
    user: Optional[User] = User.query.get(user_id)
    if not user:
        raise Unauthorized("User not found")
    
    # Lấy danh sách contact_user_id
    contacts: list = Contact.query.filter(
        Contact.user_id == user_id
    ).all()
    
    # Lấy thông tin chi tiết của mỗi contact
    contact_list = []
    for contact in contacts:
        contact_user = User.query.get(contact.contact_user_id)
        if contact_user:
            contact_list.append({
                "contact_id": contact.id,
                "user": contact_user.to_dict(),
                "added_at": contact.created_at.isoformat() if contact.created_at else None
            })
    
    return {
        "contacts": contact_list,
        "total": len(contact_list)
    }, 200


def remove_contact(user_id: int, contact_user_id: int) -> Tuple[dict, int]:
    """
    Xóa một người dùng khỏi danh sách liên hệ.
    
    Args:
        user_id: ID của người dùng hiện tại
        contact_user_id: ID của contact cần xóa
    
    Returns:
        Message thành công
    """
    user: Optional[User] = User.query.get(user_id)
    if not user:
        raise Unauthorized("User not found")
    
    contact: Optional[Contact] = Contact.query.filter(
        Contact.user_id == user_id,
        Contact.contact_user_id == contact_user_id
    ).first()
    
    if not contact:
        raise BadRequest("Contact not found")
    
    db.session.delete(contact)
    db.session.commit()

    # attempt to remove reciprocal mapping as well (ignore if not present)
    try:
        reciprocal = Contact.query.filter(
            Contact.user_id == contact_user_id,
            Contact.contact_user_id == user_id
        ).first()
        if reciprocal:
            db.session.delete(reciprocal)
            db.session.commit()
    except Exception as e:
        print(f"WARNING: failed to delete reciprocal contact: {e}")

    return {"message": "Contact removed successfully"}, 200
