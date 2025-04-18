from pydantic import BaseModel


class EmailRequest(BaseModel):
    """
    Schema for an email request.

    Attributes:
        to (str): The recipient's email address.
        subject (str): The subject of the email.
        body (str): The body content of the email.
    """
    to: str
    subject: str
    body: str


class PushRequest(BaseModel):
    """
    Schema for a push notification request.

    Attributes:
        user_id (str): The ID of the user to receive the notification.
        title (str): The title of the push notification.
        message (str): The message content of the push notification.
    """
    user_id: str
    title: str
    message: str
