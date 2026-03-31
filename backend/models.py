from sqlalchemy import Column, String, DateTime, Boolean, Integer, Enum, ForeignKey
from sqlalchemy.dialects.sqlite import UUID
from datetime import datetime
import uuid
import enum
from database import Base


class TaskStatus(str, enum.Enum):
    """Task status enumeration"""
    TODO = "To-Do"
    IN_PROGRESS = "In Progress"
    DONE = "Done"


class RecurrenceType(str, enum.Enum):
    """Recurrence type enumeration"""
    DAILY = "Daily"
    WEEKLY = "Weekly"


class Task(Base):
    """Task model for database"""
    __tablename__ = "tasks"

    id = Column(UUID(as_uuid=True), primary_key=True, default=uuid.uuid4)
    title = Column(String(255), nullable=False, index=True)
    description = Column(String(1000), nullable=False, default="")
    due_date = Column(DateTime, nullable=True)
    status = Column(Enum(TaskStatus), nullable=False, default=TaskStatus.TODO)
    blocked_by = Column(UUID(as_uuid=True), ForeignKey("tasks.id"), nullable=True)
    order_index = Column(Integer, nullable=False, default=0)
    is_recurring = Column(Boolean, nullable=False, default=False)
    recurrence_type = Column(Enum(RecurrenceType), nullable=True)
    created_at = Column(DateTime, nullable=False, default=datetime.utcnow)
    updated_at = Column(DateTime, nullable=False, default=datetime.utcnow, onupdate=datetime.utcnow)

    def __repr__(self):
        return f"<Task(id={self.id}, title={self.title}, status={self.status})>"
