from fastapi import APIRouter, Query, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.models.facility import Facility
from math import radians, cos, sin, asin, sqrt

router = APIRouter(prefix='/panic', tags=['Panic'])


def haversine(lat1, lon1, lat2, lon2):
    # convert to radians
    lat1, lon1, lat2, lon2 = map(radians, [lat1, lon1, lat2, lon2])

    # differences
    dlat = lat2 - lat1
    dlon = lon2 - lon1

    # formula
    a = sin(dlat / 2) ** 2 + cos(lat1) * cos(lat2) * sin(dlon / 2) ** 2
    c = 2 * asin(sqrt(a))

    return 6371 * c  # km


@router.get('/nearby')
def get_nearby(
    lat: float = Query(...),
    lon: float = Query(...),
    db: Session = Depends(get_db)
):
    facilities = db.query(Facility).all()

    results = []

    for f in facilities:
        distance = haversine(lat, lon, f.latitude, f.longitude)

        results.append({
            'id': f.id,
            'name': f.name,
            'type': f.type,
            'distance': round(distance, 2)
        })

    # ✅ sort AFTER loop
    results.sort(key=lambda x: x['distance'])

    # ✅ return AFTER loop
    return results[:5]