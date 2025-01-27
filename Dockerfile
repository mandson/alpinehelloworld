# Grab the latest alpine image
FROM alpine:latest

# Install python, pip, bash, and necessary build tools
RUN apk add --no-cache --update python3 py3-pip bash build-base libffi-dev

# Create a non-root user before switching
RUN adduser -D myuser

# Set up a virtual environment
RUN python3 -m venv /venv

# Ensure the virtual environment is used by default
ENV PATH="/venv/bin:$PATH"

# Copy requirements and install dependencies inside the virtual environment
ADD ./webapp/requirements.txt /tmp/requirements.txt
RUN pip install --no-cache-dir -r /tmp/requirements.txt

# Copy the application code
ADD ./webapp /opt/webapp/
WORKDIR /opt/webapp

# Switch to non-root user
USER myuser

# Command to run the app
CMD gunicorn --bind 0.0.0.0:${PORT:-5000} wsgi
