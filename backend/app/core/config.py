import os
from dotenv import load_dotenv

load_dotenv()

class Settings:
  DB_USER=os.getenv('DB_USER')
  DB_PASSWORD=os.getenv('DB_PASSWORD')
  DB_HOST = os.getenv('DB_HOST')
  DB_NAME = os.getenv('DB_NAME')

  SECRET_KEY = os.getenv("SECRET_KEY",'supersecretkey')
  ALGORITHM = "HS256"
  ACCESS_TOKEN_EXPIRE_MINUTES = 60

settings = Settings()  