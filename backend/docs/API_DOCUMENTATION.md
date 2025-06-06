# Task Hub API Documentation

This document provides a comprehensive overview of all API endpoints for the Task Hub microservices.

---
# Auth Service API Documentation

This document provides details about the API endpoints for the Auth Service.

## POST /auth/register

**Description:** Register a new user.

**Required Headers:**
- `Content-Type`: application/json

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
```json
{
  "email": "<EmailStr: User's email address>",
  "password": "<str: User's password (min 8 characters)>",
  "full_name": "<str: User's full name>",
  "company_name": "<Optional[str]: User's company name>"
}
```

**Response Body:** (`200 OK`)
```json
{
  "access_token": "<str: The JWT access token>",
  "refresh_token": "<str: The JWT refresh token>",
  "token_type": "<str: Type of token (bearer)>",
  "expires_at": "<datetime: Expiry timestamp of the access token>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "user@example.com",
    "password": "securepassword123",
    "full_name": "Test User",
    "company_name": "Test Inc."
  }'
```

**Example Response (JSON):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_at": "2023-10-27T10:00:00Z"
}
```

---

## POST /auth/login

**Description:** Login a user.

**Required Headers:**
- `Content-Type`: application/x-www-form-urlencoded

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body (Form Data):**
- `username`: <str: User's email address>
- `password`: <str: User's password>

**Response Body:** (`200 OK`)
```json
{
  "access_token": "<str: The JWT access token>",
  "refresh_token": "<str: The JWT refresh token>",
  "token_type": "<str: Type of token (bearer)>",
  "expires_at": "<datetime: Expiry timestamp of the access token>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/auth/login" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "username=user@example.com&password=securepassword123"
```

**Example Response (JSON):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_at": "2023-10-27T10:00:00Z"
}
```

---

## GET /auth/validate

**Description:** Validate a token. Also returns user_id along with new tokens. (Note: The service might issue new tokens upon validation, or re-validate existing ones. The DTO suggests new tokens are returned).

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "access_token": "<str: The JWT access token>",
  "refresh_token": "<str: The JWT refresh token>",
  "token_type": "<str: Type of token (bearer)>",
  "expires_at": "<datetime: Expiry timestamp of the access token>",
  "user_id": "<str: The ID of the validated user>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/auth/validate" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
```

**Example Response (JSON):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "token_type": "bearer",
  "expires_at": "2023-10-27T11:00:00Z",
  "user_id": "some-user-id-123"
}
```

---

## POST /auth/refresh

**Description:** Refresh a token.

**Required Headers:**
- `Content-Type`: application/json

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
```json
{
  "refresh_token": "<str: The refresh token>"
}
```
*(Note: The endpoint expects a JSON body with a `refresh_token` field, based on the `refresh_token: str` type hint in `main.py` and common FastAPI practices for such inputs when `Content-Type` is `application/json`.)*

**Response Body:** (`200 OK`)
```json
{
  "access_token": "<str: The new JWT access token>",
  "refresh_token": "<str: The new JWT refresh token (could be the same or a new one)>",
  "token_type": "<str: Type of token (bearer)>",
  "expires_at": "<datetime: Expiry timestamp of the new access token>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/auth/refresh" \
  -H "Content-Type: application/json" \
  -d '{
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.oldrefreshtoken..."
  }'
```

**Example Response (JSON):**
```json
{
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.newaccesstoken...",
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.newrefreshtoken...",
  "token_type": "bearer",
  "expires_at": "2023-10-27T12:00:00Z"
}
```

---

## POST /auth/logout

**Description:** Logout a user. (Invalidates the token on the server-side, if applicable, or performs cleanup.)

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Logout status message>"
}
```
*(Note: The actual response from `auth_service.logout(token)` is `Dict[str, Any]`. A common response is `{"message": "Successfully logged out"}` or similar. This is an assumption.)*

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/auth/logout" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.sometoken..."
```

**Example Response (JSON):**
```json
{
  "message": "Successfully logged out"
}
```

---

## GET /auth/profile

**Description:** Get user profile.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "id": "<str: User's unique identifier>",
  "email": "<EmailStr: User's email address>",
  "full_name": "<str: User's full name>",
  "company_name": "<Optional[str]: User's company name>",
  "role": "<str: User's role>",
  "created_at": "<datetime: Timestamp of user creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last profile update>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/auth/profile" \
  -H "Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.sometoken..."
```

**Example Response (JSON):**
```json
{
  "id": "some-user-id-123",
  "email": "user@example.com",
  "full_name": "Test User",
  "company_name": "Test Inc.",
  "role": "user",
  "created_at": "2023-10-26T10:00:00Z",
  "updated_at": "2023-10-26T12:00:00Z"
}
```

---

## GET /health

**Description:** Health check endpoint. Standard health check to verify service availability.

**Required Headers:**
- None

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "status": "<str: Health status of the service>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/health"
```

**Example Response (JSON):**
```json
{
  "status": "healthy"
}
```

---
# Project Service API Documentation

This document provides details about the API endpoints for the Project Service. All routes require `Authorization: Bearer <token>` header for authentication and expect `Content-Type: application/json` for request bodies.

## Projects Endpoints

### POST /projects

**Description:** Create a new project.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`ProjectCreateDTO`)
```json
{
  "name": "<str: Project name (3-100 chars)>",
  "description": "<Optional[str]: Project description>",
  "start_date": "<Optional[datetime]: Project start date, e.g., 2023-10-01T00:00:00Z>",
  "end_date": "<Optional[datetime]: Project end date, e.g., 2023-12-31T00:00:00Z>",
  "status": "<ProjectStatus: planning | in_progress | on_hold | completed | cancelled (default: planning)>",
  "tags": "<Optional[List[str]]: List of tags, e.g., [\"web\", \"mobile\"]>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>"
}
```

**Response Body:** (`200 OK` - `ProjectResponseDTO`)
```json
{
  "id": "<str: Project ID>",
  "name": "<str: Project name>",
  "description": "<Optional[str]: Project description>",
  "start_date": "<Optional[datetime]: Project start date>",
  "end_date": "<Optional[datetime]: Project end date>",
  "status": "<ProjectStatus: Project status>",
  "owner_id": "<str: User ID of the project owner>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
  "created_at": "<datetime: Timestamp of project creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last project update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "name": "New Mobile App",
    "description": "Development of a new cross-platform mobile application.",
    "status": "planning",
    "tags": ["mobile", "flutter"]
  }'
```

**Example Response (JSON):**
```json
{
  "id": "proj_123abc",
  "name": "New Mobile App",
  "description": "Development of a new cross-platform mobile application.",
  "start_date": null,
  "end_date": null,
  "status": "planning",
  "owner_id": "user_xyz789",
  "tags": ["mobile", "flutter"],
  "meta_data": null,
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": null
}
```

---

### GET /projects

**Description:** Get projects for current user.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[ProjectResponseDTO]`)
```json
[
  {
    "id": "<str: Project ID>",
    "name": "<str: Project name>",
    "description": "<Optional[str]: Project description>",
    "start_date": "<Optional[datetime]: Project start date>",
    "end_date": "<Optional[datetime]: Project end date>",
    "status": "<ProjectStatus: Project status>",
    "owner_id": "<str: User ID of the project owner>",
    "tags": "<Optional[List[str]]: List of tags>",
    "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
    "created_at": "<datetime: Timestamp of project creation>",
    "updated_at": "<Optional[datetime]: Timestamp of last project update>"
  }
  // ... more projects
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/projects" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "proj_123abc",
    "name": "New Mobile App",
    "description": "Development of a new cross-platform mobile application.",
    "start_date": null,
    "end_date": null,
    "status": "planning",
    "owner_id": "user_xyz789",
    "tags": ["mobile", "flutter"],
    "meta_data": null,
    "created_at": "2023-10-27T10:00:00Z",
    "updated_at": null
  },
  {
    "id": "proj_456def",
    "name": "Website Redesign",
    "description": "Complete overhaul of the company website.",
    "start_date": "2023-11-01T00:00:00Z",
    "end_date": "2024-03-01T00:00:00Z",
    "status": "in_progress",
    "owner_id": "user_xyz789",
    "tags": ["web", "react"],
    "meta_data": {"client": "Internal"},
    "created_at": "2023-10-15T09:00:00Z",
    "updated_at": "2023-10-20T14:30:00Z"
  }
]
```

---

### GET /projects/{project_id}

**Description:** Get a project.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project to retrieve>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `ProjectResponseDTO`)
```json
{
  "id": "<str: Project ID>",
  "name": "<str: Project name>",
  "description": "<Optional[str]: Project description>",
  "start_date": "<Optional[datetime]: Project start date>",
  "end_date": "<Optional[datetime]: Project end date>",
  "status": "<ProjectStatus: Project status>",
  "owner_id": "<str: User ID of the project owner>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
  "created_at": "<datetime: Timestamp of project creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last project update>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "id": "proj_123abc",
  "name": "New Mobile App",
  "description": "Development of a new cross-platform mobile application.",
  "start_date": null,
  "end_date": null,
  "status": "planning",
  "owner_id": "user_xyz789",
  "tags": ["mobile", "flutter"],
  "meta_data": null,
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": null
}
```

---

### PUT /projects/{project_id}

**Description:** Update a project.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project to update>

**Query Parameters:**
- None

**Request Body:** (`ProjectUpdateDTO`)
```json
{
  "name": "<Optional[str]: Project name (3-100 chars)>",
  "description": "<Optional[str]: Project description>",
  "start_date": "<Optional[datetime]: Project start date>",
  "end_date": "<Optional[datetime]: Project end date>",
  "status": "<Optional[ProjectStatus]: planning | in_progress | on_hold | completed | cancelled>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>"
}
```

**Response Body:** (`200 OK` - `ProjectResponseDTO`)
```json
{
  "id": "<str: Project ID>",
  "name": "<str: Updated project name>",
  "description": "<Optional[str]: Updated project description>",
  // ... other fields from ProjectResponseDTO
  "updated_at": "<datetime: Timestamp of last project update>"
}
```

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/projects/proj_123abc" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "description": "Updated description for the mobile app.",
    "status": "in_progress"
  }'
```

