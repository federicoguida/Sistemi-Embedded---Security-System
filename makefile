EMBEDDED: utility.f assembly.f gpio.f timer.f i2c.f lcd.f keypad.f hdmi.f led.f log.f  security.f
	cat utility.f >> merged.f
	cat assembly.f >> merged.f
	cat gpio.f >> merged.f
	cat timer.f >> merged.f
	cat i2c.f >> merged.f
	cat lcd.f >> merged.f
	cat keypad.f >> merged.f
	cat hdmi.f >> merged.f
	cat led.f >> merged.f
	cat log.f >> merged.f
	cat security.f >> merged.f
	sudo picocom --b 115200 /dev/ttyUSB0 --imap delbs -s "ascii-xfr -sv -l100 -c10"
