FROM python:3.10-slim

WORKDIR /app

RUN apt update && apt install -y ffmpeg git curl bash gcc g++ python3-dev libffi-dev

COPY requirements.txt .

RUN pip install --upgrade pip wheel && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD sh -c "flask run -h 0.0.0.0 -p 5000 & python3 main.py"
