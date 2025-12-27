//========================
  // Monitor
  //========================
  class add_monitor extends uvm_component;
    `uvm_component_utils(add_monitor)
    virtual dut_if vif;

    uvm_analysis_port #(add_txn) ap;

    function new(string name, uvm_component parent);
      super.new(name, parent);
      ap = new("ap", this);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF", "Monitor: virtual interface not set")
    endfunction

    task run_phase(uvm_phase phase);
      add_txn tr;
      forever begin
        @(posedge vif.clk);
        if (vif.rst_n) begin
          tr = add_txn::type_id::create("tr");
          tr.a = vif.a;
          tr.b = vif.b;
          tr.y = vif.y;
          ap.write(tr);
        end
      end
    endtask
  endclass
