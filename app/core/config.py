from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "VisitTracker"
    version: str = "1.0.0"
    author: str = "Sni"
    debug: bool = True

settings = Settings()
