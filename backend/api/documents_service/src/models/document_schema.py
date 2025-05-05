
from pydantic import BaseModel
from typing import Optional


class DocumentBase(BaseModel):
    title: str
    content: str
    author: Optional[str] = None


class DocumentCreate(DocumentBase):
    pass


class Document(DocumentBase):
    id: int

    class Config:
        orm_mode = True
        schema_extra = {
            "example": {
                "title": "Sample Document",
                "content": "This is a sample document content.",
                "author": "John Doe",
            }
        }
