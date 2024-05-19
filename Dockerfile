FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye

# Copy packages.txt and requirements.txt if they exist
COPY packages.txt /tmp/packages.txt
COPY requirements.txt /tmp/requirements.txt

# Install additional packages if packages.txt exists
RUN if [ -f /tmp/packages.txt ]; then \
        sudo apt-get update && \
        sudo apt-get install -y $(cat /tmp/packages.txt) && \
        sudo rm -rf /var/lib/apt/lists/*; \
    fi

# Install Python requirements if requirements.txt exists
RUN if [ -f /tmp/requirements.txt ]; then \
        pip install --user -r /tmp/requirements.txt; \
    fi

# Install Streamlit
RUN pip install --user streamlit

# Add user base binary directory to PATH
ENV PATH=$PATH:/root/.local/bin
