CC = gcc
CFLAGS = -Wall -Ilibs -Iosdp -Iroger
LDFLAGS = -s -Wl,-warn-common -lc -lsqlite3

all:
	@echo "make what?"


# KD app
kd-roger: build/kd-roger.o build/roger.a build/md5.o
	@echo Link... $@
	$(CC) $(CFLAGS) -pthread -lm -o $@ $^ -lpthread $(LDFLAGS)

kd-idesco: build/kd-idesco.o build/osdp.a build/md5.o
	@echo Link... $@
	$(CC) $(CFLAGS) -pthread -lm -o $@ $^ -lpthread $(LDFLAGS)

kd-idesco-rs232: build/kd-idesco-rs232.o build/osdp.a build/md5.o
	@echo Link... $@
	$(CC) $(CFLAGS) -pthread -lm -o $@ $^ -lpthread $(LDFLAGS)

build/kd-roger.o: CFLAGS += -DROGER
build/kd-roger.o: kontrola_dostepu.c
	$(CC) $(CFLAGS) -o $@ -c $<

build/kd-idesco.o: CFLAGS += -DIDESCO -DTTY_PORT="\"/dev/ttyS2\""
build/kd-idesco.o: kontrola_dostepu.c
	$(CC) $(CFLAGS) -o $@ -c $<

build/kd-idesco-rs232.o: CFLAGS += -DIDESCO -DTTY_PORT="\"/dev/ttyS2\"" -D_USE_RS232
build/kd-idesco-rs232.o: kontrola_dostepu.c
	$(CC) $(CFLAGS) -o $@ -c $<


# Roger EPSO lib
build/roger.a: build/roger.o
	ar ru $@ $^
	ranlib $@

build/roger.o: roger/roger.c roger/roger.h
	$(CC) $(CFLAGS) -o $@ -c $<


# OSDPv2 lib
build/osdp.a: build/util.o build/osdp.o build/crctable.o
	ar ru $@ $^
	ranlib $@

build/%.o: osdp/%.c osdp/%.h
	$(CC) $(CFLAGS) -o $@ -c $<

# MD5 lib
build/md5.o: libs/md5.c libs/md5.h
	$(CC) $(CFLAGS) -o $@ -c $<
