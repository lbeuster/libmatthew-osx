JAVAH?=javah
CC?=gcc
LD?=gcc
JPPFLAGS+=-C -P
CFLAGS+=-Wall -Os -pedantic -Werror
CSTD?=-std=c99
CSHAREFLAG+=-fpic -fno-stack-protector
GCJJNIFLAG=-fjni
JCFLAGS+=
INCLUDES+=-I$(JAVA_HOME)/include -I$(JAVA_HOME)/include/darwin

LDVER?=$(shell ld -v | cut -d' ' -f1)
UNAME?=$(shell uname -s)

ifeq ($(LDVER),GNU)
LDSHAREFLAGS+=-fpic -shared
else
LDSHAREFLAGS+=-dynamiclib 
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
