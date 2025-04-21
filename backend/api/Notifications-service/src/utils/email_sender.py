import smtplib
from email.mime.text import MIMEText

SMTP_SERVER = "smtp.gmail.com"
SMTP_PORT = 587
SMTP_USER = "tu-email@gmail.com"
SMTP_PASSWORD = "tu-contraseña"


def send_email(to: str, subject: str, body: str) -> bool:
    """
    Sends an email using the configured SMTP server.

    Args:
        to (str): The recipient's email address.
        subject (str): The subject of the email.
        body (str): The body content of the email.

    Returns:
        bool: True if the email was sent successfully, False otherwise.
    """
    try:
        msg = MIMEText(body)
        msg["Subject"] = subject
        msg["From"] = SMTP_USER
        msg["To"] = to

        server = smtplib.SMTP(SMTP_SERVER, SMTP_PORT)
        server.starttls()
        server.login(SMTP_USER, SMTP_PASSWORD)
        server.sendmail(SMTP_USER, [to], msg.as_string())
        server.quit()
        return True
    except Exception as e:
        print(f"Error sending email: {e}")
        return False
