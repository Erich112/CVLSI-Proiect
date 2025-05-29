interface input_intf(
  input wire clk,
  output bit [2:0] instr,
  output bit [7:0] datain,
   output bit cina,
   output bit cinw
);

   clocking drv_cb @(posedge clk);
      output instr;
      output datain;
      output cinw;
      output cina;
   endclocking
   modport drv(clocking drv_cb, input clk);


   clocking rcv_cb @(posedge clk);
      input instr;
      input datain;
      input cina;
      input cinw;
   endclocking
   modport rcv(clocking rcv_cb, input clk);

endinterface : input_intf


interface output_intf(
   input wire clk,
  input wire [7:0] address,
  input wire [7:0] dataout,
   input wire oedata,
   input wire conw,
   input wire cona,
   input wire done
);

   clocking drv_cb @(negedge clk);

   endclocking
   modport drv(clocking drv_cb, input clk);

   
   clocking rcv_cb @(negedge clk);
      input address;
      input dataout;
      input oedata;
      input cona;
      input conw;
      input done;
   endclocking
   modport rcv(clocking rcv_cb, input clk);
   
endinterface : output_intf
