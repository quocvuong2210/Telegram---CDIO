from flask import Blueprint, jsonify, request
from flask_jwt_extended import jwt_required, get_jwt_identity
from werkzeug.exceptions import BadRequest, NotFound, Unauthorized
from sqlalchemy import and_

from .. import db
from ..models import Notification, Message, User
from ..controllers.auth_controller import get_current_user

notification_bp = Blueprint("notifications", __name__)


@notification_bp.route("/notifications", methods=["GET"])
@jwt_required()
def get_notifications():
    """Get all notifications for the current user"""
    user_id = get_jwt_identity()
    current_user = get_current_user(user_id)
    
    try:
        # Get unread notifications with associated message information
        notifications = db.session.query(
            Notification,
            Message,
            User
        ).join(
            Message, Notification.message_id == Message.id
        ).join(
            User, Message.sender_id == User.id
        ).filter(
            Notification.user_id == current_user.id
        ).order_by(Notification.created_at.desc()).all()

        result = []
        for notification, message, sender in notifications:
            result.append({
                'notification_id': notification.id,
                'message_id': message.id,
                'sender_id': sender.id,
                'sender_name': sender.username or sender.name,
                'sender_avatar': sender.avatar_url,
                'content': message.content,
                'is_read': notification.is_read,
                'created_at': notification.created_at.isoformat()
            })

        return jsonify(result), 200
    except Exception as e:
        print(f"ERROR: Failed to get notifications: {str(e)}")
        raise BadRequest(f"Error fetching notifications: {str(e)}")


@notification_bp.route("/notifications/unread/count", methods=["GET"])
@jwt_required()
def get_unread_notifications_count():
    """Get count of unread notifications for the current user"""
    user_id = get_jwt_identity()
    current_user = get_current_user(user_id)
    
    try:
        unread_count = Notification.query.filter(
            and_(
                Notification.user_id == current_user.id,
                Notification.is_read == False
            )
        ).count()
        
        return jsonify({'unread_count': unread_count}), 200
    except Exception as e:
        print(f"ERROR: Failed to get unread count: {str(e)}")
        raise BadRequest(f"Error fetching unread count: {str(e)}")


@notification_bp.route("/notifications/<int:notification_id>/read", methods=["PUT"])
@jwt_required()
def mark_notification_as_read(notification_id):
    """Mark a notification as read"""
    user_id = get_jwt_identity()
    current_user = get_current_user(user_id)
    
    try:
        notification = Notification.query.get(notification_id)
        
        if not notification:
            raise NotFound("Notification not found")
        
        if notification.user_id != current_user.id:
            raise Unauthorized("You cannot mark this notification as read")
        
        notification.is_read = True
        db.session.commit()
        
        return jsonify(notification.to_dict()), 200
    except (NotFound, Unauthorized) as e:
        raise e
    except Exception as e:
        db.session.rollback()
        print(f"ERROR: Failed to mark notification as read: {str(e)}")
        raise BadRequest(f"Error marking notification as read: {str(e)}")


@notification_bp.route("/notifications/read-all", methods=["PUT"])
@jwt_required()
def mark_all_notifications_as_read():
    """Mark all notifications as read for the current user"""
    user_id = get_jwt_identity()
    current_user = get_current_user(user_id)
    
    try:
        notifications = Notification.query.filter(
            and_(
                Notification.user_id == current_user.id,
                Notification.is_read == False
            )
        ).all()
        
        for notification in notifications:
            notification.is_read = True
        
        db.session.commit()
        
        return jsonify({
            'message': f'Marked {len(notifications)} notifications as read',
            'count': len(notifications)
        }), 200
    except Exception as e:
        db.session.rollback()
        print(f"ERROR: Failed to mark all notifications as read: {str(e)}")
        raise BadRequest(f"Error marking notifications as read: {str(e)}")


@notification_bp.route("/notifications/by-sender/<int:sender_id>", methods=["GET"])
@jwt_required()
def get_notifications_by_sender(sender_id):
    """Get all unread notifications from a specific sender"""
    user_id = get_jwt_identity()
    current_user = get_current_user(user_id)
    
    try:
        notifications = db.session.query(
            Notification,
            Message
        ).join(
            Message, Notification.message_id == Message.id
        ).filter(
            and_(
                Notification.user_id == current_user.id,
                Message.sender_id == sender_id,
                Notification.is_read == False
            )
        ).order_by(Notification.created_at.desc()).all()

        result = []
        for notification, message in notifications:
            result.append({
                'notification_id': notification.id,
                'message_id': message.id,
                'content': message.content,
                'is_read': notification.is_read,
                'created_at': notification.created_at.isoformat()
            })

        return jsonify(result), 200
    except Exception as e:
        print(f"ERROR: Failed to get notifications by sender: {str(e)}")
        raise BadRequest(f"Error fetching notifications: {str(e)}")
