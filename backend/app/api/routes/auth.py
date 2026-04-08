from fastapi import APIRouter,Depends, HTTPException
from sqlalchemy.orm import Session
from app.api.deps import get_db
from app.models.user import User
from app.schemas.auth import SignupRequest,LoginRequest,TokenResponse
from app.core.security import hash_password,verify_password,create_access_token

router =  APIRouter(prefix='/auth', tags=['Auth'])

@router.post('/signup',response_model= TokenResponse)
def signup(request: SignupRequest, db: Session = Depends(get_db)):
  existing_user = db.query(User).filter(User.email == request.email).first()
  if existing_user:
    raise HTTPException(status_code = 400 , detail= 'Email already registered')
  
  new_user = User(
    name = request.name,
    email = request.email,
    password =  hash_password(request.password) 
  )

  db.add(new_user)
  db.commit()
  db.refresh(new_user)

  token = create_access_token({'user_id':new_user.id, 'role': new_user.role})

  return {'access_token':token}

@router.post('/login', response_model = TokenResponse)
def login(request: LoginRequest,db:Session = Depends(get_db)):
  user = db.query(User).filter(User.email == request.email).first()

  if not user or not verify_password(request.password,user.password):
    raise HTTPException(status_code = 401, detail = "Invalid Credentials")
    
  token = create_access_token({'user_id': user.id, 'role':user.role})

  return {'access_token':token}  