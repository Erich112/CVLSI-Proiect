`include "am2940.v"

module top_inst(clk,instr,address,datain,dataout,oedata,cina,cona,cinw,conw,done);
  input clk;
  input [2:0] instr;
  output [7:0] address;
  input [7:0] datain;
  output [7:0] dataout;
  output oedata;
  input cina, cinw;
  output cona, conw;
  output done;

  am2940 am29401 (
      .clk    (clk),
      .instr  (instr),
      .address(address),
      .datain (datain),
      .dataout(dataout),
      .oedata (oedata),
      .cina   (cina),
      .cinw   (cinw),
      .cona   (cona),
      .conw   (conw),
      .done   (done)
  );
  
  input_intf input_intf (
      .clk(clk),
      .instr(instr),
      .datain(datain),
      .cinw(cinw),
    .cina(cina)
  );
  output_intf output_intf (
      .clk(clk),
      .address(address),
      .dataout(dataout),
      .oedata(oedata),
    .conw(conw),
      .cona(cona),
      .done(done)
  );
  
endmodule
