FROM mcr.microsoft.com/quantum/iqsharp-base:0.10.1912.0501

ENV IQSHARP_HOSTING_ENV=QSHARP_BOOK_DEVCONTAINER

USER root 

# Install any VS Online prereqs.
RUN wget -O ~/vsls-reqs https://aka.ms/vsls-linux-prereq-script && \
    chmod +x ~/vsls-reqs && \
    ~/vsls-reqs && \
    # Make sure that the prereq step doesn't leave any cache.
    apt-get clean && rm -rf /var/lib/apt/lists/

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
