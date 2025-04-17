# app.py
from fastapi import FastAPI
from notification_controller import router

app = FastAPI()

app.include_router(router, prefix="")
