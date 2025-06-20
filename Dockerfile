# Stage 1: Builder
FROM python:3.11-slim AS builder

WORKDIR /app

# Cài thư viện hệ thống cần thiết cho build
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
  && rm -rf /var/lib/apt/lists/*

# Copy requirement và cài Python packages
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Stage 2: Final image
FROM python:3.11-slim

WORKDIR /app

# Cài lib runtime cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    libgl1 \
    libglib2.0-0 \
  && rm -rf /var/lib/apt/lists/*

# Copy Python environment từ builder
COPY --from=builder /usr/local /usr/local

# Copy source code
COPY . .

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set permissions (nếu không dùng root)
RUN mkdir -p /app/images && chmod -R 755 /app/images

# Optional: Add non-root user (best practice)
RUN adduser --disabled-password --gecos '' appuser && chown -R appuser /app
USER appuser

# Port: sửa EXPOSE để trùng với Gunicorn
EXPOSE 5000

# Start application
CMD ["gunicorn", "main:app", "--bind", "0.0.0.0:5000", "--log-level", "info"]
