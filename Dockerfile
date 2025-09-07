# Python 3.13 như bạn đang dùng
FROM python:3.13-slim

# Cần tool build (tiktoken/1 số lib có thể build), curl để healthcheck
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential cargo curl ca-certificates \
  && rm -rf /var/lib/apt/lists/*

ENV PYTHONUNBUFFERED=1 PIP_NO_CACHE_DIR=1
WORKDIR /app

# Cài deps trước (tận dụng cache layer)
COPY requirements.txt .
RUN python -m pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# Copy source vào image
COPY . .

# Gunicorn sẽ lắng nghe 8000 trong container
EXPOSE 8000

# app.py có biến app = Flask(__name__)
CMD ["gunicorn", "-w", "2", "-k", "gthread", "-b", "0.0.0.0:8000", "app:app"]
