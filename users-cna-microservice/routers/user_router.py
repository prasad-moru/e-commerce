from typing import List, Optional

from fastapi import APIRouter, Depends
from db.dals.user_dal import UserDAL
from db.models.user import UserResponse  # Import the Pydantic model
from dependencies import get_user_dal

router = APIRouter()

# Create a new user
@router.post("/users", response_model=UserResponse)
async def create_user(name: str, email: str, mobile: str, user_dal: UserDAL = Depends(get_user_dal)):
    return await user_dal.create_user(name, email, mobile)


# Update an existing user
@router.put("/users/{user_id}", response_model=UserResponse)
async def update_user(user_id: int, name: Optional[str] = None, email: Optional[str] = None, mobile: Optional[str] = None,
                      user_dal: UserDAL = Depends(get_user_dal)):
    return await user_dal.update_user(user_id, name, email, mobile)


# Get a specific user by user ID
@router.get("/users/{user_id}", response_model=UserResponse)
async def get_user(user_id: int, user_dal: UserDAL = Depends(get_user_dal)):
    return await user_dal.get_user(user_id)


# Get all users
@router.get("/users", response_model=List[UserResponse])  # Use the Pydantic List[UserResponse] model
async def get_all_users(user_dal: UserDAL = Depends(get_user_dal)) -> List[UserResponse]:
    users = await user_dal.get_all_users()
    return users  # Return the Pydantic models, not SQLAlchemy models

