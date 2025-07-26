# Highlight.io Full Stack - Using Official Highlight Repository
FROM docker:27-dind

# Install dependencies
RUN apk add --no-cache \
    docker-compose \
    bash \
    curl \
    git \
    openssl \
    envsubst \
    go \
    nodejs \
    npm

# Create highlight directory and clone repository
WORKDIR /highlight
RUN git clone https://github.com/highlight/highlight.git . && \
    git checkout main

# Set working directory to docker folder where scripts are located
WORKDIR /highlight/docker

# Create telemetry file to skip interactive prompt
RUN touch .telemetry

# Set default environment variables for hobby mode
ENV ADMIN_PASSWORD=admin123 \
    IN_DOCKER=true \
    IN_DOCKER_GO=true \
    ON_PREM=true \
    SSL=false \
    REACT_APP_AUTH_MODE=password \
    AUTH_MODE=password \
    ENVIRONMENT=hobby \
    DEMO_PROJECT_ID=1 \
    DEFAULT_PROJECT_ID=1 \
    DEFAULT_WORKSPACE_ID=1 \
    SEED_ADMIN_EMAIL=admin@highlight.io \
    SEED_ADMIN_PASSWORD=admin123 \
    BACKEND_IMAGE_NAME=ghcr.io/highlight/highlight-backend:docker-v0.5.5 \
    FRONTEND_IMAGE_NAME=ghcr.io/highlight/highlight-frontend:docker-v0.5.5 \
    OTLP_DOGFOOD_ENDPOINT=http://localhost:4318 \
    OTLP_ENDPOINT=http://localhost:4318

# Create startup script that uses official Highlight scripts
RUN cat > start-highlight.sh << 'EOF' && chmod +x start-highlight.sh
#!/bin/bash
set -e

echo "================================================"
echo "       🚀 Highlight.io Full Stack (Official)   "
echo "================================================"
echo ""

# Start Docker daemon if not running
if ! docker info >/dev/null 2>&1; then
    echo "Starting Docker daemon..."
    dockerd --host=unix:///var/run/docker.sock &
    
    # Wait for Docker to be ready
    echo "Waiting for Docker daemon..."
    for i in {1..30}; do
        if docker info >/dev/null 2>&1; then
            echo "✅ Docker daemon is ready"
            break
        fi
        echo "⏳ Waiting for Docker... ($i/30)"
        sleep 2
    done
    
    if ! docker info >/dev/null 2>&1; then
        echo "❌ Failed to start Docker daemon"
        exit 1
    fi
fi

# Set up environment
source env.sh --go-docker

echo "🔧 Configuration:"
echo "   Admin Email: ${SEED_ADMIN_EMAIL}"
echo "   Admin Password: ${ADMIN_PASSWORD}"
echo "   Frontend URI: ${REACT_APP_FRONTEND_URI}"
echo "   Backend URI: ${REACT_APP_PUBLIC_GRAPH_URI}"
echo ""

# Start infrastructure using official script
echo "🏗️  Starting infrastructure services..."
if ./start-infra.sh --go-docker; then
    echo "✅ Infrastructure services started successfully"
else
    echo "❌ Failed to start infrastructure services"
    echo "📋 Container status:"
    docker ps -a
    exit 1
fi

# Start Highlight backend and frontend
echo "🚀 Starting Highlight application services..."
if docker compose -f compose.hobby.yml up --detach backend frontend; then
    echo "✅ Highlight application services started"
else
    echo "❌ Failed to start Highlight application services"
    echo "📋 Container status:"
    docker ps -a
    docker compose -f compose.hobby.yml logs
    exit 1
fi

# Wait for services to be ready
echo "⏳ Waiting for services to be ready..."
sleep 30

echo ""
echo "================================================"
echo "    🎉 Highlight.io is now running!            "
echo "================================================"
echo ""
echo "🌐 Access Points:"
echo "   Frontend:  ${REACT_APP_FRONTEND_URI:-http://localhost:3000}"
echo "   Backend:   ${REACT_APP_PUBLIC_GRAPH_URI:-http://localhost:8082/public}"
echo "   Health:    http://localhost:8082/health"
echo ""
echo "🔑 Login Credentials:"
echo "   Email:     ${SEED_ADMIN_EMAIL}"
echo "   Password:  ${ADMIN_PASSWORD}"
echo ""
echo "📊 Service Status:"
docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"
echo ""
echo "📋 View logs with: docker compose -f compose.hobby.yml logs -f [service]"
echo "🔧 Available services: backend, frontend"
echo "📋 View infrastructure logs with: docker compose logs -f [service]"
echo "🔧 Infrastructure services: clickhouse, kafka, postgres, redis, zookeeper, collector"
echo ""

# Follow logs from Highlight services
echo "Following application logs (press Ctrl+C to stop):"
docker compose -f compose.hobby.yml logs -f --tail=50
EOF

# Expose ports for frontend and backend
EXPOSE 3000 8082 4317 4318

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=180s --retries=5 \
    CMD curl -f http://localhost:3000 && curl -f http://localhost:8082/health || exit 1

# Set proper permissions and start
ENTRYPOINT ["./start-highlight.sh"]