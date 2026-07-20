from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_current_admin, get_db
from app.models.booking import Booking
from app.models.complaint import Complaint
from app.models.panic import PanicAlert
from app.models.booking_requests import BookingRequest

router = APIRouter(prefix='/admin', tags=['Admin'])


@router.get('/dashboard')
def admin_dashboard(current_admin=Depends(get_current_admin)):
    return {
        'message': 'Welcome aboard Admin',
        'admin_data': current_admin
    }


@router.get('/stats')
def admin_stats(
    db: Session = Depends(get_db),
    admin=Depends(get_current_admin)
):
    confirmed_bookings = db.query(Booking).filter(
        Booking.status.in_(['confirmed', 'accepted'])
    ).count()

    open_complaints = db.query(Complaint).filter(
        Complaint.status == 'open'
    ).count()

    panic_alerts = db.query(PanicAlert).count()

    pending_requests = db.query(BookingRequest).filter(
        BookingRequest.status == 'pending'
    ).count()

    return {
        'confirmed_bookings': confirmed_bookings,
        'open_complaints': open_complaints,
        'panic_alerts': panic_alerts,
        'pending_requests': pending_requests,
    }