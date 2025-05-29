// Code your testbench here
// or browse Examples

`include "top_inst.sv"
`include "am2940_test_basic.sv"

module top();
  reg clk;
  reg [2:0] instr;
  wire [7:0] address;
  reg [7:0] datain;
  wire [7:0] dataout;
  wire oedata;
  reg cina, cinw;
  wire cona, conw;
  wire done;

  top_inst inst(clk,instr,address,datain,dataout,oedata,cina,cona,cinw,conw,done);

  //Clock generator
  initial begin
    clk = 0;
    forever begin
      #30 clk = !clk;
    end
  end

  test_addr test_principal = new();

  initial begin
    //conectam input-urile 
    assign instr = inst.input_intf.instr;
    assign datain = inst.input_intf.datain;
    cina = 0;
    cinw = 0;
    //se va continua asignarea pentru toate semnalele notate ca input in top_inst.sv

    test_principal.test(inst.input_intf, inst.output_intf);
  end

    initial begin
      $dumpfile("dump.vcd");
      $dumpvars(0,inst);
    end

endmodule