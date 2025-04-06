from utils.email_sender import send_email
from utils.push_sender import send_push_notification

class NotificationService:
    def send_email(self, to: str, subject: str, body: str) -> bool:
        return send_email(to, subject, body)

    def send_push(self, user_id: str, title: str, message: str) -> bool:
        return send_push_notification(user_id, title, message)
