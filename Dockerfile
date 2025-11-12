# 1. Use a lightweight base image
FROM python:3.9-slim

# 2. Set the working directory
WORKDIR /app

# 3. Copy dependency file first
COPY flask-app/requirements.txt .

# 4. Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# 5. Copy application source code
COPY flask-app/ .

# 6. Expose Flask port
EXPOSE 5000

# 7. Run the Flask app
CMD ["python", "app.py"]
