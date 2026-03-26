class uart_environment;
  
  uart_generator  gen;
  uart_driver     drv;
  uart_monitor    mon;
  uart_scoreboard scb;
  
  mailbox gen2drv;
  mailbox mon2scb;
  mailbox drv2scb;
  
 // event gen_done;
 // event mon_done;
  
  virtual uart_if.drv_mp drv_vif;
  virtual uart_if.mon_mp mon_vif;
  
  string name;
  
  
  function new(string name = "UART_ENVIRONMENT");
   begin
    this.name = name;
    	 gen  = new("UART_GENERATOR");
         mon  = new("UART_MONITOR");
         drv  = new("UART_DRIVER");
    	 scb  = new("UART_SCOREBOARD");
    
    	 gen2drv = new();
   	 mon2scb = new();
   	 drv2scb = new();
    end
  endfunction
  
  function void connect(virtual uart_if.drv_mp drv_vif, virtual uart_if.mon_mp mon_vif);
  begin
   	this.drv_vif = drv_vif;
    	this.mon_vif = mon_vif;
    	gen.connect(gen2drv);
    	drv.connect(gen2drv,drv2scb,drv_vif);
    	mon.connect(mon_vif,mon2scb);
    	scb.connect(mon2scb,drv2scb);
  end
  endfunction
  
  task start_run(input integer iteration);
    fork
      gen.run(iteration);
     
      drv.run();
 
      mon.run();
      
      scb.run();

    join_none
  endtask
  
endclass
