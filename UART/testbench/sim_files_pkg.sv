package sim_files_pkg;

	parameter clk_freq  = 1000000;
	parameter baud_rate = 9600;

	// bit time calculating
	
	parameter baud_clk = 1_000_000/baud_rate;

	`include "uart_transaction.sv"
	`include "uart_generator.sv"
	`include "uart_driver.sv"
	`include "uart_monitor.sv"
	`include "uart_scoreboard.sv"
	`include "uart_environment.sv"
	`include "base_test.sv"
endpackage
