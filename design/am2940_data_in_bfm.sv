class am2940_data_in_bfm extends am2940_base_unit;

  am2940_packet packet_mbox;
  virtual input_intf.drv smp_drv;
  virtual input_intf.rcv smp_rcv;

  function new(am2940_packet packet_mbox,
               virtual input_intf.drv smp_drv,
               virtual input_intf.rcv smp_rcv,
               string name,
               int id);
    super.new(name,id);
    this.packet_mbox = packet_mbox;
    this.smp_drv = smp_drv;
    this.smp_rcv = smp_rcv;
  endfunction : new

  task run();
    am2940_data_packet curent_packet;

    $display("[%0t] %s Starting to drive packets...", $time, super.name);

    forever begin
      packet_mbox.get(curent_packet);
      drive_packet(curent_packet);
      curent_packet.display("DATA IN BFM");
    end
  endtask : run


  task drive_packet(am2940_data_packet pkt);
    //repeat (pkt.delay) @(smp_rcv.rcv_cb);
	
    smp_drv.drv_cb.instr <= pkt.instruction;
    smp_drv.drv_cb.datain <= pkt.data;
    @(smp_rcv.rcv_cb);
  endtask : drive_packet

endclass : am2940_data_in_bfm
