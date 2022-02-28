onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib start_rom_opt

do {wave.do}

view wave
view structure
view signals

do {start_rom.udo}

run -all

quit -force
