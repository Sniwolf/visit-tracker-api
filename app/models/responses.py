from pydantic import BaseModel

class VisitsResponse(BaseModel):
    count: int

class InfoResponse(BaseModel):
    app_name: str
    version: str
    author: str = "Your Name"
    uptime: int
    environment: str
    secret_token: str
