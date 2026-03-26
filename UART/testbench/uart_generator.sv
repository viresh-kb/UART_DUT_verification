class uart_generator;
  
  uart_transaction data_pkt;
  mailbox gen2drv;
//  event gen_done;
  string name;
  
  
  function new(string name = "uart_generator");
    this.name = name;
  endfunction : new
  
  function void connect(mailbox gen2drv );
    this.gen2drv = gen2drv;
//    this.gen_done = gen_done;
  endfunction : connect
  
  task run(input int iteration);
    repeat(iteration)
    begin
      data_pkt = new();
      if(data_pkt.randomize())
        begin
          $display("UART GENERATOR : Randomization successfull");
          gen2drv.put(data_pkt);
          data_pkt.display_transaction();
        end
    end
   // -> gen_done;
  endtask : run;
endclass 
