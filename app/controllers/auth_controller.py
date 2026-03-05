from typing import Tuple, Optional

from werkzeug.exceptions import BadRequest, Unauthorized

from .. import db
from ..models import User


def register_user(data: dict) -> Tuple[dict, int]:
    username = data.get("username")
    email = data.get("email")
    password = data.get("password")

    if not username or not email or not password:
        raise BadRequest("username, email, password are required")

    if User.query.filter((User.username == username) | (User.email == email)).first():
        raise BadRequest("Username or email already exists")

    user = User(username=username, email=email)
    user.set_password(password)

    db.session.add(user)
    db.session.commit()

    return {"user": user.to_dict()}, 201


def authenticate_user(data: dict) -> Tuple[dict, int]:
    username_or_email = data.get("username") or data.get("email")
    password = data.get("password")

    if not username_or_email or not password:
        raise BadRequest("username/email and password are required")

    user: Optional[User] = User.query.filter(
        (User.username == username_or_email) | (User.email == username_or_email)
    ).first()

    if not user or not user.check_password(password):
        raise Unauthorized("Invalid credentials")

    return {"user": user.to_dict()}, 200

