# TaskHub Developer Manual

## 1. Introduction

This manual is aimed at developers who wish to understand, contribute to, or extend the TaskHub platform. TaskHub is a project management platform built with a microservices architecture, designed to be scalable and modular. This document will cover the system architecture, development environment, code structure, how to contribute, and how to run tests.

## 2. System Architecture

TaskHub is based on a microservices architecture, where each main functionality is encapsulated in an independent service. Communication between services is done via RESTful APIs and, potentially, through a messaging system (like RabbitMQ, if implemented).

The main components of the architecture include:

*   **API Gateway:** Unified entry point for all client requests. It handles routing, authentication, and the implementation of resilience patterns (such as Circuit Breaker).
*   **Business Services (Microservices):**
    *   **Auth Service:** User authentication and authorization management (JWT, Supabase Auth).
    *   **Project Service:** Project, task, and activity tracking management.
    *   **Document Service:** Document storage, versioning, and permissions.
    *   **Notification Service:** Sending notifications through various channels.
    *   **External Tools Service:** Integration with external services (GitHub, Google Drive, etc.).

*   **Database:** Supabase (PostgreSQL) is used as the primary database, managing users and application data.
*   **Containers:** All services are packaged in Docker containers and orchestrated with Docker Compose to facilitate deployment and management.

### Implemented Design Patterns:

TaskHub utilizes several design patterns to ensure robustness, scalability, and maintainability:

*   **Singleton:** For database and Supabase connections.
*   **Factory Method:** For document creation.
*   **Command:** For task operations with undo/redo functionality.
*   **Observer:** For notification delivery.
*   **Adapter:** For external tool integrations.
*   **Decorator:** For adding functionality to documents.
*   **Facade:** Used in the API Gateway to simplify interaction with internal microservices.
*   **Circuit Breaker:** Implemented in the API Gateway to prevent cascading failures.

## 3. Development Environment and Dependencies

To set up your development environment for TaskHub, you will need the following:

### 3.1. System Requirements

*   **Python 3.13+:** The backend is developed in Python.
*   **Poetry:** Python dependency management and packaging tool.
*   **Docker and Docker Compose:** For running the microservices.
*   **Git:** For version control.
*   **Supabase Account:** For the database and authentication.

### 3.2. Initial Setup

1.  **Clone the Repository:**

    ```bash
    git clone https://github.com/ISCODEVUTB/TaskHub.git
    cd TaskHub
    ```

