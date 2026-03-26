class uart_driver;
  
  uart_transaction data_pkt;
  mailbox gen2drv;
  mailbox drv2scb;
//  event gen_done;
  virtual uart_if.drv_mp drv_vif;
  string name;

 parameter BIT_TIME = sim_files_pkg::baud_clk;
  
  
  function new(string name = "UART_DRIVER");
    this.name = name;
  endfunction
  
  function void connect(mailbox gen2drv,mailbox drv2scb, virtual uart_if.drv_mp drv_vif);
  begin
    this.gen2drv = gen2drv;
    this.drv2scb = drv2scb;
//    this.gen_done = gen_done;
    this.drv_vif = drv_vif;
  end
  endfunction
  
  task run;
    forever begin
      gen2drv.get(data_pkt);
      drv2scb.put(data_pkt);
      $display("[%0t] %s : transaction item dintx : %0d", $time, name, data_pkt.dintx);
      
      drive_tx(data_pkt);
      
   //   drive_rx(data_pkt);
    end
  endtask
  

  task drive_tx(uart_transaction data_pkt);
    begin
      $display("[%0t] %s : entered driver tx_task", $time, name);
      @(drv_vif.cb_driver);
      drv_vif.cb_driver.dintx <= data_pkt.dintx;
  //    repeat(BIT_TIME*11)@(drv_vif.cb_driver);
      $display("[%0t] %s : dintx value is : %0d",$time, name,data_pkt.dintx);
      drv_vif.cb_driver.newd <= 1'b1;
      $display("[%0t] %s : newd value is : %0d", $time,name,drv_vif.cb_driver.newd,);
     repeat(BIT_TIME*4) @(drv_vif.cb_driver);
      drv_vif.cb_driver.newd <= 1'b0;	
    //  @(drv_vif.cb_driver.newd <= 1'b0);
      
     // wait(drv_vif.cb_driver.donetx == 1'b1);
	repeat(BIT_TIME*11)@(drv_vif.cb_driver);	
      
      $display("[%0t] %s : data transmitted successfully", $time, name);
      $display("[%0t] %s : dintx value is : %0d",$time, name,drv_vif.cb_driver.dintx);

    end
endtask

    task drive_rx(uart_transaction data_pkt);
      begin
//	 $display("[%0t] %s : entered driver rx_task", $time, name);
        int i;
       	drv_vif.rx <= 1'b1;   // keep rx == 1 in the idle state
	$display("[%0t] %s : entered driver rx_task", $time, name);
        repeat(1) @(drv_vif.cb_driver);
        
        drv_vif.rx <= 1'b0; // start bit
       $display("[%0t] %s : detected start bit 0",$time,name); 
        for(i = 0; i < 8 ; i++) begin
          drv_vif.rx <= data_pkt.dintx[i];
          repeat(1) @(drv_vif.cb_driver);
	$display("[%0t] %s : driver rx data = %0d", $time, name, drv_vif.rx);
        end
	
//	$display("[%0t] %s : driver rx data = %0d", $time, name, drv_vif.rx);
        
        drv_vif.rx <= 1'b1;
        repeat(2) @(drv_vif.cb_driver);
	$display("[%0t] %s : detected stop bit 1 for 2 clock cycles", $time, name);
        
        wait(drv_vif.donerx == 1'b1);
        
        $display("[%0t] %s : data received successfully", $time, name);
      end
    endtask
endclass
