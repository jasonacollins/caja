FROM ubuntu:20.04

# Prevent interactive prompts during build
ENV DEBIAN_FRONTEND=noninteractive

# Setup ODBC
RUN apt-get update && apt-get install -y \
    curl \
    apt-transport-https \
    gnupg \
    unixodbc \
    unixodbc-dev \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Import Microsoft keys and repositories
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list

# Install SQL Server tools compatible with ARM64
RUN apt-get update && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends msodbcsql18 && \
    ACCEPT_EULA=Y apt-get install -y --no-install-recommends mssql-tools18 && \
    rm -rf /var/lib/apt/lists/*

# Add SQL Server tools to path
RUN echo 'export PATH="$PATH:/opt/mssql-tools18/bin"' >> ~/.bashrc

# Install required Python packages
RUN pip3 install pyodbc flask pandas tqdm flask_cors boto3 xmltodict openpyxl xlrd

# Update ODBC driver configuration with correct path
RUN echo "[ODBC Driver 18 for SQL Server]" > /etc/odbcinst.ini && \
    echo "Description=Microsoft ODBC Driver 18 for SQL Server" >> /etc/odbcinst.ini && \
    echo "Driver=/usr/lib/libmsodbcsql-18.so" >> /etc/odbcinst.ini && \
    echo "UsageCount=1" >> /etc/odbcinst.ini