from fastapi import FastAPI
from notification_controller import router as notification_router
import utils.mq_listener as mq_listener

app = FastAPI()

app.include_router(notification_router)


@app.on_event("startup")
async def startup_event():

    mq_listener.start_listener()