2.  **Install Poetry (if you don't have it):**

    ```bash
    curl -sSL https://install.python-poetry.org | python3 -
    ```

3.  **Install Backend Dependencies:**

    Navigate to the `backend` directory and install dependencies using Poetry:

    ```bash
    cd backend
    poetry install
    ```

4.  **`.env` File Configuration:**

    As mentioned in the user manual, the `.env` file is crucial for sensitive credentials. For development, this file should be located in `TaskHub/backend/.env`.

    If it doesn't exist, you can create a `.env.example` in `TaskHub/backend/` with the following content and then copy it to `.env`:

    ```ini
    # Supabase Credentials
    SUPABASE_URL="YOUR_SUPABASE_URL"
    SUPABASE_KEY="YOUR_SUPABASE_API_KEY"

    # Other relevant development configurations
    # DEBUG=True
    # LOG_LEVEL=DEBUG
    ```

    **Make sure to replace `"YOUR_SUPABASE_URL"` and `"YOUR_SUPABASE_API_KEY"` with your actual Supabase credentials.**

## 4. Code Structure and Microservices

The TaskHub project is organized into several directories, each representing a key component or microservice:

```
taskhub/
├── api/                     # Contains all backend microservices
│   ├── api-gateway/         # API Gateway service
│   │   ├── main.py
│   │   ├── middleware/
│   │   └── utils/
│   ├── auth-service/        # Authentication service
│   │   └── app/
│   │       ├── main.py
│   │       ├── schemas/
│   │       └── services/
│   ├── document-service/    # Document service
│   │   └── app/
│   │       ├── main.py
│   │       ├── decorators/
│   │       ├── factories/
│   │       ├── schemas/
│   │       └── services/
│   ├── external-tools-service/ # External tools service
│   │   └── app/
│   │       ├── main.py
│   │       ├── adapters/
│   │       ├── schemas/
│   │       └── services/
│   ├── notification-service/   # Notification service
│   │   └── app/
│   │       ├── main.py
│   │       ├── observers/
│   │       ├── schemas/
│   │       └── services/
│   ├── project-service/        # Project service
│   │   └── app/
│   │       ├── main.py
│   │       ├── commands/
│   │       ├── schemas/
│   │       └── services/
│   ├── shared/                 # Modules shared between services
│   │   ├── dtos/
│   │   ├── exceptions/
│   │   ├── models/
│   │   └── utils/
│   └── tests/                  # Unit and integration tests
├── .env.example             # Example environment variables file (in repo root)
├── docker-compose.yml       # Docker Compose configuration for all services
├── Dockerfile               # Base Dockerfile for the application
├── pyproject.toml           # Poetry configuration for the main project
└── README.md
```

### 4.1. Key Microservice Descriptions

*   **`api-gateway`:** Acts as the reverse proxy and orchestration point. Handles JWT authentication, routing to internal services, and applying patterns like Circuit Breaker.
*   **`auth-service`:** Manages user registration, login, JWT token generation and validation, and integration with Supabase Auth.
*   **`project-service`:** Contains the business logic for creating, managing, and tracking projects, tasks, and activities. Implements the Command pattern for undo/redo functionalities.
*   **`document-service`:** Handles document management, including storage, versioning, and permissions. Uses Factory Method and Decorator patterns.
*   **`notification-service`:** Responsible for sending notifications through different channels (email, SMS, etc.) using the Observer pattern.
*   **`external-tools-service`:** Provides integrations with external tools like GitHub or Google Drive, using the Adapter pattern.

### 4.2. Shared Modules (`shared/`)

The `shared/` directory contains common code used by multiple microservices to avoid duplication and ensure consistency:

*   **`dtos/`:** Data Transfer Objects (DTOs) for inter-service communication.
*   **`exceptions/`:** Custom exception classes.
*   **`models/`:** Shared database models (SQLAlchemy).
*   **`utils/`:** General utilities such as database configuration (`db.py`), JWT handling (`jwt.py`), RabbitMQ integration (`rabbitmq.py`), and Supabase (`supabase.py`).

## 5. Contribution and Testing

### 5.1. Contribution Workflow

It is recommended to follow the workflow below to contribute to the project:

1.  **Fork the Repository:** Create a fork of the `ISCODEVUTB/TaskHub` repository in your GitHub account.
2.  **Clone Your Fork:** Clone your fork locally.
3.  **Create a Branch:** Create a new branch for your changes (`git checkout -b feature/your-feature-name` or `bugfix/bug-description`).
4.  **Make Your Changes:** Implement your features or fixes.
5.  **Write Tests:** Make sure to write unit and/or integration tests for your changes.
6.  **Run Tests:** Run all tests to ensure you haven't introduced regressions.
7.  **Commit Your Changes:** Write clear and descriptive commit messages.
8.  **Push to Your Fork:** Push your changes to your forked repository on GitHub.
9.  **Create a Pull Request (PR):** Open a PR from your branch in your fork to the `main` branch of the original repository. Describe your changes in detail in the PR.

### 5.2. Running Tests

The project includes a `tests/` directory with tests for different services. To run the tests, make sure you have the dependencies installed (section 3.2) and then you can use `pytest`.

To run all tests:

```bash
cd backend
poetry run pytest
```

To run tests for a specific service (e.g., Auth Service):

```bash
cd backend
poetry run pytest api/auth-service/tests/
```

### 5.3. Coding Guidelines

*   Follow Python style conventions (PEP 8).
*   Use type hints to improve readability and error detection.
*   Write modular and reusable code.
*   Document your code with docstrings where appropriate.

## 6. Deployment (Optional)

While this manual focuses on local development, TaskHub is designed to be deployed to the cloud. You can refer to the original `README.md` of the repository for information on deploying to platforms like AWS, Azure, or Fly.io.

## 7. Contact and Support

For questions or support, you can open an `Issue` in the GitHub repository or contact the project maintainers.


