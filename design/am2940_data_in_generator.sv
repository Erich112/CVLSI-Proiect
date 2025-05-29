class am2940_data_in_generator extends am2940_base_unit;

  int max_number_of_packets;
  am2940_packet packet_mbox;
  am2940_data_packet curent_packet;
  int pkts_counter;

  function new(am2940_packet packet_mbox,
               int max_number_of_packets,
               string name,
               int id);
    super.new(name,id);
    curent_packet = new;
    this.packet_mbox = packet_mbox;
    this.max_number_of_packets = max_number_of_packets;
  endfunction : new

  task run();
    am2940_data_packet pkt2send;

    $display("[%0t] %s Starting to generate %0d packets...", $time,
             super.name, max_number_of_packets);

    while (pkts_counter < max_number_of_packets) begin
      pkt2send = get_packet(pkts_counter);
      packet_mbox.put(pkt2send);
      pkts_counter++;
      pkt2send.display("DATA IN GEN");
    end

  endtask : run

  function am2940_data_packet get_packet(int id);
    assert (this.curent_packet.randomize()) else $error("Contradiction!");
    curent_packet.id = id;
    get_packet = curent_packet.copy();
    return get_packet;
  endfunction : get_packet

endclass : am2940_data_in_generator
