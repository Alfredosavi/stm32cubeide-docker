# Base image used for both stages
ARG IMAGE=ubuntu:24.04

# -------------------------------
# Stage 1: Extract installer script
# -------------------------------
FROM ${IMAGE} AS extractor

# Install unzip tool to extract the STM32CubeIDE installer from the .zip package
RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip

# Copy STM32CubeIDE installer bundle (provided externally) into the container
COPY st-stm32cubeide_1.19.0_25607_20250703_0907_amd64.deb_bundle.sh.zip /tmp/stm32cubeide_installer.sh.zip

# Extract the actual .sh installer from the .zip archive
RUN unzip -p /tmp/stm32cubeide_installer.sh.zip > /tmp/stm32cubeide_installer.sh && rm /tmp/stm32cubeide_installer.sh.zip

# -------------------------------
# Stage 2: Build final image with STM32CubeIDE installed
# -------------------------------
FROM ${IMAGE}

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Accept license automatically for STM32CubeIDE installer
ENV LICENSE_ALREADY_ACCEPTED=1

# Default display for GUI applications (can be mapped from host X11)
ENV DISPLAY=:0

# Set timezone to UTC (adjust if needed)
ENV TZ=America/Sao_Paulo

# STM32CubeIDE version (used in PATH setup)
ENV STM32CUBEIDE_VERSION=1.19.0

# Add STM32CubeIDE binaries to PATH
ENV PATH="${PATH}:/opt/st/stm32cubeide_${STM32CUBEIDE_VERSION}"

# Install runtime dependencies required by STM32CubeIDE
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    x11-apps \
    libswt-gtk-4-java

# Copy extracted installer script from the previous stage
COPY --from=extractor /tmp/stm32cubeide_installer.sh /tmp

# Run the STM32CubeIDE installer, then cleanup temporary files and apt cache
RUN chmod +x /tmp/stm32cubeide_installer.sh && \
    /tmp/stm32cubeide_installer.sh && \
    rm /tmp/stm32cubeide_installer.sh && \
    rm -rf /var/lib/apt/lists/*
