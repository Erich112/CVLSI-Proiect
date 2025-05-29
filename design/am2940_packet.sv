class am2940_data_packet;

   // packet unique id
   int id;

   rand bit[2:0] instruction;
   rand bit[7:0] data;

   rand int delay;

  //3 constraints pt instructiuni
  constraint load_and_read { instruction >= 3'b000 && instruction <= 3'b111; };
  constraint delay_value { delay > 0 && delay < 16; };
  
   function am2940_data_packet copy();
      copy = new();
      copy.id = this.id;
      copy.instruction = this.instruction;
      copy.data = this.data;
      copy.delay = this.delay;
   endfunction : copy

   function void display(string prefix);
     $display("[%0t] %s : data packet ID: %0d , delay is %0d, instruction is h'%h, data is h'%h", $time, prefix, id, delay, instruction, data);
   endfunction : display

endclass : am2940_data_packet