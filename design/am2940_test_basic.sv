class test_addr;
  task test(virtual input_intf input_interface, virtual output_intf output_interface);

    am2940_environment env;

    env = new(20, "Environment", 25);
    env.run();

  endtask
endclass : test_addr
