from sqlalchemy import (
    JSON,
    Boolean,
    Column,
    DateTime,
    ForeignKey,
    Integer,
    String,
)
from sqlalchemy.orm import relationship
from typing import TYPE_CHECKING

from .base import BaseModel

if TYPE_CHECKING:
    from .user import User


class OAuthProvider(BaseModel):
    """OAuth provider model"""

    __tablename__ = "oauth_providers"

    name = Column(String, nullable=False)
    type = Column(
        String,
        nullable=False,
        comment="'github', 'google_drive', 'dropbox', etc.",
        index=True
    )
    auth_url = Column(
        String,
        nullable=False,
        comment="OAuth authorization endpoint"
    )
    token_url = Column(
        String,
        nullable=False,
        comment="OAuth token endpoint"
    )
    scope = Column(
        String,
        nullable=False,
        comment="Space-separated list of required scopes"
    )
    client_id = Column(String, nullable=False)
    client_secret = Column(String, nullable=False)
    redirect_uri = Column(
        String,
        nullable=False,
        comment="OAuth callback URL"
    )
    additional_params = Column(
        JSON,
        nullable=True,
        comment="Additional OAuth configuration parameters"
    )

    # Relationships
    connections = relationship("ExternalToolConnection", back_populates="provider")


class ExternalToolConnection(BaseModel):
    """External tool connection model"""

    __tablename__ = "external_tool_connections"

    user_id = Column(
        String,
        ForeignKey("auth.users.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    provider_id = Column(
        String,
        ForeignKey("oauth_providers.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    access_token = Column(String, nullable=False)
    refresh_token = Column(String, nullable=True)
    token_type = Column(String, nullable=True)
    scope = Column(String, nullable=True)
    account_name = Column(String, nullable=True)
    account_email = Column(String, nullable=True)
    account_id = Column(String, nullable=True)
    is_active = Column(
        Boolean,
        nullable=False,
        server_default="TRUE",
        index=True
    )
    meta_data = Column(JSON, nullable=True)
    last_used_at = Column(DateTime(timezone=True), nullable=True)
    expires_at = Column(DateTime(timezone=True), nullable=True)

    # Relationships
    user = relationship(
        "User",
        back_populates="external_connections",
        passive_deletes=True
    )
    provider = relationship(
        "OAuthProvider",
        back_populates="connections",
        passive_deletes=True
    )
    resources = relationship(
        "ExternalResource",
        back_populates="connection",
        cascade="all, delete-orphan"
    )


class ExternalResource(BaseModel):
    """External resource model"""

    __tablename__ = "external_resources"

    connection_id = Column(
        String,
        ForeignKey("external_tool_connections.id", ondelete="CASCADE"),
        nullable=False,
        index=True
    )
    resource_id = Column(
        String,
        nullable=False,
        comment="ID in the external system",
        index=True
    )
    name = Column(String, nullable=False)
    type = Column(
        String,
        nullable=False,
        comment="'file', 'folder', 'repository', etc.",
        index=True
    )
    url = Column(String, nullable=True)
    path = Column(String, nullable=True)
    size = Column(Integer, nullable=True)
    last_modified = Column(DateTime(timezone=True), nullable=True)
    meta_data = Column(JSON, nullable=True)
    sync_enabled = Column(
        Boolean,
        nullable=False,
        server_default="FALSE",
        index=True
    )
    sync_direction = Column(
        String,
        nullable=True,
        comment="'download', 'upload', 'bidirectional'"
    )
    sync_interval = Column(
        Integer,
        nullable=True,
        comment="in minutes"
    )
    last_synced_at = Column(DateTime(timezone=True), nullable=True)
    project_id = Column(
        String,
        ForeignKey("projects.id", ondelete="SET NULL"),
        nullable=True,
        index=True
    )
    document_id = Column(
        String,
        ForeignKey("documents.id", ondelete="SET NULL"),
        nullable=True,
        index=True
    )

    # Relationships
    connection = relationship(
        "ExternalToolConnection",
        back_populates="resources",
        passive_deletes=True
    )
