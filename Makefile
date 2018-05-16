JAVAH?=javah
CC?=gcc
LD?=gcc
JPPFLAGS+=-C -P
CFLAGS+=-Wall -Os -pedantic -Werror $(OSX_VERSION_FLAGS)
CSTD?=-std=c99
CSHAREFLAG+=-fpic -fno-stack-protector
GCJJNIFLAG=-fjni
JCFLAGS+=
INCLUDES+=-I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin

MIN_OSX_VERSION=10.6
OSX_SDK=/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX$(MIN_OSX_VERSION).sdk
OSX_VERSION_FLAGS=-mmacosx-version-min=$(MIN_OSX_VERSION) -isysroot $(OSX_SDK)

LDVER?=$(shell ld -v | cut -d' ' -f1)
UNAME?=$(shell uname -s)

ifeq ($(LDVER),GNU)
LDSHAREFLAGS+=-fpic -shared
else
LDSHAREFLAGS+=-dynamiclib $(OSX_VERSION_FLAGS)
endif

MATTVER=0.8.3

DEBUG?=disable

.NOPARALLEL:
.NO_PARALLEL:
.NOTPARALLEL:

all: libunix-java.so

clean:
	rm -f *.o *.h *.so

%.o: %.c %.h
	$(CC) $(CFLAGS) $(CSTD) $(CSHAREFLAG) $(INCLUDES) -c -o $@ $<
lib%.so: %.o
	$(CC) $(LDFLAGS) $(LDSHAREFLAGS) -o $@ $<
unix-java.h:
	$(JAVAH) -classpath ./libmatthew-$(MATTVER).jar -o $@ cx.ath.matthew.unix.UnixServerSocket cx.ath.matthew.unix.UnixSocket cx.ath.matthew.unix.USInputStream cx.ath.matthew.unix.USOutputStream
