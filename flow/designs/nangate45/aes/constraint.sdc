###############################################################################
# Created by write_sdc
# Wed May  5 15:00:13 2021
###############################################################################
current_design aes_cipher_top
###############################################################################
# Timing Constraints
###############################################################################
create_clock -name clk -period 0.8109 -waveform {0.0000 0.4054} [get_ports {clk}]
###############################################################################
# Environment
###############################################################################
###############################################################################
# Design Rules
###############################################################################
