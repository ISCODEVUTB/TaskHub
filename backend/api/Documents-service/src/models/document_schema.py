

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
   