**Example Response (JSON):**
```json
{
  "id": "proj_123abc",
  "name": "New Mobile App",
  "description": "Updated description for the mobile app.",
  "start_date": null,
  "end_date": null,
  "status": "in_progress",
  "owner_id": "user_xyz789",
  "tags": ["mobile", "flutter"],
  "meta_data": null,
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": "2023-10-27T11:00:00Z"
}
```

---

### DELETE /projects/{project_id}

**Description:** Delete a project.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project to delete>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Project deleted successfully>"
}
```
*(Note: The service returns a `Dict[str, Any]`. This is an example structure.)*

**Example Request (curl):**
```bash
curl -X DELETE "http://localhost:8000/projects/proj_123abc" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "message": "Project proj_123abc deleted successfully"
}
```

## Project Members Endpoints

### POST /projects/{project_id}/members

**Description:** Add a member to a project.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>

**Query Parameters:**
- None

**Request Body:** (`ProjectMemberCreateDTO`)
```json
{
  "user_id": "<str: The ID of the user to add>",
  "role": "<str: Role of the member (default: member), e.g., admin, editor, viewer>"
}
```

**Response Body:** (`200 OK` - `ProjectMemberResponseDTO`)
```json
{
  "id": "<str: Project member record ID>",
  "project_id": "<str: Project ID>",
  "user_id": "<str: User ID of the member>",
  "role": "<str: Role of the member>",
  "joined_at": "<datetime: Timestamp when member joined>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/members" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "user_id": "user_def456",
    "role": "editor"
  }'
```

**Example Response (JSON):**
```json
{
  "id": "member_ghi789",
  "project_id": "proj_123abc",
  "user_id": "user_def456",
  "role": "editor",
  "joined_at": "2023-10-27T12:00:00Z"
}
```

---

### GET /projects/{project_id}/members

**Description:** Get project members.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[ProjectMemberResponseDTO]`)
```json
[
  {
    "id": "<str: Project member record ID>",
    "project_id": "<str: Project ID>",
    "user_id": "<str: User ID of the member>",
    "role": "<str: Role of the member>",
    "joined_at": "<datetime: Timestamp when member joined>"
  }
  // ... more members
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc/members" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "member_owner_xyz",
    "project_id": "proj_123abc",
    "user_id": "user_xyz789",
    "role": "owner",
    "joined_at": "2023-10-27T10:00:00Z"
  },
  {
    "id": "member_ghi789",
    "project_id": "proj_123abc",
    "user_id": "user_def456",
    "role": "editor",
    "joined_at": "2023-10-27T12:00:00Z"
  }
]
```

---

### PUT /projects/{project_id}/members/{member_id}

**Description:** Update a project member. (Here, `member_id` is the `user_id` of the member in the context of this project, not the `id` of the `ProjectMember` record itself. The service implementation uses `member_id` to find the `ProjectMember` record associated with this `user_id` and `project_id`.)

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `member_id`: <str: The User ID of the member to update>

**Query Parameters:**
- None

**Request Body:** (`ProjectMemberUpdateDTO`)
```json
{
  "role": "<str: New role for the member, e.g., admin, editor, viewer>"
}
```

**Response Body:** (`200 OK` - `ProjectMemberResponseDTO`)
```json
{
  "id": "<str: Project member record ID>",
  "project_id": "<str: Project ID>",
  "user_id": "<str: User ID of the member>",
  "role": "<str: Updated role of the member>",
  "joined_at": "<datetime: Timestamp when member joined>"
}
```

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/projects/proj_123abc/members/user_def456" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "role": "viewer"
  }'
```

**Example Response (JSON):**
```json
{
  "id": "member_ghi789",
  "project_id": "proj_123abc",
  "user_id": "user_def456",
  "role": "viewer",
  "joined_at": "2023-10-27T12:00:00Z"
}
```
*(Note: `joined_at` likely remains unchanged on role update)*

---

### DELETE /projects/{project_id}/members/{member_id}

**Description:** Remove a project member. (Here, `member_id` refers to the `user_id` of the member to be removed from the project.)

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `member_id`: <str: The User ID of the member to remove>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Member removed successfully>"
}
```
*(Note: The service returns a `Dict[str, Any]`. This is an example structure.)*

**Example Request (curl):**
```bash
curl -X DELETE "http://localhost:8000/projects/proj_123abc/members/user_def456" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "message": "Member user_def456 removed from project proj_123abc successfully"
}
```

## Task Endpoints

### POST /projects/{project_id}/tasks

**Description:** Create a new task.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project to which this task belongs>

**Query Parameters:**
- None

**Request Body:** (`TaskCreateDTO`)
```json
{
  "title": "<str: Task title (3-100 chars)>",
  "description": "<Optional[str]: Task description>",
  "assignee_id": "<Optional[str]: User ID of the assignee>",
  "due_date": "<Optional[datetime]: Task due date, e.g., 2023-11-15T00:00:00Z>",
  "priority": "<TaskPriority: low | medium | high | urgent (default: medium)>",
  "status": "<TaskStatus: todo | in_progress | review | done (default: todo)>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>"
}
```

**Response Body:** (`200 OK` - `TaskResponseDTO`)
```json
{
  "id": "<str: Task ID>",
  "title": "<str: Task title>",
  "description": "<Optional[str]: Task description>",
  "project_id": "<str: Project ID>",
  "creator_id": "<str: User ID of the task creator>",
  "assignee_id": "<Optional[str]: User ID of the assignee>",
  "due_date": "<Optional[datetime]: Task due date>",
  "priority": "<TaskPriority: Task priority>",
  "status": "<TaskStatus: Task status>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
  "created_at": "<datetime: Timestamp of task creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last task update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/tasks" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "title": "Implement login feature",
    "description": "Users should be able to log in using email and password.",
    "assignee_id": "user_def456",
    "priority": "high",
    "tags": ["auth", "frontend"]
  }'
```

**Example Response (JSON):**
```json
{
  "id": "task_jkl012",
  "title": "Implement login feature",
  "description": "Users should be able to log in using email and password.",
  "project_id": "proj_123abc",
  "creator_id": "user_xyz789",
  "assignee_id": "user_def456",
  "due_date": null,
  "priority": "high",
  "status": "todo",
  "tags": ["auth", "frontend"],
  "meta_data": null,
  "created_at": "2023-10-27T13:00:00Z",
  "updated_at": null
}
```

---

### GET /projects/{project_id}/tasks

**Description:** Get tasks for a project.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[TaskResponseDTO]`)
```json
[
  {
    "id": "<str: Task ID>",
    "title": "<str: Task title>",
    // ... other fields from TaskResponseDTO
  }
  // ... more tasks
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc/tasks" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "task_jkl012",
    "title": "Implement login feature",
    "description": "Users should be able to log in using email and password.",
    "project_id": "proj_123abc",
    "creator_id": "user_xyz789",
    "assignee_id": "user_def456",
    "due_date": null,
    "priority": "high",
    "status": "todo",
    "tags": ["auth", "frontend"],
    "meta_data": null,
    "created_at": "2023-10-27T13:00:00Z",
    "updated_at": null
  }
]
```

---

### GET /projects/{project_id}/tasks/{task_id}

**Description:** Get a task.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task to retrieve>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `TaskResponseDTO`)
```json
{
  "id": "<str: Task ID>",
  "title": "<str: Task title>",
  // ... other fields from TaskResponseDTO
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "id": "task_jkl012",
  "title": "Implement login feature",
  "description": "Users should be able to log in using email and password.",
  "project_id": "proj_123abc",
  "creator_id": "user_xyz789",
  "assignee_id": "user_def456",
  "due_date": null,
  "priority": "high",
  "status": "todo",
  "tags": ["auth", "frontend"],
  "meta_data": null,
  "created_at": "2023-10-27T13:00:00Z",
  "updated_at": null
}
```

---

### PUT /projects/{project_id}/tasks/{task_id}

**Description:** Update a task.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task to update>

**Query Parameters:**
- None

**Request Body:** (`TaskUpdateDTO`)
```json
{
  "title": "<Optional[str]: Task title (3-100 chars)>",
  "description": "<Optional[str]: Task description>",
  "assignee_id": "<Optional[str]: User ID of the assignee>",
  "due_date": "<Optional[datetime]: Task due date>",
  "priority": "<Optional[TaskPriority]: low | medium | high | urgent>",
  "status": "<Optional[TaskStatus]: todo | in_progress | review | done>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>"
}
```

**Response Body:** (`200 OK` - `TaskResponseDTO`)
```json
{
  "id": "<str: Task ID>",
  "title": "<str: Updated task title>",
  // ... other fields from TaskResponseDTO
  "updated_at": "<datetime: Timestamp of last task update>"
}
```

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "status": "in_progress",
    "description": "Implementation in progress for login feature."
  }'
```

**Example Response (JSON):**
```json
{
  "id": "task_jkl012",
  "title": "Implement login feature",
  "description": "Implementation in progress for login feature.",
  "project_id": "proj_123abc",
  "creator_id": "user_xyz789",
  "assignee_id": "user_def456",
  "due_date": null,
  "priority": "high",
  "status": "in_progress",
  "tags": ["auth", "frontend"],
  "meta_data": null,
  "created_at": "2023-10-27T13:00:00Z",
  "updated_at": "2023-10-27T14:00:00Z"
}
```

---

### DELETE /projects/{project_id}/tasks/{task_id}

