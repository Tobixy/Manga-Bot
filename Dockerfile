# Use a specific version of Python for better reproducibility (e.g., python:3.9-slim)
FROM python:3.9-slim

# Set environment variables to optimize Python behavior in Docker
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory
WORKDIR /app

# Upgrade pip and install essential build dependencies
RUN python -m pip install --no-cache-dir --upgrade pip setuptools wheel \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libjpeg-dev \
       zlib1g-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN python -m pip install --no-cache-dir --prefer-binary -r requirements.txt

# Copy the application code
COPY . /app

# Run alembic migrations (optional)
RUN alembic upgrade head

# Set the default command
CMD ["bash", "start.sh"]
