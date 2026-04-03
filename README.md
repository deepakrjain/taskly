# Taskly - Smart Task Management Application

A modern, full-stack task management application built with Flutter (frontend) and FastAPI (backend). Taskly helps users organize, prioritize, and track their tasks with an intuitive interface and powerful features.

## 📋 Table of Contents

- [Features](#-features)
- [Project Structure](#-project-structure)
- [Technology Stack](#-technology-stack)
- [Installation](#-installation)
- [Quick Start](#-quick-start)
- [Usage](#-usage)
- [API Documentation](#-api-documentation)
- [Configuration](#-configuration)
- [Development](#-development)

---

## ✨ Features

### Core Features
- **Create, Read, Update, Delete (CRUD) Tasks** - Full task management capabilities
- **Task Priorities** - Organize tasks by High, Medium, and Low priority levels
- **Task Status Tracking** - Track tasks through To-Do, In Progress, and Done states
- **Due Date Management** - Set and manage task due dates with intelligent sorting
- **Task Search** - Search tasks by title and description
- **Drag-and-Drop Reordering** - Intuitive task reordering with smooth interactions
- **Local Persistence** - Auto-save task drafts locally with SharedPreferences

### Advanced Features
- **Dark Mode** - Complete Material Design 3 dark theme with persistent storage
- **Quick Filters** - Filter tasks by:
  - All tasks
  - My Day (tasks due today)
  - Upcoming (future tasks)
  - Overdue (past-due tasks)
  - Completed (finished tasks)
- **Intelligent Task Sorting** - Tasks sorted by:
  - Nearest due date first (for tasks with due dates)
  - Priority level (High > Medium > Low) for other tasks
- **Smooth Animations** - Beautiful page transitions with slide and fade effects
- **Responsive Design** - Optimized for different screen sizes and devices

### User Experience
- **Intuitive UI** - Gradient AppBar, themed cards, and visual feedback
- **Drag Handle with Visual Cues** - Grab cursor on hover for clear drag affordance
- **Theme Toggle** - Quick switch between light and dark modes from the AppBar
- **Real-time Feedback** - Success and error messages with SnackBars
- **Empty States** - Helpful messages when no tasks exist

---

## 📁 Project Structure

```
Taskly/
├── flutter/                          # Flutter frontend application
│   ├── lib/
│   │   ├── main.dart                # App entry point with theme management
│   │   ├── screens/                 # Application screens
│   │   │   ├── task_list_screen.dart
│   │   │   ├── task_edit_screen.dart
│   │   │   └── task_create_screen.dart
│   │   ├── models/                  # Data models
│   │   │   ├── task.dart
│   │   │   ├── task_status.dart
│   │   │   ├── task_priority.dart
│   │   │   ├── filter_type.dart
│   │   │   └── recurrence_type.dart
│   │   ├── providers/               # Riverpod state management
│   │   │   ├── task_provider.dart
│   │   │   ├── theme_provider.dart
│   │   │   └── draft_provider.dart
│   │   ├── services/                # API and services
│   │   │   └── api_service.dart
│   │   ├── theme/                   # Theme configuration
│   │   │   └── app_theme.dart
│   │   ├── widgets/                 # Reusable widgets
│   │   │   └── search_filter_bar.dart
│   │   ├── utils/                   # Utilities
│   │   │   ├── page_transitions.dart
│   │   │   └── task_sorting.dart
│   │   └── test/                    # Unit and widget tests
│   ├── pubspec.yaml                 # Flutter dependencies
│   └── analysis_options.yaml         # Lint configuration
│
├── backend/                          # FastAPI backend application
│   ├── main.py                      # FastAPI app entry point
│   ├── models/                      # SQLAlchemy models
│   │   ├── task.py
│   │   └── base.py
│   ├── schemas/                     # Pydantic schemas
│   │   └── task_schema.py
│   ├── routes/                      # API routes
│   │   └── task_routes.py
│   ├── database.py                  # Database configuration
│   ├── requirements.txt              # Python dependencies
│   └── tasks.db                      # SQLite database
│
├── README.md                         # This file
└── .gitignore                        # Git ignore rules
```

---

## 🛠 Technology Stack

### Frontend
- **Flutter 3.x** - Cross-platform UI framework
- **Riverpod 2.5.0** - State management with reactive programming
- **Dio 5.3.1** - HTTP client for API calls
- **SharedPreferences** - Local data persistence
- **Material Design 3** - Modern UI components and theming

### Backend
- **FastAPI** - Modern Python web framework
- **SQLAlchemy** - ORM for database operations
- **SQLite** - Lightweight relational database
- **Uvicorn** - ASGI server

---

## 📦 Installation

### Prerequisites
- Flutter SDK (3.0 or higher)
- Python 3.9 or higher
- Git

### Frontend Setup
```bash
cd flutter
flutter pub get
```

### Backend Setup
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

---

## 🚀 Quick Start

### Running the Backend
```bash
cd backend
source venv/bin/activate  # On Windows: venv\Scripts\activate
python main.py
```
The API will be available at `http://localhost:8000`

### Running the Frontend
```bash
cd flutter
flutter run -d chrome
```
For web, the app will open in your default browser at `http://localhost:55321`

### Development Mode
For faster development with hot reload:
```bash
cd flutter
flutter run -d chrome
# Press 'r' during execution to hot reload
# Press 'R' for full restart
```

---

## 📖 Usage

### Creating a Task
1. Tap the **+** floating action button
2. Enter task title and description
3. (Optional) Set due date and priority
4. Tap **Create Task**

### Editing a Task
1. Tap on any task card
2. Modify the details
3. Tap **Update Task**

### Deleting a Task
1. Tap on a task to open it
2. Tap the delete icon (🗑️)
3. Confirm the deletion

### Reordering Tasks
1. Hover over the drag handle (≡) on the left side of a task
2. Click and drag to reorder
3. Release to drop in new position

### Filtering and Searching
- Use the **status filter chips** (All, To-Do, In Progress, Done) to filter by status
- Use the **quick filter chips** (All, My Day, Upcoming, Overdue, Completed) for smart filtering
- Use the **search bar** to find tasks by title or description

### Toggling Theme
- Tap the **theme icon** (☀️/🌙) in the AppBar to switch between light and dark modes
- Your preference is automatically saved

---

## 🔌 API Documentation

### Base URL
```
http://localhost:8000/api
```

### Endpoints

#### Get All Tasks
```http
GET /tasks
```
Response: List of all tasks

#### Create Task
```http
POST /tasks
Content-Type: application/json

{
  "title": "Task Title",
  "description": "Task description",
  "priority": "HIGH",
  "due_date": "2024-12-31",
  "status": "TO_DO"
}
```

#### Get Task by ID
```http
GET /tasks/{task_id}
```

#### Update Task
```http
PUT /tasks/{task_id}
Content-Type: application/json

{
  "title": "Updated Title",
  "description": "Updated description",
  "priority": "MEDIUM",
  "due_date": "2024-12-31",
  "status": "IN_PROGRESS"
}
```

#### Delete Task
```http
DELETE /tasks/{task_id}
```

#### Search Tasks
```http
GET /tasks/search?q=search_term
```

#### Reorder Tasks
```http
POST /tasks/reorder
Content-Type: application/json

{
  "task_ids": ["id1", "id2", "id3"]
}
```

#### Filter by Status
```http
GET /tasks/filter?status=IN_PROGRESS
```

---

## ⚙️ Configuration

### Backend Configuration
Edit `backend/main.py` to configure:
- Database URL
- API host and port
- CORS settings

### Frontend Configuration
Update API endpoint in `flutter/lib/services/api_service.dart`:
```dart
static const String baseUrl = 'http://localhost:8000/api';
```

### Theme Customization
Edit `flutter/lib/theme/app_theme.dart` to customize:
- Color schemes
- Typography
- Component styles

---

## 🧪 Development

### Running Tests
```bash
cd flutter
flutter test
```

### Code Quality
```bash
cd flutter
flutter analyze
```

### Building for Release

**Web Build:**
```bash
cd flutter
flutter build web
```

**Android Build:**
```bash
cd flutter
flutter build apk
```

**iOS Build:**
```bash
cd flutter
flutter build ios
```

---

## 📝 Database Schema

### Tasks Table
| Column | Type | Description |
|--------|------|-------------|
| id | String (UUID) | Primary key |
| title | String | Task title |
| description | String | Task description |
| status | String | TO_DO, IN_PROGRESS, DONE |
| priority | String | LOW, MEDIUM, HIGH |
| due_date | DateTime | Optional due date |
| order_index | Integer | Task order for reordering |
| is_recurring | Boolean | Whether task recurs |
| recurrence_type | String | Daily, weekly, monthly (if recurring) |
| blocked_by | String | ID of blocking task (if any) |
| created_at | DateTime | Creation timestamp |
| updated_at | DateTime | Last update timestamp |

---

## 🐛 Troubleshooting

### "Connection refused" error
- Ensure backend is running: `python main.py`
- Check if API is accessible at `http://localhost:8000`

### Tasks not appearing
- Check network connectivity
- Verify backend API is responding
- Clear app cache: `flutter clean && flutter pub get`

### Theme not persisting
- Check SharedPreferences permissions
- Verify `shared_preferences` package is installed

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

---

## 📄 License

This project is provided as-is for educational and personal use.

---

## 👨‍💻 Author

Built with ❤️ for efficient task management.

---

## 🔮 Future Enhancements

- Recurring task automation
- Task categories/tags
- Task notifications and reminders
- Collaborative task sharing
- Analytics and insights
- Cloud synchronization
- Mobile app deployment

---

## 📞 Support

For issues or questions, refer to the project documentation or consult the inline code comments throughout the repository.

**Happy task managing! 🚀**
