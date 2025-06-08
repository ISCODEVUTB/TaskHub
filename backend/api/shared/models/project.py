from sqlalchemy import (
    JSON,
    Column,
    DateTime,
    ForeignKey,
    String,
    Text,
    func,
)
from sqlalchemy.orm import relationship, Mapped, mapped_column
from typing import TYPE_CHECKING, Optional, List

from .base import BaseModel

if TYPE_CHECKING:
    from .user import User
    from .document import Document
    from .activity_log import ActivityLog


class Project(BaseModel):
    """Project model"""

    __tablename__ = "projects"

    name = Column(String, nullable=False)
    description = Column(Text, nullable=True)
    owner_id = Column(String, ForeignKey("auth.users.id", ondelete="CASCADE"), nullable=False)
    status = Column(String, nullable=False, server_default="planning")
    start_date = Column(DateTime(timezone=True), nullable=True)
    end_date = Column(DateTime(timezone=True), nullable=True)
    tags = Column(JSON, nullable=True)
    meta_data = Column(JSON, nullable=True)

    # Relationships
    members = relationship("ProjectMember", back_populates="project", cascade="all, delete-orphan")
    tasks = relationship("Task", back_populates="project", cascade="all, delete-orphan")
    documents = relationship("Document", back_populates="project", cascade="all, delete-orphan")
    activity_logs = relationship("ActivityLog", back_populates="project", cascade="all, delete-orphan")


class ProjectMember(BaseModel):
    """Project member model"""

    __tablename__ = "project_members"

    project_id = Column(String, ForeignKey("projects.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(String, ForeignKey("auth.users.id", ondelete="CASCADE"), nullable=False)
    role = Column(
        String, nullable=False, server_default="member"
    )  # 'owner', 'admin', 'member'
    joined_at = Column(DateTime(timezone=True), nullable=False, server_default="CURRENT_TIMESTAMP")

    # Relationships
    project = relationship("Project", back_populates="members")
    user = relationship("User", back_populates="projects")


class Task(BaseModel):
    """Task model"""

    __tablename__ = "tasks"

    title = Column(
        String,
        nullable=False,
        comment="Task title, 3-100 characters"
    )
    description = Column(
        Text,
        nullable=True,
        comment="Detailed task description"
    )
    project_id = Column(
        String,
        ForeignKey("projects.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    creator_id = Column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    assignee_id = Column(
        String,
        ForeignKey("auth.users.id", ondelete="SET NULL"),
        nullable=True,
        index=True
    )
    due_date = Column(
        DateTime(timezone=True),
        nullable=True,
        index=True
    )
    priority = Column(
        String,
        nullable=False,
        server_default="'medium'",
        comment="'low', 'medium', 'high'",
        index=True
    )
    status = Column(
        String,
        nullable=False,
        server_default="'todo'",
        comment="'todo', 'in_progress', 'review', 'done'",
        index=True
    )
    tags = Column(
        JSON,
        nullable=True,
        comment="List of tags for categorization"
    )
    meta_data = Column(
        JSON,
        nullable=True,
        comment="Additional task metadata"
    )

    # Relationships
    project = relationship(
        "Project",
        back_populates="tasks",
        passive_deletes=True
    )
    creator = relationship(
        "User",
        foreign_keys=[creator_id],
        back_populates="tasks_created",
        passive_deletes=True
    )
    assignee = relationship(
        "User",
        foreign_keys=[assignee_id],
        back_populates="tasks_assigned",
        passive_deletes=True
    )
    comments = relationship(
        "TaskComment",
        back_populates="task",
        cascade="all, delete-orphan",
        order_by="TaskComment.created_at.desc()"
    )


class TaskComment(BaseModel):
    """Task comment model"""

    __tablename__ = "task_comments"

    task_id: Mapped[str] = mapped_column(
        ForeignKey("tasks.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    
    user_id: Mapped[str] = mapped_column(
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    
    content: Mapped[str] = mapped_column(
        Text,
        nullable=False,
        comment="Comment content"
    )
    
    parent_id: Mapped[Optional[str]] = mapped_column(
        ForeignKey("task_comments.id", ondelete="CASCADE"),
        nullable=True,
        index=True,
        comment="Parent comment ID for replies"
    )

    # Relationships
    task: Mapped["Task"] = relationship(
        "Task",
        back_populates="comments",
        passive_deletes=True
    )
    
    parent: Mapped[Optional["TaskComment"]] = relationship(
        "TaskComment",
        back_populates="replies",
        remote_side=[id]
    )
    
    replies: Mapped[List["TaskComment"]] = relationship(
        "TaskComment",
        back_populates="parent",
        order_by="TaskComment.created_at.asc()",
        cascade="all, delete-orphan"
    )


class ActivityLog(BaseModel):
    """Activity log model"""

    __tablename__ = "activity_logs"

    project_id = Column(
        String,
        ForeignKey("projects.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    user_id = Column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    action = Column(
        String,
        nullable=False,
        index=True,
        comment="Action performed (create, update, delete, etc.)"
    )
    entity_type = Column(
        String,
        nullable=True,
        index=True,
        comment="Type of entity affected (project, task, etc.)"
    )
    entity_id = Column(
        String,
        nullable=True,
        index=True,
        comment="ID of affected entity"
    )
    details = Column(
        JSON,
        nullable=True,
        comment="Additional action details"
    )
    ip_address = Column(
        String,
        nullable=True,
        comment="Client IP address"
    )
    user_agent = Column(
        Text,
        nullable=True,
        comment="Client user agent"
    )

    # Relationships
    project = relationship(
        "Project",
        back_populates="activity_logs",
        passive_deletes=True
    )
    user = relationship(
        "User",
        back_populates="activity_logs",
        passive_deletes=True
    )
