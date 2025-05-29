class am2940_address_out_generator extends am2940_base_unit;

   int id;
   rand int delay;
   constraint keep_delay_0 { delay==0; }

   function new(string name,int id);
     super.new(name,id);
     this.id=id;
   endfunction: new

   function int generate_delay();
     void'(this.randomize(delay));
     return delay;
   endfunction: generate_delay

endclass: am2940_address_out_generator