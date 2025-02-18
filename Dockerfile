# Other build arguments
ARG PYTHON_VERSION=3.13

# Base stage with system dependencies
FROM python:${PYTHON_VERSION}-slim as base

# Environment setup
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_DEFAULT_TIMEOUT=100 \
    DEBIAN_FRONTEND=noninteractive

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

# Install Playwright and browsers
RUN playwright install --with-deps chromium 

# Expose port
EXPOSE 11235

# Start the FastAPI server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "11235"]
