FROM mcr.microsoft.com/devcontainers/python:1-3.11-bullseye

COPY packages.txt /tmp/packages.txt
COPY requirements.txt /tmp/requirements.txt

RUN if [ -f /tmp/packages.txt ]; then \
        sudo apt-get update && \
        sudo apt-get install -y $(cat /tmp/packages.txt) && \
        sudo rm -rf /var/lib/apt/lists/*; \
    fi

# Install Python requirements 
RUN if [ -f /tmp/requirements.txt ]; then \
        pip install --user -r /tmp/requirements.txt; \
    fi

# Install Streamlit
RUN pip install --user streamlit

# Add user base binary directory to PATH
ENV PATH=$PATH:/root/.local/bin
