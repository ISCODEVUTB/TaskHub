from sqlalchemy import Boolean, Column, ForeignKey, String, Table, JSON
from sqlalchemy.orm import relationship

from .base import Base, BaseModel

# Association table for user roles
user_roles = Table(
    "user_roles",
    Base.metadata,
    Column("user_id", String, ForeignKey("auth.users.id", ondelete="CASCADE"), primary_key=True),
    Column("role_id", String, ForeignKey("roles.id", ondelete="CASCADE"), primary_key=True),
)


class User(BaseModel):
    """User model"""

    __tablename__ = "auth.users"

    email = Column(String, unique=True, nullable=False, index=True)
    full_name = Column(String, nullable=False)
    company_name = Column(String, nullable=True)
    avatar_url = Column(String, nullable=True)
    is_active = Column(Boolean, nullable=False, server_default="TRUE")
    is_verified = Column(Boolean, nullable=False, server_default="FALSE")

    # Relationships
    roles = relationship("Role", secondary=user_roles, back_populates="users")
    projects = relationship("ProjectMember", back_populates="user")
    tasks_created = relationship(
        "Task", foreign_keys="Task.creator_id", back_populates="creator"
    )
    tasks_assigned = relationship(
        "Task", foreign_keys="Task.assignee_id", back_populates="assignee"
    )
    documents = relationship("Document", back_populates="creator")
    notifications = relationship("Notification", back_populates="user")
    external_connections = relationship("ExternalToolConnection", back_populates="user")
    activity_logs = relationship("ActivityLog", back_populates="user")
    notification_preferences = relationship("NotificationPreference", back_populates="user")


class Role(BaseModel):
    """Role model"""

    __tablename__ = "roles"

    name = Column(String, unique=True, nullable=False)
    description = Column(String, nullable=True)

    # Relationships
    users = relationship("User", secondary=user_roles, back_populates="roles")
    permissions = relationship("RolePermission", back_populates="role")


class RolePermission(BaseModel):
    """Role permission model"""

    __tablename__ = "role_permissions"

    role_id = Column(
        String,
        ForeignKey("roles.id", ondelete="CASCADE"),
        nullable=False
    )
    resource = Column(
        String,
        nullable=False,
        comment="e.g., 'project', 'document', etc."
    )
    action = Column(
        String,
        nullable=False,
        comment="e.g., 'create', 'read', 'update', 'delete'"
    )
    conditions = Column(
        JSON,
        nullable=True,
        comment="JSON object with additional permission conditions"
    )

    # Relationships
    role = relationship("Role", back_populates="permissions")
