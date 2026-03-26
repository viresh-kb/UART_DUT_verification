`timescale 1ns/1ps

import sim_files_pkg::*;

module tb_top;

  parameter clk_freq = 1000000;
  parameter baud_rate = 9600;
  
  bit clk,rst;
  uart_if u_inf(clk,rst);

  assign u_inf.rx = u_inf.tx;
    
  uart_top #(.clk_freq(1000000), .baud_rate(9600) )
	     dut(.clk(clk),
                 .rst(rst),
                 .rx(u_inf.rx),
                 .dintx(u_inf.dintx),
                 .newd(u_inf.newd),
                 .tx(u_inf.tx),
                 .doutrx(u_inf.doutrx),
                 .donetx(u_inf.donetx),
                 .donerx(u_inf.donerx)
                );

  base_test test_h;
 
  initial begin
	clk = 1'b0; 
        forever begin 
        #5 clk = ~clk; 
    end
  end 
  
  task rst_gen();
    begin
      rst = 1'b0;
   #15 rst = ~rst;
    end
  endtask
  
  initial begin
    rst_gen();  
    test_h = new("BASE_TEST",u_inf,10);
    test_h.run();
  end

/*initial begin
//@(posedge rst);
  if(rst)
    test_h.run();
  end	
end*/
  
  endmodule
