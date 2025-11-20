# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Install system dependencies required for headless Chrome and jq
RUN apt-get update && apt-get install -y \
    wget \
    gnupg \
    unzip \
    jq \
    --no-install-recommends

# Install Google Chrome using the modern, secure method
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome-keyring.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome-keyring.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable

# Install ChromeDriver using the new, stable JSON endpoints
RUN CHROME_DRIVER_URL=$(wget -q -O - https://googlechromelabs.github.io/chrome-for-testing/last-known-good-versions-with-downloads.json | jq -r '.channels.Stable.downloads.chromedriver[] | select(.platform=="linux64") | .url') \
    && wget -q --continue -P /usr/local/bin "$CHROME_DRIVER_URL" \
    && unzip -o /usr/local/bin/chromedriver-linux64.zip -d /usr/local/bin \
    && rm /usr/local/bin/chromedriver-linux64.zip

# Copy the application code into the container
COPY . /app
WORKDIR /app

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set the entrypoint for the container
ENTRYPOINT ["python", "/app/entrypoint.py"]
