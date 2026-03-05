from typing import Tuple, Optional

from werkzeug.exceptions import BadRequest, Unauthorized

from .. import db
from ..models import User


def register_user(data: dict) -> Tuple[dict, int]:
    """
    Đăng ký user mới phù hợp cấu trúc bảng `users`.

    Yêu cầu:
    - username: bắt buộc, duy nhất
    - password: bắt buộc
    - email hoặc phone: ít nhất một trong hai (có thể cả hai)
    Trường tùy chọn:
    - avatar_url, bio
    """
    username = data.get("username")
    email = data.get("email")
    phone = data.get("phone")
    password = data.get("password")
    avatar_url = data.get("avatar_url")
    bio = data.get("bio")

    if not username or not password:
        raise BadRequest("username and password are required")

    if not email and not phone:
        raise BadRequest("At least one of email or phone is required")

    # Kiểm tra trùng lặp theo cấu trúc bảng
    existing_user: Optional[User] = User.query.filter(
        (User.username == username)
        | ((email is not None) & (User.email == email))
        | ((phone is not None) & (User.phone == phone))
    ).first()

    if existing_user:
        # Thông báo cụ thể hơn nếu có thể
        if existing_user.username == username:
            message = "Username already exists"
        elif email and existing_user.email == email:
            message = "Email already exists"
        elif phone and existing_user.phone == phone:
            message = "Phone already exists"
        else:
            message = "User with given credentials already exists"
        raise BadRequest(message)

    user = User(
        username=username,
        email=email,
        phone=phone,
        avatar_url=avatar_url,
        bio=bio,
    )
    user.set_password(password)

    db.session.add(user)
    db.session.commit()

    return {"user": user.to_dict()}, 201


def authenticate_user(data: dict) -> Tuple[dict, int]:
    """
    Đăng nhập bằng username, email hoặc phone.

    Body chấp nhận một trong các trường:
    - username
    - email
    - phone
    hoặc trường chung:
    - identifier (giá trị có thể là username/email/phone)
    """
    identifier = (
        data.get("identifier")
        or data.get("username")
        or data.get("email")
        or data.get("phone")
    )
    password = data.get("password")

    if not identifier or not password:
        raise BadRequest("identifier/username/email/phone and password are required")

    user: Optional[User] = User.query.filter(
        (User.username == identifier)
        | (User.email == identifier)
        | (User.phone == identifier)
    ).first()

    if not user or not user.check_password(password):
        raise Unauthorized("Invalid credentials")

    # Cập nhật trạng thái online và last_seen
    user.mark_online()
    db.session.commit()

    return {"user": user.to_dict()}, 200

