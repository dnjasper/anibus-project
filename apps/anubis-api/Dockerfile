# 1. Start with a lightweight, secure Python base runtime image
FROM python:3.11-slim

# 2. Establish a dedicated operational folder inside the container
WORKDIR /app

# 3. Copy your server script from your laptop straight into the container image
COPY server.py .

# 4. Open the network communication port inside the container
EXPOSE 8080

# 5. Define the execution command to launch the app when the container boots
CMD ["python", "server.py"]

