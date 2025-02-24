# Inception

This project focuses on setting up a multi-container Docker environment using Docker Compose. The goal is to understand how to orchestrate multiple services and manage their configurations effectively.
Features

- Multi-Container Setup: Learn to configure and manage multiple Docker containers.
- Service Orchestration: Understand how to link services together using Docker Compose.
- Configuration Management: Manage environment variables and configurations for different services.

## Getting Started

### Usage:

Clone the Repository:

```bash
git clone https://github.com/jasonmgl/inception.git
cd inception
```
(Optionnal) If you want to launch bonus parts (more features):
```bash
cd bonus
```
Build the Containers:
```bash
make
```
Start the Containers:
```bash
make up
```
Stopping the Containers:
```bash
make down
```
Cleaning Up:
```bash
make clean
```


Access the Services:
- Service 1: http://localhost:8080
- Service 2: http://localhost:8081 (Bonus only)


### Prerequisites
- Docker
- Docker Compose

Ensure both are installed and running on your system.

### Project Structure
```
inception/
├── srcs/
│   ├── service1/
│   ├── service2/
│   └── ...
├── bonus/
├── Makefile
└── docker-compose.yml
```
- srcs/: Contains the source files for the services.
- bonus/: Additional features or services.
- Makefile: Automates the setup and management of the Docker environment.
- docker-compose.yml: Defines the Docker services, networks, and volumes.
