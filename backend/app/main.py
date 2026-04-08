from fastapi import FastAPI
from app.db.database import Base,engine
from app.api.routes import auth

Base.metadata.create_all(bind = engine)

app = FastAPI(title='Easible API')

app.include_router(auth.router)

@app.get('/')
def root():
  return {'message':'Easible backend is running'}