FROM tiangolo/uwsgi-nginx-flask:python3.6

# Customize uWSGI webserver port
ENV LISTEN_PORT 8080
EXPOSE 8080

# Copy App and Install requirements
COPY ./app /app
RUN pip3 install -r /app/requirements.txt

# Customize Postgres Connection
#ENV DB_HOST 127.0.0.1
#ENV DB_USER postgres
#ENV DB_PASS password
#ENV DB_NAME memegen
