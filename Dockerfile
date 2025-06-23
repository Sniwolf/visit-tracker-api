FROM python:3.11-slim

WORKDIR /app

# Install system packages and Rust for Pydantic v2
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libffi-dev \
    libssl-dev \
    curl \
    && curl https://sh.rustup.rs -sSf | sh -s -- -y \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

# Add Rust to PATH for this layer
ENV PATH="/root/.cargo/bin:$PATH"

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]