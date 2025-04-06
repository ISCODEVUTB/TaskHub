from pydantic import BaseModel


class ProjectBase(BaseModel):
    name: str
    description: str | None = None
    owner_id: int


class ProjectCreate(ProjectBase):
    pass


class ProjectOut(ProjectBase):
    id: int

    class Config:
        orm_mode = True
