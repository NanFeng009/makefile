# 目标模式，debug/release
#VERSION = release
VERSION = debug

ifeq ($(VERSION), release)
CPP_FLAGS = -O2 -Wall -D VS_DEBUG
else
CPP_FLAGS = -g -Wall
endif

# 编译器类型
CC = gcc
CXX = g++

# 当前工作目录
CUR_DIR = $(shell pwd)

# 添加搜索包含文件的路径
INC = -I./Macro 
INC += -I./ISO8583 
INC += -I./Network 
INC += -I./Common
INC += -I./Database
INC += -I./TradeInterface

# 动态库加载选项
LIB = -L./lib -liso8583 
LIB += -L./lib -lnetwork 
LIB += -L./lib -lcommon 
LIB += -L./lib -lpaymysql 
LIB += -L./lib -lpaytrade
LIB += -lpthread 
LIB += -lmysqlclient -L/usr/lib/mysql
SO_FLAGS = -Wl,-rpath,$(CUR_DIR)/lib

# 二进制文件安装目录
BIN = ./bin

# 目标依赖集
OBJS = $(wildcard *.cpp)

# 要调用的子makefile所在的目录
dirs = ISO8583
dirs += Network
dirs += Common
dirs += Database
dirs += TradeInterface

# 编译的目标,执行子makefile再执行主控makefile
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
