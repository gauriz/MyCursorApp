# MyCursorApp

A modern calendar application with user authentication, event management, and a responsive UI built with Vue.js, Node.js, and MySQL.

![MyCursorApp](https://via.placeholder.com/800x400?text=MyCursorApp+Calendar)

## Features

- **User Authentication**
  - Secure signup and login
  - Password hashing with bcrypt
  - JWT-based authentication
  
- **Calendar Interface**
  - Interactive monthly/weekly/daily views
  - Drag-and-drop event scheduling
  - Event categorization with color coding
  
- **Event Management**
  - Create, edit, and delete events
  - Event reminders and notifications
  - Recurring events support
  
- **Responsive Design**
  - Mobile-first approach
  - Optimized for desktop, tablet, and phone
  - Smooth transitions and animations

## Tech Stack

### Frontend
- **Vue.js** - Progressive JavaScript framework
- **Vue Router** - Client-side routing
- **Axios** - HTTP client for API requests
- **CSS Custom Properties** - For theming and styling

### Backend
- **Node.js** - JavaScript runtime
- **Express** - Web framework
- **Passport.js** - Authentication middleware
- **JWT** - JSON Web Tokens for secure auth

### Database
- **MySQL** - Relational database
- **Sequelize** - ORM for database interactions

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration
- **Nginx** - Web server for static content delivery

## Architecture

The application is structured as a modern three-tier application:

```
┌───────────────┐     ┌───────────────┐     ┌───────────────┐
│   Frontend    │     │    Backend    │     │   Database    │
│   (Vue.js)    │────▶│   (Node.js)   │────▶│    (MySQL)    │
│               │◀────│               │◀────│               │
└───────────────┘     └───────────────┘     └───────────────┘
```

## Setup and Installation

### Prerequisites
- Docker and Docker Compose
- Node.js and npm (for local development)
- Git

### Quick Start with Docker
```bash
# Clone the repository
git clone https://github.com/gauriz/MyCursorApp.git
cd MyCursorApp

# Start all services
docker-compose up -d
```

The application will be available at:
- Frontend: http://localhost:8080
- Backend API: http://localhost:3000

### Local Development Setup
```bash
# Install frontend dependencies
cd calendar-app
npm install

# Start development server
npm run dev

# In a separate terminal, start the backend
cd server
npm install
npm run dev
```

## API Documentation

### Authentication
- **POST /api/auth/signup** - Register a new user
  - Body: `{ username, password, firstName, lastName, dateOfBirth }`
  
- **POST /api/auth/login** - Authenticate a user
  - Body: `{ username, password }`
  - Returns: JWT token

### Events API
- **GET /api/events** - List all events
- **POST /api/events** - Create a new event
- **GET /api/events/:id** - Get event details
- **PUT /api/events/:id** - Update an event
- **DELETE /api/events/:id** - Delete an event

## Configuration

The application can be configured using environment variables:

- `PORT` - Backend server port (default: 3000)
- `DB_HOST` - MySQL database host
- `DB_USER` - MySQL database user
- `DB_PASSWORD` - MySQL database password
- `DB_NAME` - MySQL database name
- `JWT_SECRET` - Secret for JWT token generation

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgements

- Icons provided by [FontAwesome](https://fontawesome.com/)
- UI inspiration from Google Calendar
- README template based on [Best-README-Template](https://github.com/othneildrew/Best-README-Template)