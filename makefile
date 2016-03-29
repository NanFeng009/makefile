# Ŀ��ģʽ��debug/release
#VERSION = release
VERSION = debug

ifeq ($(VERSION), release)
CPP_FLAGS = -O2 -Wall -D VS_DEBUG
else
CPP_FLAGS = -g -Wall
endif

# ����������
CC = gcc
CXX = g++

# ��ǰ����Ŀ¼
CUR_DIR = $(shell pwd)

# ������������ļ���·��
INC = -I./Macro 
INC += -I./ISO8583 
INC += -I./Network 
INC += -I./Common
INC += -I./Database
INC += -I./TradeInterface

# ��̬�����ѡ��
LIB = -L./lib -liso8583 
LIB += -L./lib -lnetwork 
LIB += -L./lib -lcommon 
LIB += -L./lib -lpaymysql 
LIB += -L./lib -lpaytrade
LIB += -lpthread 
LIB += -lmysqlclient -L/usr/lib/mysql
SO_FLAGS = -Wl,-rpath,$(CUR_DIR)/lib

# �������ļ���װĿ¼
BIN = ./bin

# Ŀ��������
OBJS = $(wildcard *.cpp)

# Ҫ���õ���makefile���ڵ�Ŀ¼
dirs = ISO8583
dirs += Network
dirs += Common
dirs += Database
dirs += TradeInterface

# �����Ŀ��,ִ����makefile��ִ������makefile
TARGET1 = SUB_MAKEFIE
TARGET2 = server

all : $(TARGET1) $(TARGET2)
$(TARGET1):
#	$(foreach N,$(dirs),make -C $(N);)
$(TARGET2):$(OBJS) Main.cxx
	$(CXX) $(CPP_FLAGS) $^ $(LIB) $(INC) -o $@ $(SO_FLAGS)

%.o:%.cpp
	$(CXX) $(CPP_FLAGS) -c $< -o $@

install:
	-mv -f $(TARGET2) $(BIN)

.PHONEY : clean
clean:
	-rm *.bak
	-rm *.o
