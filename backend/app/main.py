from app.api.routes import requirements
from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.db.database import Base, engine
from app.api.routes import auth, category, panic , admin, slot, booking, complaint, crowd, facility, booking_requests

# Explicitly import all models to register them with metadata
from app.models.user import User
from app.models.category import Category
from app.models.facility import Facility
from app.models.requirement import Requirement
from app.models.slot import Slot
from app.models.booking import Booking
from app.models.complaint import Complaint
from app.models.booking_requests import BookingRequest
from app.models.panic import PanicAlert

Base.metadata.create_all(bind=engine)


app = FastAPI(title='Easible API')

origins = [
    "http://localhost:58903",
    "http://127.0.0.1:58903",
    "http://10.0.2.2:8000",
    "*"  # for dev (optional but easiest)
]


app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=False,
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