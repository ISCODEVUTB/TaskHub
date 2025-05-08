
from pydantic import BaseModel, ConfigDict
from typing import Optional


class DocumentBase(BaseModel):
    title: str
    content: str
    author: Optional[str] = None


class DocumentCreate(DocumentBase):
    pass


class Document(DocumentBase):
    id: int

    model_config = ConfigDict(
        from_attributes=True,
        json_schema_extra={
            "example": {
                "title": "Sample Document",
                "content": "This is a sample document content.",
                "author": "John Doe",
            }
        }
    )
