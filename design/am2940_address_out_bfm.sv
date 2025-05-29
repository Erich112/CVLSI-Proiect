class am2940_address_out_bfm extends am2940_base_unit;

   virtual output_intf.drv smp_drv;
   virtual output_intf.rcv smp_rcv;

   function new(virtual output_intf.drv smp_drv,
                virtual output_intf.rcv smp_rcv,
                string name,
                int id);
      super.new(name,id);
      this.smp_drv = smp_drv;
      this.smp_rcv = smp_rcv;
   endfunction : new

   task run();
      int delay;

      forever begin
            @(posedge smp_rcv.rcv_cb.done);
         end
   endtask: run

endclass: am2940_address_out_bfm