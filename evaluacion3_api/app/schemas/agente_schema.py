from pydantic import BaseModel, EmailStr, Field, ConfigDict
from datetime import datetime
from typing import Optional

class AgenteBase(BaseModel):
    nombre: str = Field(..., min_length=2, max_length=100)
    email: EmailStr

class AgenteCreate(AgenteBase):
    password: str = Field(..., min_length=8, max_length=128)

class AgenteOut(BaseModel):
    model_config = ConfigDict(from_attributes=True)

    id: int
    nombre: str
    email: EmailStr
    is_active: bool
    created_at: datetime
    updated_at: datetime

class TokenOut(BaseModel):
    access_token: str
    token_type: str = "bearer"
