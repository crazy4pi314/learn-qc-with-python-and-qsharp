FROM mcr.microsoft.com/quantum/iqsharp-base:0.10.2001.2831

ENV IQSHARP_HOSTING_ENV=QSHARP_BOOK_DOCKERFILE

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

COPY . ${HOME}
RUN chown -R ${USER} ${HOME}

USER ${USER}
