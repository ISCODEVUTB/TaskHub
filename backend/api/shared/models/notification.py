from sqlalchemy import (
    JSON,
    Boolean,
    Column,
    DateTime,
    ForeignKey,
    String,
    Text,
)
from sqlalchemy.orm import relationship
from typing import TYPE_CHECKING

from .base import BaseModel

if TYPE_CHECKING:
    from .user import User  # noqa: F401


class Notification(BaseModel):
    """Notification model"""

    __tablename__ = "notifications"

    user_id = Column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    type = Column(
        String,
        nullable=False,
        comment="'system', 'project', 'task', 'document', etc.",
        index=True
    )
    title = Column(String, nullable=False)
    message = Column(Text, nullable=False)
    priority = Column(
        String,
        nullable=False,
        server_default="'normal'",
        comment="'low', 'normal', 'high'"
    )
    channels = Column(
        JSON,
        nullable=False,
        comment="['in_app', 'email', 'push', 'sms']"
    )
    related_entity_type = Column(
        String,
        nullable=True,
        comment="'project', 'task', 'document', etc.",
        index=True
    )
    related_entity_id = Column(
        String,
        nullable=True,
        index=True
    )
    action_url = Column(String, nullable=True)
    meta_data = Column(JSON, nullable=True)
    is_read = Column(
        Boolean,
        nullable=False,
        server_default="FALSE",
        index=True
    )
    read_at = Column(
        DateTime(timezone=True),
        nullable=True
    )
    scheduled_at = Column(
        DateTime(timezone=True),
        nullable=True,
        comment="For scheduled notifications",
        index=True
    )
    sent_at = Column(DateTime, nullable=True)  # When the notification was actually sent

    # Relationships
    user = relationship("User", back_populates="notifications")


class NotificationPreference(BaseModel):
    """Notification preference model"""

    __tablename__ = "notification_preferences"

    user_id = Column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False,
        unique=True,
        index=True
    )
    email_enabled = Column(
        Boolean,
        nullable=False,
        server_default="TRUE"
    )
    push_enabled = Column(
        Boolean,
        nullable=False,
        server_default="TRUE"
    )
    sms_enabled = Column(
        Boolean,
        nullable=False,
        server_default="FALSE"
    )
    in_app_enabled = Column(
        Boolean,
        nullable=False,
        server_default="TRUE"
    )
    digest_enabled = Column(
        Boolean,
        nullable=False,
        server_default="FALSE"
    )
    digest_frequency = Column(
        String,
        nullable=True,
        comment="'daily', 'weekly'"
    )
    quiet_hours_enabled = Column(
        Boolean,
        nullable=False,
        server_default="FALSE"
    )
    quiet_hours_start = Column(
        String,
        nullable=True,
        comment="HH:MM format"
    )
    quiet_hours_end = Column(
        String,
        nullable=True,
        comment="HH:MM format"
    )
    preferences_by_type = Column(
        JSON,
        nullable=True,
        comment="Type -> Channel -> Enabled"
    )

    # Relationships
    user = relationship(
        "User",
        back_populates="notification_preferences",
        cascade="all, delete-orphan"
    )
