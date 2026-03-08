import requests
import json

BASE_URL = 'http://127.0.0.1:5000'

def test_notification_system():
    print("=== TESTING NOTIFICATION SYSTEM ===\n")

    # Step 1: Login to get tokens
    print("1. Logging in users...")
    login_data_1 = {"username": "testuser1", "password": "password123"}
    login_data_2 = {"username": "testuser2", "password": "password123"}

    try:
        resp1 = requests.post(f"{BASE_URL}/api/auth/login", json=login_data_1)
        resp2 = requests.post(f"{BASE_URL}/api/auth/login", json=login_data_2)

        if resp1.status_code != 200 or resp2.status_code != 200:
            print("❌ Login failed. Please ensure users exist in database.")
            return

        token1 = resp1.json()['access_token']
        token2 = resp2.json()['access_token']
        user1_id = resp1.json()['user']['id']
        user2_id = resp2.json()['user']['id']

        print(f"✅ User 1 (ID: {user1_id}) logged in")
        print(f"✅ User 2 (ID: {user2_id}) logged in\n")

        # Step 2: Send a message from User 1 to User 2
        print("2. Sending message from User 1 to User 2...")
        chat_id = min(user1_id, user2_id) * 1000000 + max(user1_id, user2_id)

        message_data = {
            "chat_id": chat_id,
            "sender_id": user1_id,
            "content": "Hello! This is a test notification message."
        }

        headers = {"Authorization": f"Bearer {token1}"}
        resp = requests.post(f"{BASE_URL}/api/messages", json=message_data, headers=headers)

        if resp.status_code == 201:
            message = resp.json()
            print(f"✅ Message sent successfully (ID: {message['id']})")
        else:
            print(f"❌ Failed to send message: {resp.status_code} - {resp.text}")
            return

        # Step 3: Check notifications for User 2
        print("\n3. Checking notifications for User 2...")
        headers2 = {"Authorization": f"Bearer {token2}"}
        resp = requests.get(f"{BASE_URL}/api/notifications", headers=headers2)

        if resp.status_code == 200:
            notifications = resp.json()
            print(f"✅ Found {len(notifications)} notifications")

            for notif in notifications:
                print(f"  - Notification ID: {notif['notification_id']}")
                print(f"    Message ID: {notif['message_id']}")
                print(f"    Sender: {notif['sender_name']}")
                print(f"    Content: {notif['content']}")
                print(f"    Is Read: {notif['is_read']}")
                print(f"    Created: {notif['created_at']}")
        else:
            print(f"❌ Failed to get notifications: {resp.status_code} - {resp.text}")

        # Step 4: Check unread count
        print("\n4. Checking unread notification count...")
        resp = requests.get(f"{BASE_URL}/api/notifications/unread/count", headers=headers2)

        if resp.status_code == 200:
            count = resp.json()['unread_count']
            print(f"✅ Unread notifications: {count}")
        else:
            print(f"❌ Failed to get count: {resp.status_code} - {resp.text}")

        print("\n=== TEST COMPLETED SUCCESSFULLY ===")

    except Exception as e:
        print(f"❌ Test failed with error: {e}")

if __name__ == "__main__":
    test_notification_system()