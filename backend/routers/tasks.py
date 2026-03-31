from fastapi import APIRouter, Depends, HTTPException, Query
from sqlalchemy.orm import Session
from sqlalchemy import desc, or_
from typing import List
from database import get_db
from models import Task, TaskStatus, RecurrenceType
from schemas import TaskCreate, TaskUpdate, TaskResponse, TaskReorderRequest
from uuid import UUID
import asyncio

router = APIRouter(prefix="/tasks", tags=["tasks"])


@router.get("", response_model=List[TaskResponse])
async def list_tasks(
    search: str = Query("", description="Search tasks by title"),
    status: str = Query("", description="Filter by status"),
    db: Session = Depends(get_db)
):
    """
    List all tasks with optional search and status filter.
    """
    query = db.query(Task)

    # Apply search filter
    if search:
        query = query.filter(Task.title.ilike(f"%{search}%"))

    # Apply status filter
    if status and status != "All":
        query = query.filter(Task.status == status)

    # Order by order_index then created_at
    query = query.order_by(Task.order_index, Task.created_at)

    tasks = query.all()
    return tasks


@router.get("/{task_id}", response_model=TaskResponse)
async def get_task(task_id: UUID, db: Session = Depends(get_db)):
    """
    Get a single task by ID.
    """
    task = db.query(Task).filter(Task.id == task_id).first()
    if not task:
        raise HTTPException(status_code=404, detail="Task not found")
    return task


@router.post("", response_model=TaskResponse, status_code=201)
async def create_task(task_data: TaskCreate, db: Session = Depends(get_db)):
    """
    Create a new task.
    Includes a 2-second simulated delay.
    """
    # Simulate 2-second delay
    await asyncio.sleep(2)

    # Get the next order_index
    last_task = db.query(Task).order_by(desc(Task.order_index)).first()
    next_order = (last_task.order_index + 1) if last_task else 0

    # Create new task
    db_task = Task(
        title=task_data.title,
        description=task_data.description,
        due_date=task_data.due_date,
        status=task_data.status,
        blocked_by=task_data.blocked_by,
        order_index=next_order,
        is_recurring=task_data.is_recurring,
        recurrence_type=task_data.recurrence_type,
    )

    db.add(db_task)
    db.commit()
    db.refresh(db_task)
    return db_task


@router.put("/{task_id}", response_model=TaskResponse)
async def update_task(
    task_id: UUID,
    task_data: TaskUpdate,
    db: Session = Depends(get_db)
):
    """
    Update an existing task by ID.
    Includes a 2-second simulated delay.
    """
    # Simulate 2-second delay
    await asyncio.sleep(2)

    # Fetch the task
    db_task = db.query(Task).filter(Task.id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail="Task not found")

    # Update fields if provided
    if task_data.title is not None:
        db_task.title = task_data.title
    if task_data.description is not None:
        db_task.description = task_data.description
    if task_data.due_date is not None:
        db_task.due_date = task_data.due_date
    if task_data.status is not None:
        db_task.status = task_data.status
    if task_data.blocked_by is not None:
        db_task.blocked_by = task_data.blocked_by
    if task_data.is_recurring is not None:
        db_task.is_recurring = task_data.is_recurring
    if task_data.recurrence_type is not None:
        db_task.recurrence_type = task_data.recurrence_type

    db.commit()
    db.refresh(db_task)
    return db_task


@router.delete("/{task_id}", status_code=204)
async def delete_task(task_id: UUID, db: Session = Depends(get_db)):
    """
    Delete a task by ID.
    """
    db_task = db.query(Task).filter(Task.id == task_id).first()
    if not db_task:
        raise HTTPException(status_code=404, detail="Task not found")

    db.delete(db_task)
    db.commit()
    return None


@router.patch("/reorder")
async def reorder_tasks(
    request: TaskReorderRequest,
    db: Session = Depends(get_db)
):
    """
    Reorder tasks by updating their order_index field.
    """
    for index, task_id in enumerate(request.task_ids):
        task = db.query(Task).filter(Task.id == task_id).first()
        if task:
            task.order_index = index
            db.add(task)

    db.commit()
    return {"status": "ok", "message": "Tasks reordered successfully"}
