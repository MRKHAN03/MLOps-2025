# Dockerfile
FROM python:3.11-slim

# set working dir
WORKDIR /app

# install system deps (adjust if you need other libs)
RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential git && \
    rm -rf /var/lib/apt/lists/*

# copy deps first for caching
COPY requirements.txt .

# install python deps
RUN python -m pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# copy app code and model (unless you plan to mount model at runtime)
COPY . .

# ensure streamlit runs headless inside container
RUN mkdir -p /root/.streamlit && \
    echo "[server]" > /root/.streamlit/config.toml && \
    echo "headless = true" >> /root/.streamlit/config.toml && \
    echo "enableCORS = false" >> /root/.streamlit/config.toml && \
    echo "port = 8501" >> /root/.streamlit/config.toml 

EXPOSE 8501

# final command
CMD ["streamlit", "run", "app.py", "--server.port=8501", "--server.address=0.0.0.0"]
