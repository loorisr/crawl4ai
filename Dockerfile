# Other build arguments
ARG PYTHON_VERSION=3.13

# Base stage with system dependencies
FROM python:${PYTHON_VERSION}-slim AS base

# Environment setup
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    DEBIAN_FRONTEND=noninteractive


# Install Playwright dependencies. Uses less space than playwright install --with-deps chromium
RUN apt-get update && apt-get install -y --no-install-recommends \
    libglib2.0-0 \
    libnss3 \
    libnspr4 \
    libatk1.0-0 \
    libatk-bridge2.0-0 \
    libcups2 \
    libdrm2 \
    libdbus-1-3 \
    libxcb1 \
    libxkbcommon0 \
    libx11-6 \
    libxcomposite1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxrandr2 \
    libgbm1 \
    libpango-1.0-0 \
    libcairo2 \
    libasound2 \
    libatspi2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Create and set working directory
WORKDIR /app

# Copy the entire project
COPY . .

# Install base requirements
RUN pip install --no-cache-dir -r requirements.txt

# Install required library for FastAPI
RUN pip install fastapi uvicorn psutil

# Install the package
RUN pip install "." 

# Install Playwright and chrome
RUN playwright install chromium 

# Expose port
EXPOSE 11235

# Start the FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "11235"]