**Description:** Delete a task.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task to delete>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Task deleted successfully>"
}
```
*(Note: The service returns a `Dict[str, Any]`. This is an example structure.)*

**Example Request (curl):**
```bash
curl -X DELETE "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "message": "Task task_jkl012 deleted successfully"
}
```

## Task Comments Endpoints

### POST /projects/{project_id}/tasks/{task_id}/comments

**Description:** Add a comment to a task.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task>

**Query Parameters:**
- None

**Request Body:** (`TaskCommentCreateDTO`)
```json
{
  "content": "<str: Comment content (min 1 char)>",
  "parent_id": "<Optional[str]: ID of the parent comment if this is a reply>"
}
```

**Response Body:** (`200 OK` - `TaskCommentResponseDTO`)
```json
{
  "id": "<str: Comment ID>",
  "task_id": "<str: Task ID>",
  "user_id": "<str: User ID of the commenter>",
  "content": "<str: Comment content>",
  "parent_id": "<Optional[str]: Parent comment ID>",
  "created_at": "<datetime: Timestamp of comment creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last comment update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012/comments" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "content": "This is a comment regarding the login feature."
  }'
```

**Example Response (JSON):**
```json
{
  "id": "comment_mno345",
  "task_id": "task_jkl012",
  "user_id": "user_xyz789",
  "content": "This is a comment regarding the login feature.",
  "parent_id": null,
  "created_at": "2023-10-27T15:00:00Z",
  "updated_at": null
}
```

---

### GET /projects/{project_id}/tasks/{task_id}/comments

**Description:** Get comments for a task.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[TaskCommentResponseDTO]`)
```json
[
  {
    "id": "<str: Comment ID>",
    "task_id": "<str: Task ID>",
    "user_id": "<str: User ID of the commenter>",
    "content": "<str: Comment content>",
    "parent_id": "<Optional[str]: Parent comment ID>",
    "created_at": "<datetime: Timestamp of comment creation>",
    "updated_at": "<Optional[datetime]: Timestamp of last comment update>"
  }
  // ... more comments
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012/comments" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "comment_mno345",
    "task_id": "task_jkl012",
    "user_id": "user_xyz789",
    "content": "This is a comment regarding the login feature.",
    "parent_id": null,
    "created_at": "2023-10-27T15:00:00Z",
    "updated_at": null
  }
]
```

## Activity Endpoints

### GET /projects/{project_id}/activities

**Description:** Get activities for a project.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>

**Query Parameters:**
- `limit`: <int: Number of activities to return (default: 100)>
- `offset`: <int: Number of activities to skip (default: 0)>

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[ActivityLogResponseDTO]`)
```json
[
  {
    "id": "<str: Activity log ID>",
    "project_id": "<str: Project ID>",
    "user_id": "<str: User ID who performed the action>",
    "action": "<str: Action performed, e.g., create_task, update_project>",
    "entity_type": "<str: Type of entity, e.g., task, project>",
    "entity_id": "<str: ID of the entity>",
    "details": "<Optional[Dict[str, Any]]: Additional details about the activity>",
    "created_at": "<datetime: Timestamp of activity logging>"
  }
  // ... more activities
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc/activities?limit=50&offset=0" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "activity_pqr678",
    "project_id": "proj_123abc",
    "user_id": "user_xyz789",
    "action": "create_task",
    "entity_type": "task",
    "entity_id": "task_jkl012",
    "details": {"title": "Implement login feature"},
    "created_at": "2023-10-27T13:00:00Z"
  },
  {
    "id": "activity_stu901",
    "project_id": "proj_123abc",
    "user_id": "user_xyz789",
    "action": "update_project",
    "entity_type": "project",
    "entity_id": "proj_123abc",
    "details": {"status": "in_progress"},
    "created_at": "2023-10-27T11:00:00Z"
  }
]
```

## Task Command Endpoints

### POST /projects/{project_id}/tasks/{task_id}/assign

**Description:** Assign a task to a user.

**Required Headers:**
- `Authorization`: Bearer <token>
  *(Content-Type not strictly needed as data is via query param, but client might send application/json for empty body)*

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task>

**Query Parameters:**
- `assignee_id`: <Optional[str]: The User ID of the assignee. If null/empty, task is unassigned.>

**Request Body:**
- None (or empty JSON object `{}`)

**Response Body:** (`200 OK` - `TaskResponseDTO`)
```json
{
  "id": "<str: Task ID>",
  "assignee_id": "<Optional[str]: Updated User ID of the assignee>",
  // ... other fields from TaskResponseDTO
  "updated_at": "<datetime: Timestamp of last task update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012/assign?assignee_id=user_def456" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{}'
```
*(To unassign, omit `assignee_id` or send `assignee_id=`)*
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012/assign" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Example Response (JSON for assigning):**
```json
{
  "id": "task_jkl012",
  "title": "Implement login feature",
  "description": "Implementation in progress for login feature.",
  "project_id": "proj_123abc",
  "creator_id": "user_xyz789",
  "assignee_id": "user_def456",
  "due_date": null,
  "priority": "high",
  "status": "in_progress",
  "tags": ["auth", "frontend"],
  "meta_data": null,
  "created_at": "2023-10-27T13:00:00Z",
  "updated_at": "2023-10-27T16:00:00Z"
}
```

---

### POST /projects/{project_id}/tasks/{task_id}/status

**Description:** Change task status.

**Required Headers:**
- `Authorization`: Bearer <token>
  *(Content-Type not strictly needed as data is via query param, but client might send application/json for empty body)*

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task>

**Query Parameters:**
- `status`: <str: The new status for the task (e.g., todo, in_progress, review, done)>

**Request Body:**
- None (or empty JSON object `{}`)

**Response Body:** (`200 OK` - `TaskResponseDTO`)
```json
{
  "id": "<str: Task ID>",
  "status": "<TaskStatus: Updated task status>",
  // ... other fields from TaskResponseDTO
  "updated_at": "<datetime: Timestamp of last task update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012/status?status=review" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -H "Content-Type: application/json" \
  -d '{}'
```

**Example Response (JSON):**
```json
{
  "id": "task_jkl012",
  "title": "Implement login feature",
  "description": "Implementation in progress for login feature.",
  "project_id": "proj_123abc",
  "creator_id": "user_xyz789",
  "assignee_id": "user_def456",
  "due_date": null,
  "priority": "high",
  "status": "review",
  "tags": ["auth", "frontend"],
  "meta_data": null,
  "created_at": "2023-10-27T13:00:00Z",
  "updated_at": "2023-10-27T17:00:00Z"
}
```

---

### POST /projects/{project_id}/tasks/{task_id}/undo

**Description:** Undo the last task command (assign or status change) for this specific task.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task for which to undo the last command>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `TaskResponseDTO`)
```json
{
  "id": "<str: Task ID>",
  // ... other fields from TaskResponseDTO reflecting the state before the undone command
  "updated_at": "<datetime: Timestamp of last task update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012/undo" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON - assuming status 'review' was undone, reverting to 'in_progress'):**
```json
{
  "id": "task_jkl012",
  "title": "Implement login feature",
  "description": "Implementation in progress for login feature.",
  "project_id": "proj_123abc",
  "creator_id": "user_xyz789",
  "assignee_id": "user_def456",
  "due_date": null,
  "priority": "high",
  "status": "in_progress", // Status reverted
  "tags": ["auth", "frontend"],
  "meta_data": null,
  "created_at": "2023-10-27T13:00:00Z",
  "updated_at": "2023-10-27T16:00:00Z" // Timestamp reflects this undo action
}
```

---

### POST /projects/{project_id}/tasks/{task_id}/redo

**Description:** Redo the last undone task command for this specific task.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>
- `task_id`: <str: The ID of the task for which to redo the command>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `TaskResponseDTO`)
```json
{
  "id": "<str: Task ID>",
  // ... other fields from TaskResponseDTO reflecting the state after redoing the command
  "updated_at": "<datetime: Timestamp of last task update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/projects/proj_123abc/tasks/task_jkl012/redo" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON - assuming status 'review' was redone):**
```json
{
  "id": "task_jkl012",
  "title": "Implement login feature",
  "description": "Implementation in progress for login feature.",
  "project_id": "proj_123abc",
  "creator_id": "user_xyz789",
  "assignee_id": "user_def456",
  "due_date": null,
  "priority": "high",
  "status": "review", // Status redone
  "tags": ["auth", "frontend"],
  "meta_data": null,
  "created_at": "2023-10-27T13:00:00Z",
  "updated_at": "2023-10-27T18:00:00Z" // Timestamp reflects this redo action
}
```

## Health Check Endpoint

### GET /health

**Description:** Health check endpoint. Standard health check to verify service availability.

**Required Headers:**
- None

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "status": "<str: Health status of the service>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/health"
```

**Example Response (JSON):**
```json
{
  "status": "healthy"
}
```

---
# Document Service API Documentation

This document provides details about the API endpoints for the Document Service. Most routes require an `Authorization: Bearer <token>` header for authentication. `Content-Type` will vary based on the endpoint (e.g., `application/json` for JSON payloads, `multipart/form-data` for file uploads).

## Document Endpoints

### POST /documents

**Description:** Create a new document (metadata entry).

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`DocumentCreateDTO`)
```json
{
  "name": "<str: Document name (1-255 chars)>",
  "project_id": "<str: Project ID to associate the document with>",
  "parent_id": "<Optional[str]: ID of the parent folder, if any>",
  "type": "<DocumentType: 'file' | 'folder' | 'link'>",
  "content_type": "<Optional[str]: MIME type for 'file' type, e.g., 'application/pdf'>",
  "url": "<Optional[str]: URL for 'link' type>",
  "description": "<Optional[str]: Document description>",
  "tags": "<Optional[List[str]]: List of tags, e.g., [\"report\", \"q4\"]>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>"
}
```

