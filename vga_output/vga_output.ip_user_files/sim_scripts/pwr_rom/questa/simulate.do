onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib pwr_rom_opt

do {wave.do}

view wave
view structure
view signals

do {pwr_rom.udo}

run -all

quit -force
