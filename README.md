# WestSide Smart Property Management System

Enterprise-grade intelligent property and home management platform built with modern technologies.

## Project Status

**Phase 1: Foundation** - In Progress

## Tech Stack

- **Frontend**: HTML5, CSS3, Vanilla JavaScript (ES2024)
- **Backend**: PHP 8.3+
- **Database**: MySQL 8.0+
- **APIs**: RESTful JSON, Google Maps, WebSockets
- **Mobile**: PWA, Responsive Design
- **Security**: PDO, Prepared Statements, JWT, CSRF Protection

## Project Structure

```
├── config/           # Configuration files
├── database/         # Schema and migrations
├── helpers/          # Reusable utilities
├── models/           # Data layer
├── controllers/      # Business logic
├── api/              # REST API endpoints
├── views/            # HTML templates
├── components/       # UI components
├── assets/
│   ├── css/
│   ├── js/
│   └── images/
├── uploads/          # User uploads
├── logs/             # Application logs
├── auth/             # Authentication
├── mobile/           # PWA support
└── admin/            # Admin dashboard
```

## Features

- Multi-role authentication (7 account types)
- Role-based access control with custom permissions
- Property & asset management
- Task scheduling & assignment
- GPS verification & location tracking
- Live worker tracking on maps
- Task timer & duration tracking
- Chat & real-time notifications
- Analytics & reporting
- Mobile-first PWA
- Dark/Light mode
- Responsive design

## Installation

1. Clone the repository
2. Create the database:
   ```bash
   mysql -u root -p < database/schema.sql
   ```
3. Configure environment:
   ```bash
   cp config/.env.example config/.env
   ```
4. Set permissions:
   ```bash
   chmod 755 uploads/ logs/
   ```

## Security

- PDO with prepared statements
- SQL injection prevention
- XSS protection
- CSRF token validation
- Password hashing (bcrypt)
- Rate limiting
- Session regeneration
- JWT authentication
- Audit logging

## License

Proprietary - WestSide