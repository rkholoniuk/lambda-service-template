# Use a specific Python runtime version
FROM public.ecr.aws/lambda/python:3.9 AS builder

# Set a non-root user
RUN useradd --no-log-init --system --uid 1001 lambdauser

# Set working directory
WORKDIR /var/task

# Copy requirements.txt and verify package integrity
COPY requirements.txt .

# Install dependencies securely
RUN pip install --no-cache-dir --user -r requirements.txt

# Copy only necessary application files
COPY lib ./lib
COPY app.py .

# Set appropriate ownership and permissions
RUN chown -R lambdauser:lambdauser /var/task && \
    chmod -R 755 /var/task

# Switch to non-root user
USER lambdauser

# Set the CMD to your handler
CMD [ "app.handler" ]
