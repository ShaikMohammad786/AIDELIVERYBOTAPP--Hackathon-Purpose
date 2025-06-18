

from fastapi import FastAPI, HTTPException, status, Depends, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordBearer
from pydantic import BaseModel, EmailStr
from typing import Optional
from passlib.hash import bcrypt
from jose import JWTError, jwt
from pymongo import MongoClient
from bson.objectid import ObjectId
import datetime
import socket  # For TCP connection

# MongoDB setup
MONGO_URL = "mongodb://localhost:27017"
client = MongoClient(MONGO_URL)
db = client["hackvyuha"]
users_collection = db["users"]

# JWT config
SECRET_KEY = "supersecretkey"  # change in production!
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60 * 24  # 24 hours

# ----------- ACCESS CODE LOGIC -----------
ACTIVE_ACCESS_CODE = "445566"  # Set your robot's code here

# ----------- RASPBERRY PI TCP CONFIG -----------
PI_IP = "10.1.11.11"  # <--- Set your Raspberry Pi's LAN IP here
PI_PORT = 65432          # Port for TCP server on Pi

# Models
class RegisterModel(BaseModel):
    username: str
    email: EmailStr
    password: str

class LoginModel(BaseModel):
    email: EmailStr
    password: str

class UserModel(BaseModel):
    id: Optional[str]
    username: str
    email: EmailStr

class TokenData(BaseModel):
    username: str
    email: EmailStr

# FastAPI app
app = FastAPI()

# CORS for Flutter/dev
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Utility functions
def create_access_token(data: dict, expires_delta: Optional[datetime.timedelta] = None):
    to_encode = data.copy()
    expire = datetime.datetime.utcnow() + (expires_delta or datetime.timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES))
    to_encode.update({"exp": expire})
    return jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)

def get_user_by_email(email: str):
    return users_collection.find_one({"email": email})

def user_to_dict(user):
    return {
        "id": str(user["_id"]),
        "username": user["username"],
        "email": user["email"],
    }

# Routes
@app.post("/register")
def register(data: RegisterModel):
    if users_collection.find_one({"email": data.email}):
        raise HTTPException(status_code=400, detail="Email already registered")
    if users_collection.find_one({"username": data.username}):
        raise HTTPException(status_code=400, detail="Username already taken")
    hashed = bcrypt.hash(data.password)
    user = {
        "username": data.username,
        "email": data.email,
        "password_hash": hashed,
    }
    result = users_collection.insert_one(user)
    return {"message": "User registered successfully"}

@app.post("/login")
def login(data: LoginModel):
    user = users_collection.find_one({"email": data.email})
    if not user or not bcrypt.verify(data.password, user["password_hash"]):
        raise HTTPException(status_code=401, detail="Invalid credentials")
    token_data = {
        "username": user["username"],
        "email": user["email"],
    }
    token = create_access_token(token_data)
    return {
        "token": token,
        "user": user_to_dict(user)
    }

# Optional: get current user from token
oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login")

def get_current_user(token: str = Depends(oauth2_scheme)):
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return TokenData(username=payload.get("username"), email=payload.get("email"))
    except JWTError:
        raise HTTPException(status_code=401, detail="Invalid token")

@app.get("/profile")
def get_profile(current_user: TokenData = Depends(get_current_user)):
    return current_user

# ----------- ROBOT ACCESS CODE API -----------

@app.get("/get_code")
def get_code():
    """Returns the current robot access code."""
    return {"code": ACTIVE_ACCESS_CODE}


@app.post("/verify")
async def verify_code(request: Request):
    data = await request.json()
    code = data.get("code")
    print(f"FastAPI: /verify called with code: {code}")
    try:
        with socket.create_connection((PI_IP, PI_PORT), timeout=5) as s:
            s.sendall(code.encode())
            response = s.recv(1024).decode()
            print(f"Reply from Pi: {repr(response)}")
            if response.strip().upper() == "SUCCESS":
                return {"status": "ok"}
            else:
                return {"status": "fail"}
    except Exception as e:
        print(f"FastAPI: Exception connecting to Pi: {e}")
        return {"status": "fail"}