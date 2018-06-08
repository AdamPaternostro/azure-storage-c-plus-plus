# How to compile the Azure C++ Storage library on Linux
Need to access Azure storage using Linux and C++.  This will show you how to get the Azure C++ storage library installed and running.  This uses Docker so you can have a known, re-creatable environment.  There are lots of little small things that need to be right.  

### To get this running
1. Ensure you have Docker
2. Clone or download this repository
3. See the Dockerfile for instructions
4. Enjoy

### References
- This documentation is here: https://docs.microsoft.com/en-us/azure/storage/blobs/storage-c-plus-plus-how-to-use-blobs
- To get this compiled on Linux you need
  - Casablanca: https://github.com/Microsoft/cpprestsdk/wiki/How-to-build-for-Linux
  - The C++ library: https://github.com/Azure/azure-storage-cpp
