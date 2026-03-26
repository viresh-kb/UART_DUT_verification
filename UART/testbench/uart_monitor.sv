class uart_monitor;
  
  uart_transaction mon_pkt;
 // event mon_done;
  mailbox mon2scb;
  virtual uart_if.mon_mp mon_vif;

  //virtual uart_if mon_vif;
  string name;
  parameter BIT_TIME = sim_files_pkg::baud_clk;
  
  function new(string name = "UART_MONITOR");
    this.name = name;
//    BIT_TIME = sim_files_pkg::baud_clk;
  endfunction
  
  function void connect(virtual uart_if.mon_mp mon_vif, mailbox mon2scb);
begin
   // this.mon_done = mon_done;
    this.mon_vif = mon_vif;
    this.mon2scb = mon2scb;
end
  endfunction
  
  task run();
  begin
    fork
    	monitor_tx();
    	monitor_rx();
    join_none
   // -> mon_done;
  //  $display("monitor_event_triggered");
  end
  endtask
  
  task monitor_tx();
 // begin
    int i;
    logic [7:0] reg_tx;
     
//    $display("[%0t] %s : entered tx_monitor block", $time, name);
    
    forever 
      begin
	$display("[%0t] %s : entered tx_monitor block", $time, name);
    // start bit detect
	@(negedge mon_vif.cb_monitor.tx);
	repeat(BIT_TIME+BIT_TIME/2)@(mon_vif.cb_monitor);
 //    $display("[%0t] %s : start bit to go low", $time,name);
       $display("[%0t] %s : start bit 0 is detected", $time,name);
        
   // sample byte of data
        reg_tx = 8'h00;
        for(i = 0; i < 8; i++) begin
          reg_tx[i] = mon_vif.cb_monitor.tx;
          //@(mon_vif.cb_monitor);
	  repeat(BIT_TIME)@(mon_vif.cb_monitor);
        end
	$display("[%0t] %s : serial to parallel converted data = %0d", $time, name, reg_tx);

   // sample stop bit
   //     @(mon_vif.cb_monitor);
        if(mon_vif.cb_monitor.tx == 1'b1)
          repeat(BIT_TIME*2) @(mon_vif.cb_monitor);
        $display("[%0t] %s : detected stop bit", $time, name);
 	$display("[%0t] %s : TX monitored data = %0d",$time, name, reg_tx);
        
      /*  mon_pkt = new();
        mon_pkt.dintx = reg_tx;
        
        mon2scb.put(mon_pkt);*/

       // $display("[%0t] %s : TX monitored data = %0d",$time, name, reg_tx);
      end
  // end
  endtask
    
  // receiver task
    task monitor_rx();
   // begin
    
	$display("[%0t] %s : entered rx_monitor block ", $time, name);
     forever
      begin
//	$dispaly("[%0t] %s : entered rx_monitor block ", $time, name);
        wait(mon_vif.donerx == 1'b1);
//	@(posedge mon_vif.donerx);
//	repeat(BIT_TIME*8)@(mon_vif.cb_monitor);
       
//        $display("[%0t] %s : Rx data received = %0d",$time, name, mon_vif.doutrx);
        
        mon_pkt = new();
        mon_pkt.doutrx = mon_vif.doutrx;
        
        mon2scb.put(mon_pkt);
        
      $display("[%0t] %s : RX monitored data = %0d", $time, name, mon_vif.doutrx);
                 
      @(negedge mon_vif.donerx);
	repeat(BIT_TIME*12)@(mon_vif.cb_monitor);
        
        
      end
  //  end
    endtask
endclass
