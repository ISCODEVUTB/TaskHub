import firebase_admin
from firebase_admin import messaging, credentials


cred = credentials.Certificate("firebase_credentials.json")
firebase_admin.initialize_app(cred)


def send_push_notification(user_id: str, title: str, message: str) -> bool:
    try:
        message = messaging.Message(
            notification=messaging.Notification(
                title=title,
                body=message,
            ),
            topic=user_id
        )
        response = messaging.send(message)
        print(f"Push sent: {response}")
        return True
    except Exception as e:
        print(f"Error sending push: {e}")
        return False
