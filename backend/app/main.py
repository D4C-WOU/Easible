from app.api.routes import requirements
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.db.database import Base, engine
from app.api.routes import auth, category, panic , admin, slot, booking, complaint, crowd, facility, booking_requests

Base.metadata.create_all(bind=engine)

app = FastAPI(title='Easible API')

origins = [
    "http://localhost:58903",
    "http://127.0.0.1:58903",
    "*"  # for dev (optional but easiest)
]


app.add_middleware(
    CORSMiddleware,
    allow_origin_regex=r"http://(localhost|127\.0\.0\.1):[0-9]+",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)
# routers
app.include_router(auth.router)
app.include_router(category.router)
app.include_router(panic.router)
app.include_router(admin.router)
app.include_router(slot.router)
app.include_router(booking.router)
app.include_router(complaint.router)
app.include_router(crowd.router)
app.include_router(requirements.router)
app.include_router(facility.router)
app.include_router(booking_requests.router)

@app.get('/')
def root():
    return {'message': 'Easible backend is running'}