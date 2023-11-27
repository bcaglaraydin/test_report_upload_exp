FROM python:3.11-slim

# Install AWS CLI
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    awscli \
    && rm -rf /var/lib/apt/lists/*

# Install junit2html
RUN pip install junit2html

# Set the working directory to /app
WORKDIR /app

# Copy the script into the container
COPY convert_and_push.sh /app/

RUN chmod +x convert_and_push.sh
