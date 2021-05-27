# This Dockerfile is used by the GitHub Action in
# .github/workflows/build-container.yml to build the Docker image used for
# Visual Studio Code remote development, Visual Studio Online.
FROM mcr.microsoft.com/quantum/iqsharp-base:0.17.2105143879

ENV IQSHARP_HOSTING_ENV=QSHARP_BOOK_DEVCONTAINER

USER root 

# Install additional system packages from apt.
RUN apt-get -y update && \
    apt-get -y install \
        g++ && \
    apt-get clean && rm -rf /var/lib/apt/lists/

RUN pip install cython \
                numpy \
                matplotlib \
                scipy && \
    pip install qutip

USER ${USER}
