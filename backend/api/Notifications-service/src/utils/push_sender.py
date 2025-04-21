import firebase_admin
from firebase_admin import messaging, credentials


cred = credentials.Certificate("firebase_credentials.json")
firebase_admin.initialize_app(cred)


def send_push_notification(user_id: str, title: str, message: str) -> bool:
    """
    Sends a push notification to a specific user using Firebase Cloud Messaging

    Args:
        user_id (str): The ID of the user to receive the notification.
        title (str): The title of the push notification.
        message (str): The message content of the push notification.

    Returns:
    bool: True if the push notification was sent successfully, False otherwise.
    """
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
