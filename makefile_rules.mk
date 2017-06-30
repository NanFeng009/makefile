INCLUDES += -I$(INFRA)/include
19ifeq "$(BUILD_FOR_HOST)" "true"
20LIBRARIES += -L.
21else
22LIBRARIES += -L$(INFRA)/lib
23endif
24
25
26COMPILE = $(CC) $(INCLUDES) $(CFLAGS)
27
28%.o: %.cpp
29	@echo "Building $*.cpp"
30	$(COMPILE) -c $< -o $*.o
31
32%.o: %.c
33	@echo "Building $*.c"
34	$(COMPILE) -c $< -o $*.o
