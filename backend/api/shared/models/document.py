from sqlalchemy import (
    JSON,
    Boolean,
    ForeignKey,
    Index,
    Integer,
    String,
    Text,
)
from sqlalchemy.orm import (
    Mapped,
    backref,
    mapped_column,
    relationship,
)
from typing import TYPE_CHECKING, Any, Optional

from .base import BaseModel

if TYPE_CHECKING:
    from .project import Project
    from .user import User


class Document(BaseModel):
    """Document model"""

    __tablename__ = "documents"

    name: Mapped[str] = mapped_column(
        String,
        nullable=False,
        comment="Document name, 1-255 characters",
        index=True
    )
    
    project_id: Mapped[str] = mapped_column(
        String,
        ForeignKey("projects.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    
    parent_id: Mapped[Optional[str]] = mapped_column(
        String,
        ForeignKey("documents.id", ondelete="CASCADE"),
        nullable=True,
        index=True
    )
    
    type: Mapped[str] = mapped_column(
        String,
        nullable=False,
        comment="'file', 'folder', 'link'",
        index=True
    )

    content_type: Mapped[Optional[str]] = mapped_column(
        String,
        nullable=True,
        comment="MIME type for files"
    )

    size: Mapped[Optional[int]] = mapped_column(
        Integer,
        nullable=True,
        comment="Size in bytes for files"
    )

    url: Mapped[Optional[str]] = mapped_column(
        String,
        nullable=True,
        comment="For links or file URLs"
    )

    description: Mapped[Optional[str]] = mapped_column(
        Text,
        nullable=True
    )

    version: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        server_default="1"
    )

    creator_id: Mapped[str] = mapped_column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False
    )

    tags: Mapped[Optional[list[Any]]] = mapped_column(
        JSON,
        nullable=True,
        comment="Document tags for categorization"
    )

    meta_data: Mapped[Optional[dict[str, Any]]] = mapped_column(
        JSON,
        nullable=True,
        comment="Additional document metadata"
    )

    # Relationships
    project = relationship(
        "Project",
        back_populates="documents",
        passive_deletes=True
    )

    creator = relationship(
        "User",
        back_populates="documents",
        passive_deletes=True
    )

    versions = relationship(
        "DocumentVersion",
        back_populates="document",
        cascade="all, delete-orphan",
        order_by="DocumentVersion.version.desc()"
    )

    permissions = relationship(
        "DocumentPermission",
        back_populates="document",
        cascade="all, delete-orphan"
    )

    children = relationship(
        "Document",
        backref=backref(
            "parent",
            remote_side="Document.id",
            passive_deletes=True
        ),
        cascade="all, delete-orphan",
        order_by="Document.name.asc()"
    )


class DocumentVersion(BaseModel):
    """Document version model"""

    __tablename__ = "document_versions"

    document_id: Mapped[str] = mapped_column(
        String,
        ForeignKey("documents.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    version: Mapped[int] = mapped_column(
        Integer,
        nullable=False,
        server_default="1",
        index=True
    )

    size: Mapped[Optional[int]] = mapped_column(
        Integer,
        nullable=True,
        comment="Size in bytes"
    )

    content_type: Mapped[Optional[str]] = mapped_column(
        String,
        nullable=True,
        comment="MIME type"
    )

    url: Mapped[Optional[str]] = mapped_column(
        String,
        nullable=True,
        comment="Storage URL"
    )

    creator_id: Mapped[str] = mapped_column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False
    )

    changes: Mapped[Optional[str]] = mapped_column(
        Text,
        nullable=True,
        comment="Description of changes"
    )

    # Composite indices
    __table_args__ = (
        Index('ix_document_versions_doc_ver', 'document_id', 'version', unique=True),
    )

    # Relationships
    document = relationship(
        "Document",
        back_populates="versions",
        passive_deletes=True
    )

    creator = relationship(
        "User",
        back_populates="document_versions",
        passive_deletes=True
    )


class DocumentPermission(BaseModel):
    """Document permission model"""

    __tablename__ = "document_permissions"

    document_id: Mapped[str] = mapped_column(
        String,
        ForeignKey("documents.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )

    user_id: Mapped[Optional[str]] = mapped_column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=True,
        index=True
    )

    role_id: Mapped[Optional[str]] = mapped_column(
        String,
        ForeignKey("roles.id", ondelete="CASCADE"),
        nullable=True,
        index=True
    )

    can_view: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        server_default="TRUE",
        index=True
    )

    can_edit: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        server_default="FALSE",
        index=True
    )

    can_delete: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        server_default="FALSE",
        index=True
    )

    can_share: Mapped[bool] = mapped_column(
        Boolean,
        nullable=False,
        server_default="FALSE",
        index=True
    )

    # Composite indices
    __table_args__ = (
        Index('ix_doc_permissions_doc_user', 'document_id', 'user_id', unique=True),
        Index('ix_doc_permissions_doc_role', 'document_id', 'role_id', unique=True),
    )

    # Relationships
    document = relationship(
        "Document",
        back_populates="permissions",
        passive_deletes=True
    )
