# Get the python 3.11 image as the base image
From python:3.11

# Set the working directory in the container
WORKDIR /code

# Copy the requirements file into the container at /code
COPY ./requirements.txt /code/requirements.txt

# Install the dependencies
# --no-cache-dir to avoid caching the installation, helpful to cache during development
# --upgrade to upgrade the dependencies if they are already installed (## TODO: check if this is necessary)
RUN pip install --no-cache-dir --upgrade -r /code/requirements.txt

# Copy the application code into the container at /code/app/
COPY ./app /code/app

# Set the environment variables from the .env file

# Run the application
CMD ["python", "/code/app/main.py"]
```