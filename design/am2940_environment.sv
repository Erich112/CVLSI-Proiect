class am2940_environment extends am2940_base_unit;

   int number_of_packets;

   //a smart queue of all the units instantiated in the environment;
   //this is very useful for modularization, because you can take out any
   //environment component and the remaining ones will still work
   am2940_base_unit units[$];
   am2940_packet packet_mbox, data_in_mbox, address_out_mbox;
   am2940_data_in_generator data_in_generator;
   am2940_data_in_bfm data_in_bfm;
   am2940_data_in_monitor data_in_monitor;
   am2940_address_out_monitor address_out_monitor;
   am2940_scoreboard scbd;
   int counter=0, watchdog=200000;													  

   function new (int unsigned number_of_packets,
                  string name,
                  int id);
      super.new(name,id);
      this.number_of_packets=number_of_packets;

      //Input channel generator
      //notice how 'packet_mbox' is sent to both BFM and generator as parameters
      //to their constructor
      packet_mbox=new();
     address_out_mbox=new();
      data_in_generator = new(packet_mbox,
                              number_of_packets,
                              "DATA_IN_GENERATOR",
                              1);
      units.push_back(data_in_generator);

      //Input channel BFM
      data_in_bfm = new(packet_mbox,
                        top.inst.input_intf.drv,
                        top.inst.input_intf.rcv,
                        "DATA_IN_BFM", 2);
      units.push_back(data_in_bfm);

     
      //Channel in monitor
      data_in_mbox=new();
     data_in_monitor=new(top.inst.input_intf.rcv,
                           data_in_mbox,
                           "DATA_IN_MONITOR",
                           3);
      units.push_back(data_in_monitor);	
     
     address_out_monitor = new(0,top.inst.output_intf.rcv,
                                                address_out_mbox,
                                                "CHANNEL_OUT_MONITOR0",
                                                0);
            
      units.push_back(address_out_monitor);	
     
      //Scoreboard
      //instantiate the scoreboard									   
      scbd = new("SCOREBOARD",
               10,
               data_in_mbox,
               address_out_mbox);
      units.push_back(scbd);			  
  
  endfunction: new
  
     
   task testend();
     while (1) begin
       
         if(scbd.total_packets==number_of_packets) begin
            //scbd.check_empty();
            if(scbd.errors) begin
               $display("\n\n\n.............FAILED...............\n\n\n");
               $display("TOTAL NUMBER OF ERRORS: %0d",scbd.errors);
            end
            else
            $display("\n\n\n.............PASSED...............\n\n\n");
           $finish(1);
         end
         else
         
       if (counter==watchdog) begin
            //scbd.check_empty();
            $display("Error! Test ended due to watchdog.\n");
            //$display("Total number of errors: %0d", scbd.errors);
            $finish(1);
         end
         else begin
           @(posedge top.clk);
           counter++;
         end
      end																		  
   endtask: testend
   
   task run();
      //this is where the environment resets the DUT
      units[0].run;

      for(int i=1;i<units.size();i++) begin
         fork
            
            automatic int k=i;
            begin
              units[k].run();
            end
         join_none
      end

	  this.testend();

   endtask: run

endclass: am2940_environment