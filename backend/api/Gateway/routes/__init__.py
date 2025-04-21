from .projects import router as projects_router
from .documents import router as documents_router
from .externaltools import router as externaltools_router
from .notification import router as notifications_router

__all__ = [
    "projects_router",
    "documents_router",
    "externaltools_router",
    "notifications_router",
    ]
