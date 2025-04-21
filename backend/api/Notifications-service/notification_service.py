from utils.email_sender import send_email
from utils.push_sender import send_push_notification


class NotificationService:
    """
    Service class for handling notifications.

    This class provides methods to send email and push notifications
    using the underlying utility functions.
    """
    def send_email(self, to: str, subject: str, body: str) -> bool:
        """
        Sends an email notification.

        Args:
            to (str): The recipient's email address.
            subject (str): The subject of the email.
            body (str): The body content of the email.

        Returns:
            bool: True if the email was sent successfully, False otherwise.
        """
        return send_email(to, subject, body)

    def send_push(self, user_id: str, title: str, message: str) -> bool:
        """
        Sends a push notification.

        Args:
            user_id (str): The ID of the user to receive the notification.
            title (str): The title of the push notification.
            message (str): The message content of the push notification.

        Returns:
        bool:True if the push notification was sent successfully, False if not.
        """
        return send_push_notification(user_id, title, message)
