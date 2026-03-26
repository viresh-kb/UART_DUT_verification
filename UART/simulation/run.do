vlog ../rtl/uart_top.sv ../rtl/uart_if.sv ../testbench/sim_files_pkg.sv ../testbench/tb_top.sv
vsim -c work.tb_top
run 500ns
