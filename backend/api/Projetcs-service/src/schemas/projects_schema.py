from pydantic import BaseModel


class ProjectBase(BaseModel):
    name: str
    description: str | None = None
    owner_id: int


class ProjectCreate(ProjectBase):
    name: str
    description: str


class ProjectOut(ProjectBase):
    id: int
    owner_id: int

    class Config:
        orm_mode = True
