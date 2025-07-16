from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    app_name: str = "VisitTracker"
    version: str = "1.0.0"
    author: str = "Sni"
    debug: bool = True
    environment: str = "unknown"
    secret_key: str = "defaultsecret"
    database_password: str = "changeme"

    class Config:
        env_file = ".env"
        env_prefix = ""
        case_sensitive = False

settings = Settings()
