from fastapi import APIRouter, Depends
from app.api.deps import get_current_admin

router = APIRouter(prefix='/admin', tags=['Admin'])

@router.get('/dashboard')
def admin_dashboard(current_admin = Depends(get_current_admin)):
  return{
    'message':'Welcome aboard Admin',
    'admin_data' : current_admin
  }