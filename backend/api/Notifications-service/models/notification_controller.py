from fastapi import APIRouter, HTTPException
from notification_service import NotificationService
from schemas import EmailRequest, PushRequest

router = APIRouter()
service = NotificationService()


@router.post("/email")
def send_email(request: EmailRequest):
    success = service.send_email(request.to, request.subject, request.body)
    if not success:
        raise HTTPException(status_code=500, detail="Email failed to send")
    return {"message": "Email sent"}


@router.post("/push")
def send_push(request: PushRequest):
    success = service.send_push(
        request.user_id, request.title, request.message
    )
    if not success:
        raise HTTPException(status_code=500, detail="Push notification failed")
    return {"message": "Push notification sent"}
