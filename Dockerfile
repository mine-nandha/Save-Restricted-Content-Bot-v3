# Stage 1: Build
FROM python:3.10-alpine as builder

WORKDIR /install

# Install build dependencies
RUN apk add --no-cache build-base gcc musl-dev libffi-dev ffmpeg git curl bash neofetch

COPY requirements.txt .

RUN pip install --upgrade pip && \
    pip wheel --no-cache-dir --wheel-dir /install/wheels -r requirements.txt

---

# Stage 2: Runtime
FROM python:3.10-alpine

# Install runtime deps only
RUN apk add --no-cache ffmpeg git curl bash neofetch

WORKDIR /app

COPY --from=builder /install/wheels /wheels
COPY --from=builder /install/requirements.txt .
RUN pip install --no-cache-dir --no-index --find-links=/wheels -r requirements.txt

COPY . .

EXPOSE 5000

CMD sh -c "flask run -h 0.0.0.0 -p 5000 & python3 main.py"
