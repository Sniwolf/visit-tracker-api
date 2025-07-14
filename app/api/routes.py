from fastapi import APIRouter
from app.services.visits import increment_counter
from app.models.responses import VisitsResponse, InfoResponse
from app.services.info import app_info
from app.core.state import start_time

router = APIRouter()

counter = 0  # just for now

@router.get("/")
def root():
    return {"status": "visit-tracker-api is running"}

@router.get("/health")
def health_check():
    return {"status": "ok"}

@router.get("/ready")
def readiness_check():
    return {"status": "ready"}

@router.get("/visits", response_model=VisitsResponse)
def visits():
    global counter
    counter = increment_counter(counter)
    return {"count": counter}

@router.get("/info", response_model=InfoResponse)
def info():
    return app_info(start_time=start_time)