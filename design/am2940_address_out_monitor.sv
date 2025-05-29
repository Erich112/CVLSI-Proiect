class am2940_address_out_monitor extends am2940_base_unit;

  //declare the necessary modports, mailbox and variables
  int port_id;
  am2940_data_packet curent_packet;
  virtual output_intf.rcv smp;
  am2940_packet packet_mbox;
  int pkt_id;

  function new (int port_id, virtual output_intf.rcv smp,
                am2940_packet packet_mbox,
                string name,
                int id);
    super.new(name, id);
    //LAB: initialize the class fields
    this.port_id = port_id;
    this.smp = smp;
    this.packet_mbox = packet_mbox;
    pkt_id = 0;
  endfunction : new

  task run();
    logic [7:0] prev_addr = 'x;
    logic [7:0] prev_data  = 'x;
    forever begin
      @(smp.rcv_cb);
      if ((smp.rcv_cb.address !== prev_addr) || (smp.rcv_cb.dataout !== prev_data)) begin
        curent_packet = new;
        curent_packet.data = smp.rcv_cb.dataout;
        curent_packet.instruction = 8'h7; // placeholder if no output instr
        curent_packet.id = pkt_id;
        void'(curent_packet.display($psprintf("CHANNEL_OUT_MONITOR%0d", id)));
        prev_addr = smp.rcv_cb.address;
        prev_data = smp.rcv_cb.dataout;
        packet_mbox.put(curent_packet);
        pkt_id++;
      end
    end
  endtask : run


endclass : svbt_channel_out_monitor