**Response Body:** (`200 OK` - `DocumentResponseDTO`)
```json
{
  "id": "<str: Document ID>",
  "name": "<str: Document name>",
  "project_id": "<str: Project ID>",
  "parent_id": "<Optional[str]: Parent folder ID>",
  "type": "<DocumentType: Document type>",
  "content_type": "<Optional[str]: MIME type>",
  "size": "<Optional[int]: Size in bytes (for files, typically updated after upload)>",
  "url": "<Optional[str]: URL (for links or after file upload)>",
  "description": "<Optional[str]: Document description>",
  "version": "<int: Initial version number (e.g., 1)>",
  "creator_id": "<str: User ID of the creator>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
  "created_at": "<datetime: Timestamp of document creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last document update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/documents" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "name": "Quarterly Report Q4",
    "project_id": "proj_123abc",
    "type": "file",
    "content_type": "application/pdf",
    "tags": ["report", "q4"]
  }'
```

**Example Response (JSON):**
```json
{
  "id": "doc_xyz789",
  "name": "Quarterly Report Q4",
  "project_id": "proj_123abc",
  "parent_id": null,
  "type": "file",
  "content_type": "application/pdf",
  "size": null,
  "url": null,
  "description": null,
  "version": 1,
  "creator_id": "user_def456",
  "tags": ["report", "q4"],
  "meta_data": null,
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": null
}
```

---

### GET /documents/{document_id}

**Description:** Get a document.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document to retrieve>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `DocumentResponseDTO`)
```json
{
  "id": "<str: Document ID>",
  "name": "<str: Document name>",
  // ... other fields from DocumentResponseDTO
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/documents/doc_xyz789" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "id": "doc_xyz789",
  "name": "Quarterly Report Q4",
  "project_id": "proj_123abc",
  "parent_id": null,
  "type": "file",
  "content_type": "application/pdf",
  "size": 102400, # Example size
  "url": "https://storage.example.com/doc_xyz789/report.pdf", # Example URL
  "description": null,
  "version": 1,
  "creator_id": "user_def456",
  "tags": ["report", "q4"],
  "meta_data": null,
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": "2023-10-27T10:05:00Z"
}
```

---

### PUT /documents/{document_id}

**Description:** Update a document (metadata).

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document to update>

**Query Parameters:**
- None

**Request Body:** (`DocumentUpdateDTO`)
```json
{
  "name": "<Optional[str]: New document name (1-255 chars)>",
  "parent_id": "<Optional[str]: New parent folder ID>",
  "description": "<Optional[str]: New document description>",
  "tags": "<Optional[List[str]]: New list of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: New metadata>"
}
```

**Response Body:** (`200 OK` - `DocumentResponseDTO`)
```json
{
  "id": "<str: Document ID>",
  "name": "<str: Updated document name>",
  // ... other fields from DocumentResponseDTO
  "updated_at": "<datetime: Timestamp of last document update>"
}
```

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/documents/doc_xyz789" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "description": "Final version of the Q4 report.",
    "tags": ["report", "q4", "final"]
  }'
```

**Example Response (JSON):**
```json
{
  "id": "doc_xyz789",
  "name": "Quarterly Report Q4",
  "project_id": "proj_123abc",
  "parent_id": null,
  "type": "file",
  "content_type": "application/pdf",
  "size": 102400,
  "url": "https://storage.example.com/doc_xyz789/report.pdf",
  "description": "Final version of the Q4 report.",
  "version": 1,
  "creator_id": "user_def456",
  "tags": ["report", "q4", "final"],
  "meta_data": null,
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": "2023-10-27T11:00:00Z"
}
```

---

### DELETE /documents/{document_id}

**Description:** Delete a document.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document to delete>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Document deleted successfully>"
}
```
*(Note: The service returns `Dict[str, Any]` which is represented here as a success message.)*

**Example Request (curl):**
```bash
curl -X DELETE "http://localhost:8000/documents/doc_xyz789" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "message": "Document doc_xyz789 deleted successfully"
}
```

---

### GET /projects/{project_id}/documents

**Description:** Get documents for a project. Can filter by `parent_id` to list contents of a folder.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `project_id`: <str: The ID of the project>

**Query Parameters:**
- `parent_id`: <Optional[str]: Parent document ID (to list contents of a folder). If null, lists root documents/folders for the project.>

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[DocumentResponseDTO]`)
```json
[
  {
    "id": "<str: Document ID>",
    "name": "<str: Document name>",
    // ... other fields from DocumentResponseDTO
  }
  // ... more documents
]
```

**Example Request (curl for root documents):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc/documents" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Request (curl for a folder's content):**
```bash
curl -X GET "http://localhost:8000/projects/proj_123abc/documents?parent_id=folder_parent_123" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "doc_xyz789",
    "name": "Quarterly Report Q4",
    "project_id": "proj_123abc",
    "parent_id": null,
    "type": "file",
    // ...
  },
  {
    "id": "folder_reports_q4",
    "name": "Q4 Reports",
    "project_id": "proj_123abc",
    "parent_id": null,
    "type": "folder",
    // ...
  }
]
```

---

### POST /documents/upload

**Description:** Initiates document upload process by creating a document record and returning a pre-signed URL for the client to upload the actual file to storage.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`DocumentCreateDTO`)
```json
{
  "name": "<str: Document name (1-255 chars)>",
  "project_id": "<str: Project ID>",
  "parent_id": "<Optional[str]: Parent folder ID>",
  "type": "<DocumentType: 'file'>", // Must be 'file' for upload
  "content_type": "<Optional[str]: MIME type of the file, e.g., 'application/pdf'>",
  "description": "<Optional[str]: Document description>",
  "tags": "<Optional[List[str]]: List of tags>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>"
}
```

**Response Body:** (`200 OK` - `DocumentUploadResponseDTO`)
```json
{
  "document": {
    "id": "<str: Document ID>",
    "name": "<str: Document name>",
    // ... other fields from DocumentResponseDTO (version will be 1, size and url might be null initially)
  },
  "upload_url": "<str: Pre-signed URL for the client to use for PUTting the file to storage>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/documents/upload" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "name": "Annual Presentation.pptx",
    "project_id": "proj_123abc",
    "type": "file",
    "content_type": "application/vnd.openxmlformats-officedocument.presentationml.presentation"
  }'
```

**Example Response (JSON):**
```json
{
  "document": {
    "id": "doc_pres123",
    "name": "Annual Presentation.pptx",
    "project_id": "proj_123abc",
    "parent_id": null,
    "type": "file",
    "content_type": "application/vnd.openxmlformats-officedocument.presentationml.presentation",
    "size": null,
    "url": null,
    "description": null,
    "version": 1,
    "creator_id": "user_def456",
    "tags": null,
    "meta_data": null,
    "created_at": "2023-10-27T12:00:00Z",
    "updated_at": null
  },
  "upload_url": "https://storage.example.com/presigned-url-for-upload?signature=..."
}
```
*(Note: The client would then use the `upload_url` to PUT the file content. That PUT request is not part of this endpoint.)*

## Document Version Endpoints

### POST /documents/{document_id}/versions

**Description:** Create a new document version (metadata). This endpoint registers a new version with content type and changes description. The actual file content upload for this version might be handled separately (e.g., via a pre-signed URL mechanism not detailed by this endpoint's direct inputs).

**Required Headers:**
- `Content-Type`: multipart/form-data
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document for which to create a new version>

**Query Parameters:**
- None

**Request Body (Form Data):**
- `content_type`: <str: Content type of the new version (e.g., 'application/pdf')>
- `changes`: <str: Description of changes in this version>

**Response Body:** (`200 OK` - `DocumentVersionDTO`)
```json
{
  "id": "<str: Document version ID>",
  "document_id": "<str: Document ID>",
  "version": "<int: New version number>",
  "size": "<Optional[int]: Size in bytes (may be updated later)>",
  "content_type": "<Optional[str]: Content type>",
  "url": "<Optional[str]: URL (may be updated later)>",
  "creator_id": "<str: User ID of the version creator>",
  "changes": "<Optional[str]: Description of changes>",
  "created_at": "<datetime: Timestamp of version creation>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/documents/doc_xyz789/versions" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -F "content_type=application/pdf" \
  -F "changes=Updated financial figures for Q4."
```

**Example Response (JSON):**
```json
{
  "id": "ver_abc123",
  "document_id": "doc_xyz789",
  "version": 2,
  "size": null,
  "content_type": "application/pdf",
  "url": null,
  "creator_id": "user_def456",
  "changes": "Updated financial figures for Q4.",
  "created_at": "2023-10-27T13:00:00Z"
}
```

---

### GET /documents/{document_id}/versions

**Description:** Get versions for a document.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[DocumentVersionDTO]`)
```json
[
  {
    "id": "<str: Document version ID>",
    "document_id": "<str: Document ID>",
    "version": "<int: Version number>",
    // ... other fields from DocumentVersionDTO
  }
  // ... more versions
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/documents/doc_xyz789/versions" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "ver_original",
    "document_id": "doc_xyz789",
    "version": 1,
    "size": 102400,
    "content_type": "application/pdf",
    "url": "https://storage.example.com/doc_xyz789/report_v1.pdf",
    "creator_id": "user_def456",
    "changes": "Initial version.",
    "created_at": "2023-10-27T10:05:00Z"
  },
  {
    "id": "ver_abc123",
    "document_id": "doc_xyz789",
    "version": 2,
    "size": 115000,
    "content_type": "application/pdf",
    "url": "https://storage.example.com/doc_xyz789/report_v2.pdf",
    "creator_id": "user_def456",
    "changes": "Updated financial figures for Q4.",
    "created_at": "2023-10-27T13:00:00Z"
  }
]
```

---

### GET /documents/{document_id}/versions/{version}

