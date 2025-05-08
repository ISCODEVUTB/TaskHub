from routes.projects import router as projects_router
from routes.documents import router as documents_router
from routes.externaltools import router as externaltools_router
from routes.notification import router as notifications_router

__all__ = [
    "projects_router",
    "documents_router",
    "externaltools_router",
    "notifications_router",
    ]
