# pull official base image
FROM python:3.9.5-alpine

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install psycopg2 dependencies
RUN apk update \
    && apk add postgresql-dev gcc python3-dev musl-dev libffi-dev

# install dependencies
RUN pip install --upgrade cffi pip setuptools
COPY ./youtubefilter/requirements.txt .
RUN pip install -r requirements.txt

# copy entrypoint.sh
COPY ./youtubefilter/entrypoint.sh .
RUN sed -i 's/\r$//g' /usr/src/app/entrypoint.sh
RUN chmod +x /usr/src/app/entrypoint.sh

# copy project
COPY ./youtubefilter .

# run entrypoint.sh
ENTRYPOINT [ "sh", "/usr/src/app/entrypoint.sh" ]