**Description:** Get a specific document version.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document>
- `version`: <int: The version number to retrieve>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `DocumentVersionDTO`)
```json
{
  "id": "<str: Document version ID>",
  "document_id": "<str: Document ID>",
  "version": "<int: Version number>",
  // ... other fields from DocumentVersionDTO
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/documents/doc_xyz789/versions/2" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "id": "ver_abc123",
  "document_id": "doc_xyz789",
  "version": 2,
  "size": 115000,
  "content_type": "application/pdf",
  "url": "https://storage.example.com/doc_xyz789/report_v2.pdf",
  "creator_id": "user_def456",
  "changes": "Updated financial figures for Q4.",
  "created_at": "2023-10-27T13:00:00Z"
}
```

## Document Permission Endpoints

### POST /documents/{document_id}/permissions

**Description:** Add a permission to a document for a user or role.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document>

**Query Parameters:**
- None

**Request Body:** (`DocumentPermissionCreateDTO`)
```json
{
  "user_id": "<Optional[str]: User ID to grant permission to>",
  "role_id": "<Optional[str]: Role ID to grant permission to (either user_id or role_id should be provided)>",
  "can_view": "<bool: View permission (default: true)>",
  "can_edit": "<bool: Edit permission (default: false)>",
  "can_delete": "<bool: Delete permission (default: false)>",
  "can_share": "<bool: Share permission (default: false)>"
}
```

**Response Body:** (`200 OK` - `DocumentPermissionDTO`)
```json
{
  "id": "<str: Permission record ID>",
  "document_id": "<str: Document ID>",
  "user_id": "<Optional[str]: User ID>",
  "role_id": "<Optional[str]: Role ID>",
  "can_view": "<bool: View permission>",
  "can_edit": "<bool: Edit permission>",
  "can_delete": "<bool: Delete permission>",
  "can_share": "<bool: Share permission>",
  "created_at": "<datetime: Timestamp of permission creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last permission update>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/documents/doc_xyz789/permissions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "user_id": "user_collaborator1",
    "can_edit": true
  }'
```

**Example Response (JSON):**
```json
{
  "id": "perm_123",
  "document_id": "doc_xyz789",
  "user_id": "user_collaborator1",
  "role_id": null,
  "can_view": true,
  "can_edit": true,
  "can_delete": false,
  "can_share": false,
  "created_at": "2023-10-27T14:00:00Z",
  "updated_at": null
}
```

---

### PUT /documents/{document_id}/permissions/{permission_id}

**Description:** Update a document permission.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document>
- `permission_id`: <str: The ID of the permission record to update>

**Query Parameters:**
- None

**Request Body:** (`DocumentPermissionUpdateDTO`)
```json
{
  "can_view": "<Optional[bool]: View permission>",
  "can_edit": "<Optional[bool]: Edit permission>",
  "can_delete": "<Optional[bool]: Delete permission>",
  "can_share": "<Optional[bool]: Share permission>"
}
```

**Response Body:** (`200 OK` - `DocumentPermissionDTO`)
```json
{
  "id": "<str: Permission record ID>",
  // ... other fields from DocumentPermissionDTO
  "updated_at": "<datetime: Timestamp of last permission update>"
}
```

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/documents/doc_xyz789/permissions/perm_123" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "can_edit": false,
    "can_share": true
  }'
```

**Example Response (JSON):**
```json
{
  "id": "perm_123",
  "document_id": "doc_xyz789",
  "user_id": "user_collaborator1",
  "role_id": null,
  "can_view": true,
  "can_edit": false,
  "can_delete": false,
  "can_share": true,
  "created_at": "2023-10-27T14:00:00Z",
  "updated_at": "2023-10-27T15:00:00Z"
}
```

---

### DELETE /documents/{document_id}/permissions/{permission_id}

**Description:** Delete a document permission.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document>
- `permission_id`: <str: The ID of the permission record to delete>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Permission deleted successfully>"
}
```
*(Note: The service returns `Dict[str, Any]` which is represented here as a success message.)*

**Example Request (curl):**
```bash
curl -X DELETE "http://localhost:8000/documents/doc_xyz789/permissions/perm_123" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "message": "Permission perm_123 deleted successfully"
}
```

---

### GET /documents/{document_id}/permissions

**Description:** Get permissions for a document.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `document_id`: <str: The ID of the document>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[DocumentPermissionDTO]`)
```json
[
  {
    "id": "<str: Permission record ID>",
    // ... other fields from DocumentPermissionDTO
  }
  // ... more permissions
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/documents/doc_xyz789/permissions" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "perm_owner",
    "document_id": "doc_xyz789",
    "user_id": "user_def456", // Owner
    "role_id": null,
    "can_view": true,
    "can_edit": true,
    "can_delete": true,
    "can_share": true,
    "created_at": "2023-10-27T10:00:00Z",
    "updated_at": null
  },
  {
    "id": "perm_123",
    "document_id": "doc_xyz789",
    "user_id": "user_collaborator1",
    "role_id": null,
    "can_view": true,
    "can_edit": false,
    "can_delete": false,
    "can_share": true,
    "created_at": "2023-10-27T14:00:00Z",
    "updated_at": "2023-10-27T15:00:00Z"
  }
]
```

## Document Conversion Endpoint

### POST /documents/convert

**Description:** Converts a document using LibreOffice Online and uploads the result to Supabase Storage.

**Required Headers:**
- `Content-Type`: multipart/form-data
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body (Form Data):**
- `file`: <UploadFile: The document file to convert (e.g., .docx, .pptx)>
- `output_format`: <str: The desired output format (default: 'pdf', e.g., 'txt', 'html')>
- `supabase_bucket`: <str: Supabase bucket to upload to (default: 'documents')>
- `supabase_path`: <Optional[str]: Path within the Supabase bucket. If not provided, defaults to `converted/{original_filename}.{output_format}`.>

**Response Body:** (`200 OK`)
```json
{
  "url": "<str: URL of the converted document in Supabase Storage>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/documents/convert" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -F "file=@/path/to/your/document.docx" \
  -F "output_format=pdf" \
  -F "supabase_bucket=converted-docs" \
  -F "supabase_path=reports/my_converted_report.pdf"
```

**Example Response (JSON):**
```json
{
  "url": "https://your-supabase-instance.supabase.co/storage/v1/object/public/converted-docs/reports/my_converted_report.pdf"
}
```

## Health Check Endpoint

### GET /health

**Description:** Health check endpoint. Standard health check to verify service availability.

**Required Headers:**
- None

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "status": "<str: Health status of the service>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/health"
```

**Example Response (JSON):**
```json
{
  "status": "healthy"
}
```

---
# Notification Service API Documentation

This document provides details about the API endpoints for the Notification Service. All routes, unless otherwise specified, require an `Authorization: Bearer <token>` header for authentication and expect `Content-Type: application/json` for request bodies.

## Notification Endpoints

### POST /notifications

**Description:** Create a new notification.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`NotificationCreateDTO`)
```json
{
  "user_id": "<str: The ID of the user to notify>",
  "type": "<NotificationType: system | project | task | document | mention | invitation | reminder>",
  "title": "<str: Title of the notification>",
  "message": "<str: Main content of the notification>",
  "priority": "<NotificationPriority: low | normal | high (default: normal)>",
  "channels": "<List[NotificationChannel]: e.g., [\"in_app\", \"email\"] (default: [\"in_app\"])>",
  "related_entity_type": "<Optional[str]: Type of entity this notification relates to (e.g., 'task', 'project')>",
  "related_entity_id": "<Optional[str]: ID of the related entity>",
  "action_url": "<Optional[str]: URL for action when notification is clicked>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
  "scheduled_at": "<Optional[datetime]: Timestamp for scheduled delivery, e.g., 2023-12-01T10:00:00Z>"
}
```

**Response Body:** (`200 OK` - `NotificationResponseDTO`)
```json
{
  "id": "<str: Notification ID>",
  "user_id": "<str: User ID>",
  "type": "<NotificationType: Notification type>",
  "title": "<str: Notification title>",
  "message": "<str: Notification message>",
  "priority": "<NotificationPriority: Notification priority>",
  "channels": "<List[NotificationChannel]: Channels used>",
  "related_entity_type": "<Optional[str]: Related entity type>",
  "related_entity_id": "<Optional[str]: Related entity ID>",
  "action_url": "<Optional[str]: Action URL>",
  "meta_data": "<Optional[Dict[str, Any]]: Metadata>",
  "is_read": "<bool: False initially>",
  "read_at": "<Optional[datetime]: Timestamp when read>",
  "created_at": "<datetime: Timestamp of creation>",
  "scheduled_at": "<Optional[datetime]: Scheduled delivery time>",
  "sent_at": "<Optional[datetime]: Timestamp when sent>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/notifications" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "user_id": "user_123",
    "type": "task",
    "title": "New Task Assigned",
    "message": "You have been assigned a new task: Finalize Report Q4.",
    "related_entity_type": "task",
    "related_entity_id": "task_abc789",
    "action_url": "/tasks/task_abc789"
  }'
```

**Example Response (JSON):**
```json
{
  "id": "notif_xyz456",
  "user_id": "user_123",
  "type": "task",
  "title": "New Task Assigned",
  "message": "You have been assigned a new task: Finalize Report Q4.",
  "priority": "normal",
  "channels": ["in_app"],
  "related_entity_type": "task",
  "related_entity_id": "task_abc789",
  "action_url": "/tasks/task_abc789",
  "meta_data": null,
  "is_read": false,
  "read_at": null,
  "created_at": "2023-10-27T10:00:00Z",
  "scheduled_at": null,
  "sent_at": null
}
```

---

### POST /notifications/batch

