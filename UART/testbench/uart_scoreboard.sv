class uart_scoreboard;
  
//  uart_transaction data_pkt;
//  uart_transaction mon_data_pkt;
  mailbox mon2scb;
  mailbox drv2scb;
//  event mon_done;
  string name;

 
  int pass_count = 0;
  int failed_count = 0;
  
  
  function new(string name = "uart_scoreboard");
    this.name = name;
    
  endfunction
  
  function void connect(mailbox mon2scb, mailbox drv2scb);
    this.mon2scb = mon2scb;
    this.drv2scb = drv2scb;
   // this.mon_done = mon_done;
  endfunction;
  
  function bit compare(uart_transaction drv_pkt,uart_transaction mon_pkt);
    return (drv_pkt.dintx == mon_pkt.doutrx);
  endfunction
    
    task run();
 	 uart_transaction data_pkt;
  	uart_transaction mon_pkt;

      forever begin
      $display("[%0t] %s : Entered scoreboard block", $time, name);
              	
     //   wait(mon_done.triggered);
        
        drv2scb.get(data_pkt);
	$display("[%0t] %s : data coming from driver to scoreboard = %0d", $time, name, data_pkt.dintx);
        mon2scb.get(mon_pkt);
	$display("[%0t] %s : data coming from monitor to scoreboard = %0d", $time, name, mon_pkt.doutrx);

      $display("[%0t] %s : calling compare function", $time, name);
        
        if(compare(data_pkt, mon_pkt))
          begin
            pass_count++;
            $display("[%0t] %s : pass | TX = %0d , RX = %0d",$time,name,data_pkt.dintx, mon_pkt.doutrx);
            
          end
        else 
          begin
            failed_count++;
            $display("[%0t] %s : Failed | TX = %0d , RX = %0d",$time,name,data_pkt.dintx,mon_pkt.doutrx);
          end
        
      end
    endtask


/*task report();
	$display("///////////SCOREBOARD COMPARISION REPORT");
	$display("TOTAL TRANSACTION : %0d");
	$display("Comparision successfull : %0d", pass_count++);	
	$display("Comparision unsuccessfull : %0d", failed_count++);
	$display("///////////SCOREBOARD REPORT DONE/n");
	
	$display("======================================================================================================");
endtask*/
    endclass
