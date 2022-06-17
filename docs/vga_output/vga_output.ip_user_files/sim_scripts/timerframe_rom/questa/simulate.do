onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib timerframe_rom_opt

do {wave.do}

view wave
view structure
view signals

do {timerframe_rom.udo}

run -all

quit -force
