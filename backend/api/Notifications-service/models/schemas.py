from pydantic import BaseModel


class EmailRequest(BaseModel):
    to: str
    subject: str
    body: str


class PushRequest(BaseModel):
    user_id: str
    title: str
    message: str
