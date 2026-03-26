class uart_transaction;
  randc logic [7:0] dintx;
  	logic [7:0] doutrx;
  
  constraint uart_cons {dintx inside {[1 : 50]};}
  
  function void display_transaction();
    $display("dintx = %0d",dintx);
  endfunction
  
endclass
