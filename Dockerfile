FROM python:3.6-slim
LABEL maintainer="dream.paths.projekt@gmail.com"

ENV PYTHONUNBUFFERED=1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

RUN pip install -U setuptools
COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .