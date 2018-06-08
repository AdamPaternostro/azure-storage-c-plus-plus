CC=g++

OPTIMIZE=-fopenmp -O5 -m64 

#COMPILE_OPTS=-static-libgcc -Wno-missing-braces -ftemplate-depth-50 
COMPILE_OPTS=-std=c++11

# list of source files
SOURCES= \
	sample.cpp 

# macro to convert sources into objects
OBJECTS = $(SOURCES:%.cpp=%.o)

LIBDIRS= \
	-L/usr/local/lib \
	-L/tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage/build.release/Binaries \
	-L/usr/lib64

INCLUDE= \
	-I. \
	-I./include \
	-I/tmp/azure-storage-cpp/Microsoft.WindowsAzure.Storage/includes \
	-I/tmp/casablanca/Release/include 

APP = sample

CFLAGS=  -D_REENTRANT  

LIBS= \
	-lstdc++ \
	-lnsl \
	-lm \
	-lpthread \
	-ldl \
	-lboost_system \
	-lssl \
	-lcrypto \
	-lcpprest \
	-lazurestorage 

.SUFFIXES:
.SUFFIXES: .cpp .h .c .o $(SUFFIXES)

all:$(APP)

sample:$(OBJECTS)
	$(CC) $(OPTIMIZE) $(COMPILE_OPTS) $(INCLUDE) $(CFLAGS) $(DEFINES) -o sample $(OBJECTS) $(LIBS) $(LIBDIRS) $(INCLUDEDIRS)

.cpp.o:
	$(CC) $(OPTIMIZE) $(COMPILE_OPTS) $(INCLUDE) $(CFLAGS) $(DEFINES) -c $<

.c.o:
	$(CC) $(OPTIMIZE) $(COMPILE_OPTS) $(INCLUDE) $(CFLAGS) $(DEFINES) -c $<

clean:
	rm -rf *.o

clobber: clean
	rm -rf $(APP) *.o
