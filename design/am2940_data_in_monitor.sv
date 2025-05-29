class am2940_data_in_monitor extends am2940_base_unit;

  am2940_data_packet curent_packet;

  //declare the necessary modports and mailbox
  virtual input_intf.rcv smp;
  am2940_packet packet_mbox;
  int pkt_id;

  function new(virtual input_intf.rcv smp, am2940_packet packet_mbox, string name, int id);
    super.new(name, id);
    //LAB: tie the modports and mailbox with the ones sent by the environment as parameters
    this.smp = smp;
    this.packet_mbox = packet_mbox;
    pkt_id = 0;
  endfunction : new

task run();
  logic [7:0] prev_instr = 'x;
  logic [7:0] prev_data  = 'x;

  forever begin
    @(smp.rcv_cb);

    // Only sample when the values change (simple form of edge detection)
    if ((smp.rcv_cb.instr !== prev_instr) || (smp.rcv_cb.datain !== prev_data)) begin
      curent_packet = new;
      curent_packet.instruction = smp.rcv_cb.instr;
      curent_packet.data        = smp.rcv_cb.datain;

      void'(curent_packet.display("DATA_IN_MONITOR:"));
      packet_mbox.put(curent_packet);
      pkt_id++;

      prev_instr = smp.rcv_cb.instr;
      prev_data  = smp.rcv_cb.datain;
    end
  end
endtask : run


endclass : am2940_data_in_monitor
