import os
import logging
#from flask_caching.backends.redis import RedisCache
from celery.schedules import crontab

# Log level configurável
LOG_LEVEL = getattr(logging, os.getenv("SUPERSET_LOG_LEVEL", "INFO").upper(), logging.INFO)

# Configurações do banco de metadados do Superset
SQLALCHEMY_DATABASE_URI = 'postgresql://superset:supersetpass@postgres:5432/superset'

# Chave de segurança obrigatória para produção
SECRET_KEY = os.getenv("SUPERSET_SECRET_KEY", "teste123")

# Redis para cache e tarefas assíncronas (via Celery)
REDIS_HOST = os.getenv("REDIS_HOST", "redis")
REDIS_PORT = os.getenv("REDIS_PORT", "6379")
REDIS_CELERY_DB = os.getenv("REDIS_CELERY_DB", "0")
REDIS_RESULTS_DB = os.getenv("REDIS_RESULTS_DB", "1")

CACHE_CONFIG = {
    "CACHE_TYPE": "RedisCache",
    "CACHE_DEFAULT_TIMEOUT": 300,
    "CACHE_KEY_PREFIX": "superset_",
    "CACHE_REDIS_HOST": REDIS_HOST,
    "CACHE_REDIS_PORT": REDIS_PORT,
    "CACHE_REDIS_DB": REDIS_RESULTS_DB,
}
DATA_CACHE_CONFIG = CACHE_CONFIG
THUMBNAIL_CACHE_CONFIG = CACHE_CONFIG

# Celery para agendamento de relatórios e tarefas
class CeleryConfig:
    broker_url = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_CELERY_DB}"
    result_backend = f"redis://{REDIS_HOST}:{REDIS_PORT}/{REDIS_RESULTS_DB}"
    imports = (
        "superset.sql_lab",
        "superset.tasks.scheduler",
        "superset.tasks.thumbnails",
        "superset.tasks.cache",
    )
    beat_schedule = {
        "reports.scheduler": {
            "task": "reports.scheduler",
            "schedule": crontab(minute="*", hour="*"),
        },
        "reports.prune_log": {
            "task": "reports.prune_log",
            "schedule": crontab(minute=10, hour=0),
        },
    }

CELERY_CONFIG = CeleryConfig

# Segurança e CSRF
WTF_CSRF_ENABLED = True
WTF_CSRF_EXEMPT_LIST = []
WTF_CSRF_TIME_LIMIT = 60 * 60 * 24 * 365

# Limite padrão de linhas em consultas
ROW_LIMIT = 5000

# API Key do Mapbox (opcional, necessário para mapas)
MAPBOX_API_KEY = os.getenv("MAPBOX_API_KEY", "")

# Feature Flags
FEATURE_FLAGS = {
    "ALERT_REPORTS": True,
}

# URL base para relatórios e webdrivers
WEBDRIVER_BASEURL_USER_FRIENDLY = "http://localhost:8088/"
