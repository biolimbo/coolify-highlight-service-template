# Highlight Application Stack

> 🚧 **Work in Progress** 🚧  
> This configuration is currently under development and **is not yet working**. Please check back later for updates.
>
> 🏗️ **ARM64 Deployment Target** 🏗️  
> This setup is specifically designed for ARM64 architecture deployment environments. Once the service is stable and working on ARM64, we plan to migrate and add support for AMD64 architecture.
>
> 🤝 **Open to Collaboration** 🤝  
> This project welcomes contributions! Feel free to submit pull requests, report issues, or suggest improvements.

This repository contains a Docker Compose configuration for running the Highlight application stack, which includes a full observability and monitoring platform with session replay, error tracking, and performance monitoring capabilities.

## Overview

Highlight is an open-source observability platform that provides:

- Session replay and user analytics
- Error tracking and monitoring
- Performance monitoring and metrics
- Real-time debugging capabilities

## Architecture

The stack consists of the following services:

### Core Services

- **highlight-frontend**: React-based web interface (port 3000)
- **highlight-backend**: Backend API service (port 8082)

### Infrastructure Services

- **postgres**: PostgreSQL database with pgvector extension for vector operations
- **clickhouse**: ClickHouse database for analytics and time-series data
- **kafka**: Apache Kafka for message streaming
- **zookeeper**: Apache Zookeeper for Kafka coordination
- **redis**: Redis for caching and session storage

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB of available RAM
- The following environment variables configured in your deployment platform (e.g., Coolify):
  - `COOLIFY_VOLUME_POSTGRES`
  - `COOLIFY_VOLUME_CLICKHOUSE`
  - `COOLIFY_VOLUME_KAFKA`
  - `COOLIFY_VOLUME_REDIS`
  - `COOLIFY_VOLUME_HIGHLIGHT_DATA`
  - `SERVICE_FQDN_BACKEND`
  - `SERVICE_FQDN_FRONTEND`
  - `ADMIN_PASSWORD` (optional, defaults to "highlightadmin")

## Quick Start

1. **Clone this repository:**

   ```bash
   git clone <repository-url>
   cd <repository-name>
   ```

2. **Set up environment variables:**
   Make sure all required volume and service FQDN variables are configured in your deployment environment.

3. **Start the stack:**

   ```bash
   docker-compose -f template.yml up -d
   ```

4. **Access the application:**
   - Frontend: `https://${SERVICE_FQDN_FRONTEND}`
   - Backend API: `https://${SERVICE_FQDN_BACKEND}`

## Configuration

### Environment Variables

The stack uses a shared environment configuration (`x-highlight-env`) that includes:

- **Database Configuration:**
  - PostgreSQL: `postgres:5432`
  - ClickHouse: `clickhouse:9000`
- **Message Queue:**
  - Kafka: `kafka:9092`
- **Cache:**
  - Redis: `redis:6379`

### Default Credentials

- **PostgreSQL:**

  - Username: `postgres`
  - Password: `postgres`
  - Database: `postgres`

- **Admin Access:**
  - Default admin password: `highlightadmin` (configurable via `ADMIN_PASSWORD`)

## Health Checks

The stack includes health checks for:

- PostgreSQL: Ensures database is ready before starting dependent services
- All other services have dependency management to ensure proper startup order

## Volumes

The following volumes are used for persistent data:

- `${COOLIFY_VOLUME_POSTGRES}`: PostgreSQL data
- `${COOLIFY_VOLUME_CLICKHOUSE}`: ClickHouse data
- `${COOLIFY_VOLUME_KAFKA}`: Kafka data
- `${COOLIFY_VOLUME_REDIS}`: Redis data
- `${COOLIFY_VOLUME_HIGHLIGHT_DATA}`: Highlight application data

## Networking

All services communicate through a custom bridge network named `highlight`.

## Monitoring and Observability

Once running, you can:

1. Access the Highlight dashboard through the frontend URL
2. Configure your applications to send data to the backend API
3. Monitor application performance, errors, and user sessions
4. Set up alerts and notifications

## Troubleshooting

### Common Issues

1. **Services not starting:**

   - Check that all environment variables are properly set
   - Ensure Docker has sufficient resources allocated
   - Verify volume paths are accessible

2. **Database connection issues:**

   - Wait for PostgreSQL health check to pass
   - Check network connectivity between services

3. **Frontend not loading:**
   - Verify backend service is running and healthy
   - Check that FQDN variables are correctly configured

### Logs

View logs for specific services:

```bash
docker-compose -f template.yml logs [service-name]
```

View logs for all services:

```bash
docker-compose -f template.yml logs
```

## Development

For development purposes, you can:

1. Override environment variables in a `.env` file
2. Mount local code volumes for the frontend/backend services
3. Use development-specific image tags

## Contributing

We welcome contributions to this project! Here's how you can help:

### Collaboration Process

1. **Fork the repository** and create your feature branch from `main`
2. **Create a feature branch** with a descriptive name (e.g., `feature/fix-clickhouse-startup`)
3. **Make your changes** following the existing code style and conventions
4. **Test your changes** thoroughly with the Docker Compose stack
5. **Document your changes** in the commit messages and update relevant documentation
6. **Submit a pull request** with a clear description of what you've changed and why

### What We're Looking For

- 🐛 **Bug fixes** - Help us identify and resolve issues
- 📚 **Documentation improvements** - Better explanations, examples, or corrections
- ⚡ **Performance optimizations** - Make the stack run more efficiently
- 🔧 **Configuration improvements** - Better default settings or new options
- 🏗️ **Architecture enhancements** - Improvements to the overall setup
- 📦 **AMD64 support** - Help us prepare for multi-architecture deployment

### Pull Request Guidelines

- Keep PRs focused and atomic (one feature/fix per PR)
- Include clear commit messages explaining the changes
- Test your changes in both development and production-like environments
- Update documentation if your changes affect user-facing functionality
- Be responsive to feedback and ready to make adjustments

### Getting Started

If you're new to the project, check out the [Issues](../../issues) page for good first issues or areas where help is needed.

## License

This project follows the licensing terms of the Highlight application. Please refer to the official Highlight repository for license details.

## Support

For issues related to:

- **Highlight application**: Visit the [official Highlight repository](https://github.com/highlight/highlight)
- **This Docker setup**: Create an issue in this repository
- **Deployment questions**: Check the Coolify or your deployment platform documentation
