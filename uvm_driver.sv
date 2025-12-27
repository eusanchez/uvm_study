//========================
  // Driver
  //========================
  class add_driver extends uvm_driver #(add_txn);
    `uvm_component_utils(add_driver)
    virtual dut_if vif;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF", "Driver: virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
      add_txn tr;

      // drive defaults
      vif.a <= '0;
      vif.b <= '0;

      forever begin
        seq_item_port.get_next_item(tr);

        @(posedge vif.clk);
        vif.a <= tr.a;
        vif.b <= tr.b;

        seq_item_port.item_done();
      end
    endtask
  endclass