from typing import Tuple, Optional
from sqlalchemy import or_
from werkzeug.exceptions import BadRequest, Unauthorized

from .. import db
from ..models import User


def search_users(query: str, limit: int = 10) -> Tuple[dict, int]:
    """
    Tìm kiếm người dùng theo username hoặc số điện thoại.
    
    Args:
        query: Chuỗi tìm kiếm (username hoặc phone)
        limit: Số kết quả tối đa
    
    Returns:
        Dict chứa danh sách users tìm được
    """
    if not query or len(query.strip()) == 0:
        raise BadRequest("Search query is required")
    
    # Tìm kiếm theo username hoặc phone
    users: list = User.query.filter(
        or_(
            User.username.ilike(f"%{query}%"),
            User.phone.ilike(f"%{query}%")
        )
    ).limit(limit).all()
    
    return {
        "users": [user.to_dict() for user in users],
        "total": len(users)
    }, 200


def update_user_profile(user_id: int, data: dict) -> Tuple[dict, int]:
    """
    Cập nhật thông tin profile của người dùng.
    
    Có thể cập nhật:
    - avatar_url: URL ảnh đại diện
    - bio: Tiểu sử
    - phone: Số điện thoại
    
    Args:
        user_id: ID của người dùng
        data: Dict chứa các trường cần cập nhật
    
    Returns:
        Updated user info
    """
    user: Optional[User] = User.query.get(user_id)
    if not user:
        raise Unauthorized("User not found")
    
    # Cập nhật các trường nếu có
    if "avatar_url" in data:
        user.avatar_url = data['avatar_url']
    
    if "bio" in data:
        user.bio = data['bio']
    
    if "phone" in data:
        new_phone = data['phone']
        # Kiểm tra phone không bị trùng với user khác
        if new_phone:
            existing = User.query.filter(
                User.phone == new_phone,
                User.id != user_id
            ).first()
            if existing:
                raise BadRequest("Phone already exists")
        user.phone = new_phone
    
    db.session.commit()
    
    return {"user": user.to_dict()}, 200
