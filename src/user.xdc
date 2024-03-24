## This file is a general .xdc for the Basys3 rev B board

## Clock signal

set_property PACKAGE_PIN W5 [get_ports clk]

set_property IOSTANDARD LVCMOS33 [get_ports clk]

create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]

## Switches

set_property PACKAGE_PIN V17 [get_ports {on_sw}]

set_property IOSTANDARD LVCMOS33 [get_ports {on_sw}]

set_property PACKAGE_PIN V16 [get_ports {lb_sw}]

set_property IOSTANDARD LVCMOS33 [get_ports {lb_sw}]

set_property PACKAGE_PIN W16 [get_ports {lp_sw}]

set_property IOSTANDARD LVCMOS33 [get_ports {lp_sw}]

## LEDs

set_property PACKAGE_PIN V19 [get_ports {led[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]

set_property PACKAGE_PIN W18 [get_ports {led[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]

set_property PACKAGE_PIN U15 [get_ports {led[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]

set_property PACKAGE_PIN U14 [get_ports {led[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]

##7 segment display

set_property PACKAGE_PIN U2 [get_ports {SSG_EN[0]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SSG_EN[0]}]

set_property PACKAGE_PIN U4 [get_ports {SSG_EN[1]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SSG_EN[1]}]

set_property PACKAGE_PIN V4 [get_ports {SSG_EN[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SSG_EN[2]}]

set_property PACKAGE_PIN W4 [get_ports {SSG_EN[3]}]

set_property IOSTANDARD LVCMOS33 [get_ports {SSG_EN[3]}]

##Buttons

set_property PACKAGE_PIN U18 [get_ports reset]

set_property IOSTANDARD LVCMOS33 [get_ports reset]