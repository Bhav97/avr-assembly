COMPILER=avra
C_OPTS=fI
STTY=stty
SCREEN=screen
AVRDUDE=avrdude
DEBUG=0
BOARD_LOC=/dev/ttyACM0
RESET_SCRIPT="import serial,sys,time;s=serial.Serial(\"${BOARD_LOC}\",9600);s.setDTR(0);time.sleep(0.1);s.flushInput();s.setDTR(1);s.close();"

%.hex: %.asm
	${COMPILER} -${C_OPTS} $<
ifeq (${DEBUG}, 0)
	-rm *.eep.hex *.obj *.cof
endif

all: $(patsubst %.asm,%.hex,$(wildcard *.asm))

upload: ${program}.hex
	${AVRDUDE} -c arduino -p m328p -P ${BOARD_LOC} -b 115200 -U flash:w:$<

baud:
	@echo baud rate: `${STTY} -F ${BOARD_LOC} | head -c 24 | sed 's/[^1234567890]//g'`

serial:
	@echo "CTRL+a+d to exit <Enter to continue>"
	@read
	${SCREEN} ${BOARD_LOC} && ${SCREEN} -X quit

reset:
	@echo Writing reset script
	@touch reset.py
	@echo ${RESET_SCRIPT} >> reset.py
	python reset.py
ifeq (${DEBUG}, 0)
	-rm reset.py
endif

.PHONY: all upload monitor baud
