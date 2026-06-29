# WestSide Smart Property Management System

Enterprise-grade intelligent property and home management platform.

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

## Installation

1. Create the database:
   ```bash
   mysql -u root -p < database/schema.sql
   ```

2. Configure environment:
   ```bash
   cp config/.env.example config/.env
   ```

3. Set permissions:
   ```bash
   chmod 755 uploads/ logs/
   ```

## Security Features

- PDO with prepared statements
- SQL injection prevention
- XSS protection
- CSRF token validation
- Password hashing (bcrypt)
- Rate limiting
- Session regeneration
- JWT authentication
- Audit logging

## Features

- Multi-role authentication
- Role-based access control
- Property & asset management
- Task scheduling & assignment
- GPS verification & location tracking
- Live worker tracking
- Task timer & duration tracking
- Chat & notifications
- Analytics & reporting
- Mobile-first PWA

## Documentation

- [API Documentation](docs/API.md)
- [Database Schema](database/schema.sql)
- [Architecture Guide](docs/ARCHITECTURE.md)

## License

Proprietary - WestSide