**Description:** Create multiple notifications at once for different users.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`NotificationBatchCreateDTO`)
```json
{
  "user_ids": "<List[str]: List of user IDs to notify>",
  "type": "<NotificationType: system | project | task | document | mention | invitation | reminder>",
  "title": "<str: Title of the notification>",
  "message": "<str: Main content of the notification>",
  "priority": "<NotificationPriority: low | normal | high (default: normal)>",
  "channels": "<List[NotificationChannel]: e.g., [\"in_app\", \"email\"] (default: [\"in_app\"])>",
  "related_entity_type": "<Optional[str]: Type of entity this notification relates to>",
  "related_entity_id": "<Optional[str]: ID of the related entity>",
  "action_url": "<Optional[str]: URL for action>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
  "scheduled_at": "<Optional[datetime]: Timestamp for scheduled delivery>"
}
```

**Response Body:** (`200 OK` - `List[NotificationResponseDTO]`)
```json
[
  {
    "id": "<str: Notification ID>",
    "user_id": "<str: User ID>",
    // ... other fields from NotificationResponseDTO
  }
  // ... more notification responses
]
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/notifications/batch" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "user_ids": ["user_123", "user_456"],
    "type": "project",
    "title": "Project Update",
    "message": "Project Alpha has been updated with new milestones.",
    "related_entity_type": "project",
    "related_entity_id": "proj_alpha"
  }'
```

**Example Response (JSON):**
```json
[
  {
    "id": "notif_batch_1",
    "user_id": "user_123",
    "type": "project",
    "title": "Project Update",
    "message": "Project Alpha has been updated with new milestones.",
    "priority": "normal",
    "channels": ["in_app"],
    "related_entity_type": "project",
    "related_entity_id": "proj_alpha",
    "action_url": null,
    "meta_data": null,
    "is_read": false,
    "read_at": null,
    "created_at": "2023-10-27T11:00:00Z",
    "scheduled_at": null,
    "sent_at": null
  },
  {
    "id": "notif_batch_2",
    "user_id": "user_456",
    "type": "project",
    "title": "Project Update",
    "message": "Project Alpha has been updated with new milestones.",
    "priority": "normal",
    "channels": ["in_app"],
    "related_entity_type": "project",
    "related_entity_id": "proj_alpha",
    "action_url": null,
    "meta_data": null,
    "is_read": false,
    "read_at": null,
    "created_at": "2023-10-27T11:00:00Z",
    "scheduled_at": null,
    "sent_at": null
  }
]
```

---

### GET /notifications

**Description:** Get notifications for current user.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- `limit`: <int: Number of notifications to return (default: 100)>
- `offset`: <int: Number of notifications to skip (default: 0)>

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[NotificationResponseDTO]`)
```json
[
  {
    "id": "<str: Notification ID>",
    // ... other fields from NotificationResponseDTO
  }
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/notifications?limit=10&offset=0" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "notif_xyz456",
    "user_id": "user_123",
    "type": "task",
    "title": "New Task Assigned",
    "message": "You have been assigned a new task: Finalize Report Q4.",
    "priority": "normal",
    "channels": ["in_app"],
    "related_entity_type": "task",
    "related_entity_id": "task_abc789",
    "action_url": "/tasks/task_abc789",
    "meta_data": null,
    "is_read": false,
    "read_at": null,
    "created_at": "2023-10-27T10:00:00Z",
    "scheduled_at": null,
    "sent_at": null
  }
  // ... more notifications
]
```

---

### GET /notifications/unread

**Description:** Get unread notifications for current user.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- `limit`: <int: Number of unread notifications to return (default: 100)>
- `offset`: <int: Number of unread notifications to skip (default: 0)>

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[NotificationResponseDTO]`)
```json
[
  {
    "id": "<str: Notification ID>",
    "is_read": false,
    // ... other fields from NotificationResponseDTO
  }
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/notifications/unread?limit=5" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "notif_xyz456",
    "user_id": "user_123",
    "type": "task",
    "title": "New Task Assigned",
    "message": "You have been assigned a new task: Finalize Report Q4.",
    "priority": "normal",
    "channels": ["in_app"],
    "related_entity_type": "task",
    "related_entity_id": "task_abc789",
    "action_url": "/tasks/task_abc789",
    "meta_data": null,
    "is_read": false,
    "read_at": null,
    "created_at": "2023-10-27T10:00:00Z",
    "scheduled_at": null,
    "sent_at": null
  }
  // ... more unread notifications
]
```

---

### PUT /notifications/{notification_id}/read

**Description:** Mark a notification as read.

**Required Headers:**
- `Content-Type`: application/json (though body is not strictly needed, FastAPI might expect it for PUT)
- `Authorization`: Bearer <token>

**Path Parameters:**
- `notification_id`: <str: The ID of the notification to mark as read>

**Query Parameters:**
- None

**Request Body:**
- None (or empty JSON object `{}`)

**Response Body:** (`200 OK` - `NotificationResponseDTO`)
```json
{
  "id": "<str: Notification ID>",
  "is_read": true,
  "read_at": "<datetime: Timestamp when marked as read>",
  // ... other fields from NotificationResponseDTO
}
```

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/notifications/notif_xyz456/read" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{}'
```

**Example Response (JSON):**
```json
{
  "id": "notif_xyz456",
  "user_id": "user_123",
  "type": "task",
  "title": "New Task Assigned",
  "message": "You have been assigned a new task: Finalize Report Q4.",
  "priority": "normal",
  "channels": ["in_app"],
  "related_entity_type": "task",
  "related_entity_id": "task_abc789",
  "action_url": "/tasks/task_abc789",
  "meta_data": null,
  "is_read": true,
  "read_at": "2023-10-27T12:00:00Z",
  "created_at": "2023-10-27T10:00:00Z",
  "scheduled_at": null,
  "sent_at": null
}
```

---

### PUT /notifications/read-all

**Description:** Mark all notifications as read for current user.

**Required Headers:**
- `Content-Type`: application/json (though body is not strictly needed)
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None (or empty JSON object `{}`)

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., All notifications marked as read.>",
  "count": "<int: Number of notifications marked as read>"
}
```
*(Note: The service returns `Dict[str, Any]`. This is an example structure based on common practice.)*

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/notifications/read-all" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{}'
```

**Example Response (JSON):**
```json
{
  "message": "All notifications marked as read for user user_123.",
  "count": 5
}
```

---

### DELETE /notifications/{notification_id}

**Description:** Delete a notification.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `notification_id`: <str: The ID of the notification to delete>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Notification deleted successfully.>"
}
```
*(Note: The service returns `Dict[str, Any]`. This is an example structure.)*

**Example Request (curl):**
```bash
curl -X DELETE "http://localhost:8000/notifications/notif_xyz456" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "message": "Notification notif_xyz456 deleted successfully."
}
```

## Notification Preferences Endpoints

### GET /notification-preferences

**Description:** Get notification preferences for current user.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `NotificationPreferencesDTO`)
```json
{
  "user_id": "<str: User ID>",
  "email_enabled": "<bool: General email notification enabled>",
  "push_enabled": "<bool: General push notification enabled>",
  "sms_enabled": "<bool: General SMS notification enabled>",
  "in_app_enabled": "<bool: General in-app notification enabled>",
  "digest_enabled": "<bool: Digest email enabled>",
  "digest_frequency": "<Optional[str]: 'daily' | 'weekly'>",
  "quiet_hours_enabled": "<bool: Quiet hours enabled>",
  "quiet_hours_start": "<Optional[str]: HH:MM format, e.g., '22:00'>",
  "quiet_hours_end": "<Optional[str]: HH:MM format, e.g., '08:00'>",
  "preferences_by_type": "<Optional[Dict[str, Dict[str, bool]]]: Fine-grained preferences, e.g., {\"task\": {\"email\": true, \"push\": false}}>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/notification-preferences" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "user_id": "user_123",
  "email_enabled": true,
  "push_enabled": true,
  "sms_enabled": false,
  "in_app_enabled": true,
  "digest_enabled": false,
  "digest_frequency": null,
  "quiet_hours_enabled": false,
  "quiet_hours_start": null,
  "quiet_hours_end": null,
  "preferences_by_type": {
    "task": {"email": true, "in_app": true},
    "project": {"email": false, "in_app": true}
  }
}
```

---

### PUT /notification-preferences

**Description:** Update notification preferences for current user.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`NotificationPreferencesUpdateDTO`)
```json
{
  "email_enabled": "<Optional[bool]: General email notification enabled>",
  "push_enabled": "<Optional[bool]: General push notification enabled>",
  "sms_enabled": "<Optional[bool]: General SMS notification enabled>",
  "in_app_enabled": "<Optional[bool]: General in-app notification enabled>",
  "digest_enabled": "<Optional[bool]: Digest email enabled>",
  "digest_frequency": "<Optional[str]: 'daily' | 'weekly'>",
  "quiet_hours_enabled": "<Optional[bool]: Quiet hours enabled>",
  "quiet_hours_start": "<Optional[str]: HH:MM format, e.g., '22:00'>",
  "quiet_hours_end": "<Optional[str]: HH:MM format, e.g., '08:00'>",
  "preferences_by_type": "<Optional[Dict[str, Dict[str, bool]]]: Fine-grained preferences, e.g., {\"task\": {\"email\": true, \"push\": false}}>"
}
```

**Response Body:** (`200 OK` - `NotificationPreferencesDTO`)
```json
{
  "user_id": "<str: User ID>",
  "email_enabled": "<bool: Updated email preference>",
  // ... other fields from NotificationPreferencesDTO
}
```

**Example Request (curl):**
```bash
curl -X PUT "http://localhost:8000/notification-preferences" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "email_enabled": false,
    "quiet_hours_enabled": true,
    "quiet_hours_start": "23:00",
    "quiet_hours_end": "07:00",
    "preferences_by_type": {
      "task": {"email": false, "in_app": true},
      "mention": {"push": true, "in_app": true}
    }
  }'
```

