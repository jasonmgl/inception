# Inception

## Overview

**Inception** is a system administration project from the 42 curriculum focused on **containerization and service orchestration using Docker**.

The objective is to build a complete and secure infrastructure composed of multiple services running in isolated containers and orchestrated with **Docker Compose**.

---

## Objectives

- Understand Docker fundamentals
- Build and manage custom Docker images
- Orchestrate multi-container applications
- Configure a secure web infrastructure
- Work with networking, volumes, and services isolation

---

## Architecture
```
                ┌───────────────┐
                │    NGINX      │
                │ (Reverse Proxy)
                └──────┬────────┘
                       │ HTTPS (TLS)
                       ▼
        ┌──────────────────────────────┐
        │          WORDPRESS           │
        │     (PHP-FPM Application)    │
        └───────────┬──────────────────┘
                    │
                    ▼
             ┌──────────────┐
             │   MARIADB    │
             │   (Database) │
             └──────────────┘
```
    Additional Services:
    - Redis (cache)
    - FTP Server (vsftpd)
    - phpMyAdmin (DB management)
    - Fail2Ban (security)

---

## Services

### NGINX
- Reverse proxy
- HTTPS (TLS/SSL)
- Handles incoming traffic

### WordPress
- PHP-FPM application
- Connected to MariaDB
- Uses Redis for caching

### MariaDB
- Database service
- Stores WordPress data

### Redis
- Improves performance with caching

### vsftpd
- FTP server for file transfer

### phpMyAdmin
- Web interface to manage the database

### Fail2Ban
- Protects services from brute-force attacks

---

## Docker Implementation

### Custom Images
Each service is built from a custom **Dockerfile**:
- No pre-built images (except base images)
- Secure and minimal configurations

### Docker Compose

The infrastructure is orchestrated using:
```
docker-compose up -d
```
Responsibilities:
- Service orchestration
- Network management
- Volume persistence

---

## Project Structure
```
.
├── srcs/
│   ├── requirements/
│   │   ├── nginx/
│   │   ├── wordpress/
│   │   ├── mariadb/
│   │   ├── redis/
│   │   ├── vsftpd/
│   │   ├── phpmyadmin/
│   │   └── fail2ban/
│   ├── docker-compose.yml
│   └── .env
```
---

## Security

- HTTPS enforced (TLS)
- Environment variables for sensitive data
- Fail2Ban protection
- Isolated containers

---

## Volumes

- Database persistence (MariaDB)
- WordPress files persistence

---

## Networking

- Custom Docker network
- Internal communication between services
- External access via NGINX

---

## How to Run
```
make
```
or
```
docker-compose up -d --build
```
