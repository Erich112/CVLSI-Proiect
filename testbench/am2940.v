`include "lib_modules.v"

module am2940(clk,instr,address,datain,dataout,oedata,cina,cona,cinw,conw,done);
  
  //semnalele generale de input si output
  input clk;
  input [2:0] instr;
  output [7:0] address;
  input [7:0] datain;
  output [7:0] dataout;
  output oedata;
  input cina,cinw;
  output cona,conw;
  output done;
  
  
  //semnalele din interior
  
  wire [7:0] doar; //semnalul ce iese din registrul de adrese
  wire [7:0] dowr; //semnalul din registrul de cuvinte
  wire [2:0] docr; //semnalul din registrul de control
  
  wire [7:0] diac; //semnalul ce iese din mux si intra in addr counter
  wire [7:0] diwc; //semnalul ce iese din mux si intra in word counter
  wire [1:0] seld;
  wire [7:0] dowc;
  
  //semnalele ce tin de blocuri
  
  wire plar;
  wire plwr;
  wire sela;
  wire selw;
  wire plcr;
  wire plac;
  wire ena;
  wire inca;
  wire deca;
  wire resw;
  wire plwc;
  wire enw;
  wire incw;
  wire decw;
  
  //instantiem blocurile
  
  reg8 addr_reg(.di(datain),.dout(doar),.clk(clk),.pl(plar));
  
  reg8 word_reg(.di(datain),.dout(dowr),.clk(clk),.pl(plwr));
  
  ctrl_reg ctrl(.di(datain[2:0]),.dout(docr),.clk(clk),.plcr(plcr));
  
  mux addr_mux(.di0(datain),.di1(doar),.dout(diac),.sel(sela));
  
  mux w_mux(.di0(datain),.di1(dowr),.dout(diwc),.sel(selw));
  
  data_mux data(.di0(address),.di1(dowc),.di2(docr),.dout(dataout),.seld(seld));
  
  cnt addr_cnt(.clk(clk),.reset(1'b0),.pl(plac),.enable(ena),.inc(inca),.dec(deca),.CIn(cina),.COn(cona),.in(diac),.out(address));
  
  cnt w_cnt(.clk(clk),.reset(resw),.pl(plwc),.enable(enw),.inc(incw),.dec(decw),.CIn(cinw),.COn(conw),.in(diwc),.out(dowc));
  
  done_gen done_gen_inst(.dowc(dowc),.dowr(dowr),.doac(address),.cinw(cinw),.mode(docr[1:0]),.done(done));
  
  instruction_decoder dec_inst(.i(instr),.cr(docr),.plar(plar),.plwr(plwr),.sela(sela),.selw(selw),.plcr(plcr),.seld(seld),.plac(plac),.ena(ena),.inca(inca),.deca(deca),.resw(resw),.plwc(plwc),.enw(enw),.incw(incw),.decw(decw),.oedata(oedata));
  
endmodule