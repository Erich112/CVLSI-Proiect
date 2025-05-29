class am2940_scoreboard extends am2940_base_unit;
  am2940_packet data_in_mon;
  am2940_packet addr_out_mon;
  int errors;
  int total_packets;
  function new(string name,
               int id,
               am2940_packet data_in_mon,
               am2940_packet addr_out_mon);
    super.new(name, id);
    this.data_in_mon = data_in_mon;
    this.addr_out_mon   = addr_out_mon;
    errors = 0;
    this.total_packets = 0;
  endfunction

  task run();
    am2940_data_packet exp_pkt, act_pkt;
    forever begin
      data_in_mon.get(exp_pkt);
      addr_out_mon.get(act_pkt);

      if (exp_pkt.data !== act_pkt.data) begin
        $display("[%0t] SCOREBOARD MISMATCH:\n	EXPECT datain=%0h\n		GOT datain=%0h",
                 $time,
                 exp_pkt.data,
                 act_pkt.data);
        errors++;
      end 
      else 
        begin
          $display("[%0t] SCOREBOARD MATCH: datain=%0h",
                   $time,
                   exp_pkt.data);
          total_packets++;
        end
    end
  endtask

endclass : am2940_scoreboard