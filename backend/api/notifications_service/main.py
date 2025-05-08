"""
Main module for the Notifications service API.

This module defines the FastAPI application and its routes for sending emails
and push notifications. It uses the NotificationService to handle the actual
sending of notifications.

Routes:
    - POST /email: Sends an email notification.
    - POST /push: Sends a push notification.
"""

import os
import sys
from dotenv import load_dotenv

from fastapi import FastAPI, APIRouter, HTTPException
from notification import NotificationService
from src import EmailRequest, PushRequest

sys.path.append(os.path.dirname(os.path.abspath(__file__)))
load_dotenv()
app = FastAPI(title="Notifications Service",
              version="1.0.0",
              description="Service for sending notifications",
              docs_url="/docs")
router = APIRouter()
service = NotificationService()


@router.get("/")
def read_root():
    """
    Root endpoint for the Notifications service.

    Returns:
        dict: A welcome message indicating that the service is running.
    """
    return {"message": "Welcome to the Notifications Service"}


@router.post("/email")
def send_email(request: EmailRequest):
    """
    Endpoint to send an email notification.

    Args:
    request (EmailRequest): The email request containing subject, and body.

    Returns:
        dict: A success message if the email is sent successfully.

    Raises:
        HTTPException: If the email fails to send.
    """
    success = service.send_email(request.to, request.subject, request.body)
    if not success:
        raise HTTPException(status_code=500, detail="Failed to send email")
    return {"message": "Email sent"}


@router.post("/push")
def send_push(request: PushRequest):
    """
    Endpoint to send a push notification.

    Args:
    request(PushRequest): The push request containing user ID and message.

    Returns:
        dict: A success message if the push notification is sent successfully.

    Raises:
        HTTPException: If the push notification fails to send.
    """
    success = service.send_push(
        request.user_id, request.title, request.message)
    if not success:
        raise HTTPException(
            status_code=500, detail="Failed to send push notification")
    return {"message": "Push notification sent"}


app.include_router(router)


if __name__ == "__main__":
    """
    Entry point for running the FastAPI application.
    """
    import uvicorn
    uvicorn.run(app, host=str(os.getenv("HOST")),
                port=int(os.getenv("PORT")),
                log_level="info")
