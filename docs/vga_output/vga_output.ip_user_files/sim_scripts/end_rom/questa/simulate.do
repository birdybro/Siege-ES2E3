onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib end_rom_opt

do {wave.do}

view wave
view structure
view signals

do {end_rom.udo}

run -all

quit -force
