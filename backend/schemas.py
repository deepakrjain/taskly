from pydantic import BaseModel, Field
from typing import Optional
from datetime import datetime
from uuid import UUID


class TaskBase(BaseModel):
    """Base Task schema with common fields"""
    title: str = Field(..., min_length=1, max_length=255)
    description: str = Field("", max_length=1000)
    due_date: Optional[datetime] = None
    status: str = "To-Do"
    blocked_by: Optional[UUID] = None
    is_recurring: bool = False
    recurrence_type: Optional[str] = None


class TaskCreate(TaskBase):
    """Schema for creating a new task"""
    pass


class TaskUpdate(BaseModel):
    """Schema for updating an existing task"""
    title: Optional[str] = None
    description: Optional[str] = None
    due_date: Optional[datetime] = None
    status: Optional[str] = None
    blocked_by: Optional[UUID] = None
    is_recurring: Optional[bool] = None
    recurrence_type: Optional[str] = None


class TaskResponse(TaskBase):
    """Schema for task response"""
    id: UUID
    order_index: int
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class TaskReorderRequest(BaseModel):
    """Schema for reordering tasks"""
    task_ids: list[UUID]
