"""
Utilities module for the Notifications service.

This module provides utility functions for sending emails, push notifications,
and listening to message queues.

Exports:
    - send_email: Function to send an email.
    - send_push_notification: Function to send a push notification.
    - start_listening: Function to start listening to a message queue.
"""
from utils.email_sender import send_email
from utils.push_sender import send_push_notification
from utils.mq_listener import start_listener

__all__ = [
    "send_email",
    "send_push_notification",
    "start_listener"
]
