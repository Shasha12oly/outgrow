# Dockerfile for OUTGROW on Fly.io
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy application files
COPY . /app/

# Create data directory for SQLite
RUN mkdir -p /data

# Set environment variables
ENV PORT=8765
ENV OUTGROW_BIND=0.0.0.0
ENV OUTGROW_DATA_DIR=/data
ENV PYTHONUNBUFFERED=1

# Expose port
EXPOSE 8765

# Run the server
CMD ["python3", "server.py"]
