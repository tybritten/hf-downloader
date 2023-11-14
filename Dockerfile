FROM python:3.10.4

RUN pip install huggingface-hub

WORKDIR /app

COPY dataset-downloader.py /app