**Example Response (JSON):**
```json
{
  "user_id": "user_123",
  "email_enabled": false,
  "push_enabled": true,
  "sms_enabled": false,
  "in_app_enabled": true,
  "digest_enabled": false,
  "digest_frequency": null,
  "quiet_hours_enabled": true,
  "quiet_hours_start": "23:00",
  "quiet_hours_end": "07:00",
  "preferences_by_type": {
    "task": {"email": false, "in_app": true},
    "project": {"email": false, "in_app": true}, // Assuming project was pre-existing and not changed
    "mention": {"push": true, "in_app": true}
  }
}
```

## Health Check Endpoint

### GET /health

**Description:** Health check endpoint. Standard health check to verify service availability.

**Required Headers:**
- None

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "status": "<str: Health status of the service>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/health"
```

**Example Response (JSON):**
```json
{
  "status": "healthy"
}
```

---
# External Tools Service API Documentation

This document provides details about the API endpoints for the External Tools Service. All routes, unless otherwise specified, require an `Authorization: Bearer <token>` header for authentication and generally expect `Content-Type: application/json` for request bodies.

## OAuth Provider Endpoints

### GET /oauth/providers

**Description:** Get OAuth providers. Lists available third-party services that can be connected via OAuth.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[OAuthProviderDTO]`)
```json
[
  {
    "id": "<str: Provider's unique identifier, e.g., 'google_drive'>",
    "name": "<str: Human-readable name, e.g., 'Google Drive'>",
    "type": "<ExternalToolType: Enum representing the tool type, e.g., 'google_drive'>",
    "auth_url": "<HttpUrl: The authorization URL for the provider>",
    "token_url": "<HttpUrl: The token exchange URL for the provider>",
    "scope": "<str: The default OAuth scopes required>",
    "client_id": "<str: The client ID for the OAuth application>",
    "redirect_uri": "<HttpUrl: The default redirect URI registered with the provider>",
    "additional_params": "<Optional[Dict[str, Any]]: Additional parameters for the auth URL>"
  }
  // ... more providers
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/oauth/providers" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "google_drive_test",
    "name": "Google Drive (Test)",
    "type": "google_drive",
    "auth_url": "https://accounts.google.com/o/oauth2/v2/auth",
    "token_url": "https://oauth2.googleapis.com/token",
    "scope": "https://www.googleapis.com/auth/drive.readonly",
    "client_id": "your-google-client-id",
    "redirect_uri": "http://localhost:3000/oauth/callback/google_drive",
    "additional_params": {"access_type": "offline", "prompt": "consent"}
  }
]
```

---

### GET /oauth/providers/{provider_id}

**Description:** Get OAuth provider. Retrieves details for a specific OAuth provider.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `provider_id`: <str: The unique identifier of the OAuth provider>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `OAuthProviderDTO`)
```json
{
  "id": "<str: Provider's unique identifier>",
  "name": "<str: Human-readable name>",
  // ... other fields from OAuthProviderDTO
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/oauth/providers/google_drive_test" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "id": "google_drive_test",
  "name": "Google Drive (Test)",
  "type": "google_drive",
  "auth_url": "https://accounts.google.com/o/oauth2/v2/auth",
  "token_url": "https://oauth2.googleapis.com/token",
  "scope": "https://www.googleapis.com/auth/drive.readonly",
  "client_id": "your-google-client-id",
  "redirect_uri": "http://localhost:3000/oauth/callback/google_drive",
  "additional_params": {"access_type": "offline", "prompt": "consent"}
}
```

## OAuth Endpoints

### POST /oauth/authorize

**Description:** Get OAuth authorization URL. Constructs and returns the URL to redirect the user to for OAuth authorization with the specified provider.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`OAuthRequestDTO`)
```json
{
  "provider_id": "<str: The ID of the OAuth provider to authorize with>",
  "redirect_uri": "<Optional[HttpUrl]: Custom redirect URI if different from provider default>",
  "scope": "<Optional[str]: Custom OAuth scopes if different from provider default>",
  "state": "<Optional[str]: An opaque value used to maintain state between the request and callback>"
}
```

**Response Body:** (`200 OK` - `str`)
Returns the authorization URL as a plain string.
```
"https://accounts.google.com/o/oauth2/v2/auth?client_id=your-google-client-id&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Foauth%2Fcallback%2Fgoogle_drive&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive.readonly&response_type=code&access_type=offline&prompt=consent&state=custom_state_value"
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/oauth/authorize" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "provider_id": "google_drive_test",
    "state": "custom_state_value123"
  }'
```

**Example Response (Plain Text):**
```
"https://accounts.google.com/o/oauth2/v2/auth?client_id=your-google-client-id&redirect_uri=http%3A%2F%2Flocalhost%3A3000%2Foauth%2Fcallback%2Fgoogle_drive&scope=https%3A%2F%2Fwww.googleapis.com%2Fauth%2Fdrive.readonly&response_type=code&access_type=offline&prompt=consent&state=custom_state_value123"
```

---

### POST /oauth/callback

**Description:** Handle OAuth callback. Processes the authorization code received from the OAuth provider after user authorization, exchanges it for tokens, and creates/updates an external tool connection.

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`OAuthCallbackDTO`)
```json
{
  "provider_id": "<str: The ID of the OAuth provider>",
  "code": "<str: The authorization code received from the provider>",
  "state": "<Optional[str]: The state value, if one was sent in the authorization request>",
  "error": "<Optional[str]: Any error string received from the provider>"
}
```

**Response Body:** (`200 OK` - `ExternalToolConnectionDTO`)
```json
{
  "id": "<str: Connection ID>",
  "user_id": "<str: User ID>",
  "provider_id": "<str: Provider ID>",
  "provider_type": "<ExternalToolType: Provider type>",
  "account_name": "<Optional[str]: Name of the connected account>",
  "account_email": "<Optional[str]: Email of the connected account>",
  "account_id": "<Optional[str]: Account ID from the provider>",
  "is_active": "<bool: True if connection is active>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata>",
  "created_at": "<datetime: Timestamp of creation>",
  "updated_at": "<Optional[datetime]: Timestamp of last update>",
  "last_used_at": "<Optional[datetime]: Timestamp of last use>",
  "expires_at": "<Optional[datetime]: Token expiry timestamp>"
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/oauth/callback" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "provider_id": "google_drive_test",
    "code": "auth_code_from_google",
    "state": "custom_state_value123"
  }'
```

**Example Response (JSON):**
```json
{
  "id": "conn_123xyz",
  "user_id": "user_abc",
  "provider_id": "google_drive_test",
  "provider_type": "google_drive",
  "account_name": "Test User",
  "account_email": "test.user@example.com",
  "account_id": "google_user_id_123",
  "is_active": true,
  "meta_data": {"some_provider_info": "details"},
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": "2023-10-27T10:00:00Z",
  "last_used_at": null,
  "expires_at": "2023-10-27T11:00:00Z"
}
```

## External Tool Connection Endpoints

### POST /connections

**Description:** Create external tool connection (manually, if not using OAuth flow or for tools that use API keys).

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:** (`ExternalToolConnectionCreateDTO`)
```json
{
  "provider_id": "<str: ID of the provider (must exist)>",
  "access_token": "<str: Access token for the external tool>",
  "refresh_token": "<Optional[str]: Refresh token, if applicable>",
  "account_name": "<Optional[str]: Name of the account>",
  "account_email": "<Optional[str]: Email of the account>",
  "account_id": "<Optional[str]: External account ID>",
  "meta_data": "<Optional[Dict[str, Any]]: Additional metadata, e.g., API key if access_token is not used>",
  "expires_at": "<Optional[datetime]: Token expiry timestamp>"
}
```

**Response Body:** (`200 OK` - `ExternalToolConnectionDTO`)
```json
{
  "id": "<str: Connection ID>",
  // ... other fields from ExternalToolConnectionDTO
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/connections" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "provider_id": "custom_api_service",
    "access_token": "user_provided_api_key_or_token",
    "account_name": "My Custom Service Account"
  }'
```

**Example Response (JSON):**
```json
{
  "id": "conn_manual_abc",
  "user_id": "user_abc",
  "provider_id": "custom_api_service",
  "provider_type": "custom",
  "account_name": "My Custom Service Account",
  "account_email": null,
  "account_id": null,
  "is_active": true,
  "meta_data": null,
  "created_at": "2023-10-27T11:00:00Z",
  "updated_at": "2023-10-27T11:00:00Z",
  "last_used_at": null,
  "expires_at": null
}
```

---

### GET /connections

**Description:** Get connections for current user.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `List[ExternalToolConnectionDTO]`)
```json
[
  {
    "id": "<str: Connection ID>",
    // ... other fields from ExternalToolConnectionDTO
  }
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/connections" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "id": "conn_123xyz",
    "user_id": "user_abc",
    "provider_id": "google_drive_test",
    "provider_type": "google_drive",
    "account_name": "Test User",
    // ...
  },
  {
    "id": "conn_manual_abc",
    "user_id": "user_abc",
    "provider_id": "custom_api_service",
    "provider_type": "custom",
    "account_name": "My Custom Service Account",
    // ...
  }
]
```

---

### GET /connections/{connection_id}

