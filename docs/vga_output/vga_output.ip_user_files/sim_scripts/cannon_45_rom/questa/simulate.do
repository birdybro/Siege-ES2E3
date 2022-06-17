onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib cannon_45_rom_opt

do {wave.do}

view wave
view structure
view signals

do {cannon_45_rom.udo}

run -all

quit -force
