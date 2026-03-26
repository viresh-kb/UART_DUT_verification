class base_test;

//import sim_files_pkg::*;

	uart_environment env;
	virtual uart_if vif, drv_vif, mon_vif;
	string name;

	int no_of_transaction;

function new(string name = "UART_TEST", virtual uart_if vif, int no_of_transaction = 1);
	this.name = name;
	this.mon_vif  = vif;
	this.drv_vif  = vif;
	this.no_of_transaction = no_of_transaction;
endfunction

task run();
	$display("[%0t] %s : test started", $time, name);
	env = new();
	env.connect(drv_vif, mon_vif);
	env.start_run(no_of_transaction);

#10000;
$display("[%0t] %s : Test completed",$time, name);
endtask
endclass
