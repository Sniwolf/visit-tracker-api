from app.models.responses import InfoResponse

def app_info(start_time: float) -> InfoResponse:
    from app.core.config import settings
    import time

    return InfoResponse(
        app_name=settings.app_name,
        version=settings.version,
        author=settings.author,
        uptime=int(time.time() - start_time),
        environment=settings.environment,
        secret_token=settings.secret_token
    )