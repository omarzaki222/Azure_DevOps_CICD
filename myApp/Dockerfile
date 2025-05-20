FROM python:3.10-alpine

ENV PYTHONUNBUFFERED 1

RUN apk update && apk add --no-cache apache2 apache2-utils apache2-dev python3-dev py3-pip libffi-dev gcc musl-dev 
RUN pip install --upgrade pip setuptools

RUN pip install mod_wsgi

WORKDIR /var/www/html

COPY . /var/www/html

COPY apache/httpd.conf /usr/local/apache2/conf/httpd.conf

EXPOSE 80

CMD ["httpd", "-D", "FOREGROUND"]