**Description:** Get a connection.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `connection_id`: <str: The ID of the connection to retrieve>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK` - `ExternalToolConnectionDTO`)
```json
{
  "id": "<str: Connection ID>",
  // ... other fields from ExternalToolConnectionDTO
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/connections/conn_123xyz" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "id": "conn_123xyz",
  "user_id": "user_abc",
  "provider_id": "google_drive_test",
  "provider_type": "google_drive",
  "account_name": "Test User",
  "account_email": "test.user@example.com",
  "account_id": "google_user_id_123",
  "is_active": true,
  "meta_data": {"some_provider_info": "details"},
  "created_at": "2023-10-27T10:00:00Z",
  "updated_at": "2023-10-27T10:00:00Z",
  "last_used_at": null,
  "expires_at": "2023-10-27T11:00:00Z"
}
```

---

### POST /connections/{connection_id}/refresh

**Description:** Refresh connection token. Attempts to use a refresh token (if available) to get a new access token for the connection.

**Required Headers:**
- `Content-Type`: application/json (though body is not strictly needed)
- `Authorization`: Bearer <token>

**Path Parameters:**
- `connection_id`: <str: The ID of the connection to refresh>

**Query Parameters:**
- None

**Request Body:**
- None (or empty JSON object `{}`)

**Response Body:** (`200 OK` - `ExternalToolConnectionDTO`)
```json
{
  "id": "<str: Connection ID>",
  "expires_at": "<Optional[datetime]: Updated token expiry timestamp>",
  // ... other fields from ExternalToolConnectionDTO
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/connections/conn_123xyz/refresh" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{}'
```

**Example Response (JSON):**
```json
{
  "id": "conn_123xyz",
  "user_id": "user_abc",
  "provider_id": "google_drive_test",
  "provider_type": "google_drive",
  "account_name": "Test User",
  "is_active": true,
  "updated_at": "2023-10-27T12:00:00Z",
  "expires_at": "2023-10-27T13:00:00Z", // New expiry
  // ... other fields
}
```

---

### POST /connections/{connection_id}/revoke

**Description:** Revoke connection. Invalidates the access token with the provider and marks the connection as inactive.

**Required Headers:**
- `Content-Type`: application/json (though body is not strictly needed)
- `Authorization`: Bearer <token>

**Path Parameters:**
- `connection_id`: <str: The ID of the connection to revoke>

**Query Parameters:**
- None

**Request Body:**
- None (or empty JSON object `{}`)

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Connection revoked successfully.>",
  "connection_id": "<str: ID of the revoked connection>"
}
```
*(Note: The service returns `Dict[str, Any]`. This is an example structure.)*

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/connections/conn_123xyz/revoke" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{}'
```

**Example Response (JSON):**
```json
{
  "message": "Connection revoked successfully.",
  "connection_id": "conn_123xyz"
}
```

---

### DELETE /connections/{connection_id}

**Description:** Delete connection. Removes the connection record from the system. Does not necessarily revoke the token with the provider.

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `connection_id`: <str: The ID of the connection to delete>

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "message": "<str: Confirmation message, e.g., Connection deleted successfully.>",
  "connection_id": "<str: ID of the deleted connection>"
}
```
*(Note: The service returns `Dict[str, Any]`. This is an example structure.)*

**Example Request (curl):**
```bash
curl -X DELETE "http://localhost:8000/connections/conn_123xyz" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "message": "Connection deleted successfully.",
  "connection_id": "conn_123xyz"
}
```

## Analytics Endpoint

### GET /analytics/card/{card_id}

**Description:** Obtiene datos de una tarjeta de Metabase y opcionalmente los guarda en Supabase. (Fetches data from a Metabase card and optionally saves it to Supabase.)

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- `card_id`: <int: The ID of the Metabase card>

**Query Parameters:**
- `session_token`: <str: Metabase session token>
- `metabase_url`: <str: Base URL of the Metabase instance>
- `supabase_bucket`: <Optional[str]: Supabase bucket to save the data (if provided)>
- `supabase_path`: <Optional[str]: Path within the Supabase bucket (if saving to Supabase)>

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "data": "<Any: The data retrieved from the Metabase card, typically a list of records or aggregated results. Structure depends on the card.>"
  // If saved to Supabase, the response might include the Supabase URL or just the data.
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/analytics/card/15?session_token=your_metabase_session_token&metabase_url=https%3A%2F%2Fmetabase.example.com&supabase_bucket=analytics_results&supabase_path=card_15_data.json" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
{
  "data": [
    {"category": "A", "count": 100, "sum_value": 1500.50},
    {"category": "B", "count": 75, "sum_value": 1200.75}
  ]
  // Could also be: {"data": "https://your-supabase-url/analytics_results/card_15_data.json"} if data is just uploaded.
  // The current service code returns the data directly.
}
```

## AI Endpoint

### POST /ai/inference/{model}

**Description:** Realiza inferencia con Hugging Face y opcionalmente guarda el resultado en Supabase. (Performs inference with Hugging Face and optionally saves the result to Supabase.)

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- `model`: <str: The Hugging Face model ID to use for inference (e.g., 'gpt2', 'distilbert-base-uncased-finetuned-sst-2-english')>

**Query Parameters:**
- `supabase_bucket`: <Optional[str]: Supabase bucket to save the result (if provided)>
- `supabase_path`: <Optional[str]: Path within the Supabase bucket (if saving to Supabase)>

**Request Body:**
A flexible JSON object containing the payload specific to the Hugging Face model.
```json
{
  "inputs": "<str or Dict or List: The input data for the model. Structure varies greatly depending on the model and task. E.g., for text generation: {\"inputs\": \"Hello, my name is\"}, for text classification: {\"inputs\": \"This is a great movie!\"} >"
  // Other model-specific parameters can be included, e.g., "parameters": {"max_length": 50}
}
```

**Response Body:** (`200 OK`)
```json
{
  "result": "<Any: The result from the Hugging Face model. Structure depends on the model and task.>"
  // If saved to Supabase, the response might include the Supabase URL or just the result.
}
```

**Example Request (curl for text generation with gpt2):**
```bash
curl -X POST "http://localhost:8000/ai/inference/gpt2?supabase_bucket=ai_results&supabase_path=gpt2_output.json" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "inputs": "Once upon a time in a land far away"
  }'
```

**Example Response (JSON for text generation):**
```json
{
  "result": [ // Example structure for text generation
    {
      "generated_text": "Once upon a time in a land far away, there lived a princess..."
    }
  ]
  // The current service code returns the result directly.
}
```

## Calendar Endpoints

### GET /calendar/events

**Description:** Lista eventos del calendario CalDAV (Radicale). (Lists events from the CalDAV calendar (Radicale).)

**Required Headers:**
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- `calendar_path`: <Optional[str]: Path to the specific calendar on the CalDAV server. If not provided, might use a default user calendar or list all accessible calendars/events. (e.g., 'username/calendar_name.ics')>

**Request Body:**
- None

**Response Body:** (`200 OK`)
A list of calendar events. The structure of each event depends on the `python-caldav` library's representation, often VEVENT components.
```json
[
  {
    "uid": "<str: Unique ID of the event>",
    "summary": "<str: Event summary/title>",
    "dtstart": "<str: ISO 8601 start datetime>",
    "dtend": "<str: ISO 8601 end datetime>",
    "description": "<Optional[str]: Event description>",
    "location": "<Optional[str]: Event location>",
    // ... other VEVENT properties
  }
]
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/calendar/events?calendar_path=myuser/primary.ics" \
  -H "Authorization: Bearer <your_jwt_token>"
```

**Example Response (JSON):**
```json
[
  {
    "uid": "event-uid-12345",
    "summary": "Team Meeting",
    "dtstart": "2023-11-15T10:00:00Z",
    "dtend": "2023-11-15T11:00:00Z",
    "description": "Discuss project milestones.",
    "location": "Conference Room 4B"
  }
]
```

---

### POST /calendar/events

**Description:** Crea un evento en el calendario CalDAV (Radicale). (Creates an event in the CalDAV calendar (Radicale).)

**Required Headers:**
- `Content-Type`: application/json
- `Authorization`: Bearer <token>

**Path Parameters:**
- None

**Query Parameters:**
- None (The parameters `summary`, `dtstart`, `dtend`, `calendar_path` are taken from the request body as JSON fields based on the function signature.)

**Request Body:**
```json
{
  "summary": "<str: Summary or title of the event>",
  "dtstart": "<str: Start datetime of the event in ISO 8601 format (e.g., '2023-12-01T14:00:00Z')>",
  "dtend": "<str: End datetime of the event in ISO 8601 format (e.g., '2023-12-01T15:00:00Z')>",
  "calendar_path": "<Optional[str]: Path to the specific calendar on the CalDAV server. If not provided, might use a default user calendar. (e.g., 'username/calendar_name.ics')>"
}
```

**Response Body:** (`200 OK`)
The created calendar event details, or a success message. The current service code returns the event object from `python-caldav`.
```json
{
  "uid": "<str: Unique ID of the created event>",
  "summary": "<str: Event summary>",
  "dtstart": "<str: ISO 8601 start datetime>",
  "dtend": "<str: ISO 8601 end datetime>",
  // ... other VEVENT properties of the created event
}
```

**Example Request (curl):**
```bash
curl -X POST "http://localhost:8000/calendar/events" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{
    "summary": "Doctor Appointment",
    "dtstart": "2023-12-05T10:30:00Z",
    "dtend": "2023-12-05T11:00:00Z",
    "calendar_path": "myuser/personal.ics"
  }'
```

**Example Response (JSON):**
```json
{
  "uid": "new-event-uid-67890",
  "summary": "Doctor Appointment",
  "dtstart": "2023-12-05T10:30:00Z",
  "dtend": "2023-12-05T11:00:00Z"
  // Potentially more fields depending on caldav library's event object structure
}
```

## Health Check Endpoint

### GET /health

**Description:** Health check endpoint. Standard health check to verify service availability.

**Required Headers:**
- None

**Path Parameters:**
- None

**Query Parameters:**
- None

**Request Body:**
- None

**Response Body:** (`200 OK`)
```json
{
  "status": "<str: Health status of the service>"
}
```

**Example Request (curl):**
```bash
curl -X GET "http://localhost:8000/health"
```

**Example Response (JSON):**
```json
{
  "status": "healthy"
}
```
