#######################################################
# Dockerfile for Azure C++ Storage Libary on Linux
# To build the docker image and Azure resouces
#  1 - Create an Azure storage account
#  2 - Create an Azure blob container
#  3 - Upload a small text file 
#  4 - Change the sample.cpp code (connection string, container name, file name)
#  5 - Build this docker image "docker build -t blobcplusplus ."
# To run 
#  1 - docker run -it blobcplusplus bash
#  2 - cd /tmp  
#  3 - run: export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage/build.release/Binaries/ 
#  4 - run: export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ 
#  5 - run ./sample
#######################################################

FROM ubuntu:16.04
  
#######################################################
# Set up base
#######################################################
RUN apt-get update && apt-get install -y --no-install-recommends \
    autotools-dev \
    build-essential \
    curl \
    cmake \
    ca-certificates
    

#######################################################
# Install Casablanca needed for Azure Blob C++ library
# https://github.com/Microsoft/cpprestsdk/wiki/How-to-build-for-Linux
#######################################################
RUN apt-get update && apt-get install -y \
    apt-utils \
    libcpprest-dev \ 
    g++ \
    git \
    make \
    zlib1g-dev \
    libboost-all-dev \
    libssl-dev 

# Download a specific version
RUN curl -o /tmp/casablanca.tar.gz -L 'https://github.com/Microsoft/cpprestsdk/archive/v2.9.1.tar.gz' && \
    tar -xvf /tmp/casablanca.tar.gz -C /tmp && \
    mv /tmp/cpprestsdk-2.9.1 /tmp/casablanca

# Compile it and install it (you install it in case there are two versions of cpprest)
RUN cd /tmp/casablanca/Release && \
    mkdir /tmp/casablanca/Release/build.release && \
    cd /tmp/casablanca/Release/build.release && \
    cmake .. -DCMAKE_BUILD_TYPE=Release -DBUILD_SAMPLES=OFF -DBUILD_TESTS=OFF && \
    make install


#######################################################
# Install Azure C++ Blob library
# https://github.com/Azure/azure-storage-cpp
#######################################################
RUN curl -o  /tmp/azure-storage.tar.gz -L 'https://github.com/Azure/azure-storage-cpp/archive/v4.0.0.tar.gz' && \
    tar -xvf /tmp/azure-storage.tar.gz -C /tmp && \
    mv /tmp/azure-storage-cpp-4.0.0 /tmp/azure-storage-cpp

RUN apt-get update && apt-get install -y libxml2-dev uuid-dev

# Compile it
RUN cd    /tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage  && \
    mkdir /tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage/build.release && \
    cd    /tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage/build.release && \
    CXX=g++ cmake .. -DCMAKE_BUILD_TYPE=Release  && \
    make


#######################################################
# Run a sample
#######################################################
COPY sample.cpp /tmp/sample.cpp
COPY Makefile /tmp/Makefile

RUN cd /tmp && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage/build.release/Binaries/  && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ && \
    make

# NOTE: You need the two export commands
RUN cd /tmp && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage/build.release/Binaries/  && \
    export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/ && \
    ./sample && \
    echo "Displaying Blob" && \
    cat /tmp/DownloadBlobFile.txt && \
    echo ""
