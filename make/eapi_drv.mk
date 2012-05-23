
HOST_CC := gcc
HOST_AR := ar
HOST_RANLIB := ranlib

ifeq ($(TARGET_SYS),)
OSNAME  := $(shell uname -s)
MACHINE := $(shell uname -m)
CC := $(HOST_CC)
AR := $(HOST_AR)
RANLIB := $(HOST_RANLIB)
EAPI_PFX := 
else
OSNAME := Linux
MACHINE := arm
CC := $(TARGET_SYS)-gcc
AR := $(TARGET_SYS)-ar
RANLIB := $(TARGET_SYS)-ranlib
EAPI_PFX := $(TARGET_SYS)-
endif

# FIXME: host erl and target must match
ERLDIR	:= $(shell erl -noshell -eval "io:format([126,115,126,110],[code:root_dir()])" -s erlang halt)
ERL_C_INCLUDE_DIR := $(ERLDIR)/usr/include

MAC_OS_X  = No
WIN32     = No
LINUX     = No

CFLAGS += -fPIC -Wall -Wextra -Wswitch-default -Wswitch-enum -D_THREAD_SAFE -D_REENTRANT -fno-common -I../include

ifeq ($(TYPE), debug)
OBJDIR=../obj/debug
LIBDIR=../lib/debug
PRIVDIR=../priv/debug
CFLAGS +=  -DDEBUG -g 
endif

ifeq ($(TYPE), release)
OBJDIR=../obj/release
LIBDIR=../lib/release
PRIVDIR=../priv/release
CFLAGS += -fPIC -O3
endif

ifeq ($(OSNAME), Linux)
LINUX = Yes
LD_SHARED := $(CC) -shared
endif

ifeq ($(OSNAME), Darwin)
MAC_OS_X = Yes
CFLAGS += -arch i386 -arch x86_64 -DDARWIN -no-cpp-precomp
LD_SHARED := $(CC) -arch i386 -arch x86_64 -bundle -flat_namespace -undefined suppress
endif

ifeq ($(WIN32),Yes)
	CFLAGS += -DWIN32
endif
