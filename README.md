# Highlight Application Stack

> 🚧 **Work in Progress** 🚧  
> This configuration is currently under development and **is not yet working**. Please check back later for updates.
>
> 🏗️ **ARM64 Deployment Target** 🏗️  
> This setup is specifically designed for ARM64 architecture deployment environments. Once the service is stable and working on ARM64, we plan to migrate and add support for AMD64 architecture.
>
> 🤝 **Open to Collaboration** 🤝  
> This project welcomes contributions! Feel free to submit pull requests, report issues, or suggest improvements.

This repository contains a Docker Compose configuration for running the Highlight application stack, which includes a full observability and monitoring platform with OpenTelemetry collection, error tracking, and performance monitoring capabilities.

## Overview

Highlight is an open-source observability platform that provides:

- Full OpenTelemetry (OTEL) support for traces, metrics, and logs
- Error tracking and monitoring
- Performance monitoring and metrics
- Real-time debugging capabilities
- Multiple log ingestion protocols (Fluent Forward, Syslog, AWS Firehose)

## Architecture

The stack consists of the following services:

### Core Services

- **highlight-frontend**: React-based web interface (port 3000)
- **highlight-backend**: Backend API service (port 8082)
- **highlight-collector**: OpenTelemetry Collector for ingesting observability data

### Infrastructure Services

- **postgres**: PostgreSQL database with pgvector extension (ankane/pgvector:v0.5.1)
- **clickhouse**: ClickHouse database for analytics and time-series data (clickhouse-server:24.12-alpine)
- **kafka**: Apache Kafka for message streaming (confluentinc/cp-kafka:7.7.0)
- **zookeeper**: Apache Zookeeper for Kafka coordination (confluentinc/cp-zookeeper:7.7.0)
- **redis**: Redis for caching and session storage (redis:7-alpine)

## Prerequisites

- Docker and Docker Compose installed
- At least 4GB of available RAM
- The following environment variables configured in your deployment platform (e.g., Coolify):
  - `SERVICE_FQDN_BACKEND`: Backend API domain
  - `SERVICE_FQDN_FRONTEND`: Frontend domain
  - `ADMIN_PASSWORD` (optional, defaults to "highlightadmin")
  - `ENVIRONMENT` (optional, defaults to "dev")
  - `AUTH_MODE` (optional, defaults to "Simple")

## Quick Start (Coolify Deployment)

1. **Create a new service in Coolify:**

   - In your Coolify dashboard, create a new "Docker Compose" service
   - Copy the contents of `docker-compose.yml` from this repository into the empty Docker Compose configuration

2. **Configure required environment variables in Coolify:**

   - `SERVICE_FQDN_FRONTEND`: Your frontend domain (e.g., `highlight.yourdomain.com`)
   - `SERVICE_FQDN_BACKEND`: Your backend API domain (e.g., `highlight-api.yourdomain.com`)
   - `ADMIN_PASSWORD`: Admin password (optional, defaults to "highlightadmin")
   - `ENVIRONMENT`: Environment name (optional, defaults to "dev")
   - `AUTH_MODE`: Authentication mode (optional, defaults to "Simple")

   Coolify will automatically create volumes for persistent data storage

3. **Deploy the stack:**

   - Click "Deploy" in Coolify to start all services
   - Wait for all health checks to pass (especially PostgreSQL)

4. **Access the application:**
   - Frontend: Your configured frontend FQDN
   - Backend API: Your configured backend FQDN

## Configuration

### Environment Variables

The stack includes the following key environment configurations:

- **Database Configuration:**
  - PostgreSQL: `postgres:5432` with pgvector extension
  - ClickHouse: `clickhouse:9000` for time-series data
- **Message Queue:**
  - Kafka: `kafka:9092` with Zookeeper coordination
- **Cache:**
  - Redis: `redis:6379` with persistence enabled
- **OpenTelemetry Collection:**
  - OTLP endpoints for traces, metrics, and logs
  - Multiple ingestion protocols supported

### Default Credentials

- **PostgreSQL:**

  - Username: `postgres`
  - Password: `postgres`
  - Database: `postgres`

- **Admin Access:**
  - Default admin password: `highlightadmin` (configurable via `ADMIN_PASSWORD`)

## Health Checks

The stack includes comprehensive health checks for:

- **PostgreSQL**: Database readiness check with pg_isready
- **ClickHouse**: HTTP ping endpoint check
- **Kafka**: Broker API version check
- **Redis**: Redis CLI ping check
- **Backend**: HTTP health endpoint check
- **Frontend**: HTTP root endpoint check

All services have proper dependency management to ensure correct startup order

## Volumes

The following volumes are used for persistent data:

- `postgres-data`: PostgreSQL data
- `clickhouse-data`: ClickHouse data
- `clickhouse-logs`: ClickHouse logs
- `kafka-data`: Kafka data
- `zookeeper-data`: Zookeeper data
- `zookeeper-log`: Zookeeper logs
- `redis-data`: Redis data
- `highlight-data`: Highlight application data

## Networking

All services communicate through a custom bridge network named `highlight`.

## Monitoring and Observability

Once running, you can:

1. Access the Highlight dashboard through the frontend URL
2. Configure your applications to send telemetry data via:
   - OpenTelemetry Protocol (OTLP) on ports 4317 (gRPC) and 4318 (HTTP)
   - Fluent Forward protocol on port 24224
   - Syslog (RFC5424) on ports 6513 (UDP) and 6514 (TCP)
   - AWS Firehose for CloudWatch metrics (port 4433) and logs (port 8433)
   - TCP log ingestion on port 34302
3. Monitor application performance, errors, and logs
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
   - Ensure all health checks are passing

4. **OpenTelemetry data not appearing:**
   - Verify the collector service is running
   - Check that your application is configured to send data to the correct OTLP endpoints
   - Review collector logs for any ingestion errors

### Logs

**In Coolify:**

- View logs for individual services through the Coolify dashboard
- Use the "Logs" tab for each service to monitor real-time output

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
