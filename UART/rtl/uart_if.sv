`timescale 1ns/1ps

interface uart_if(input clk, input rst);
  //logic clk;
  //logic uclktx;
  //logic uclkrx;
  //logic rst;
  
//UART TX signals
  
  logic [7:0] dintx;
  logic newd;
  logic tx;
  logic donetx;
  
// UART RX signals
  
  logic rx;
  logic [7:0] doutrx;
  logic donerx;
  
  clocking cb_driver @(posedge clk);
    default input #1ns output #1ns;
    output newd;
    output rx;
    output dintx;
    input tx;
    input donetx;
    input donerx;
    input doutrx;
  endclocking
  
  clocking cb_monitor @(posedge clk);
    default input #1ns output #1ns;
    input newd;
    input tx;
    input rx;
    input dintx;
    input donetx;
    input donerx;
    input doutrx;
  endclocking
  
  modport drv_mp(clocking cb_driver,input clk, input rst,input donerx, output rx);
  modport mon_mp(clocking cb_monitor, input clk, input rst, input donerx, input doutrx);
  modport dut_mp(input rx, input newd, input dintx, output tx, output doutrx, output donetx, output donerx, input clk, input rst); 
    
    
  
endinterface
