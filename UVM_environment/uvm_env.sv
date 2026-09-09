//========================
  // Env
  //========================
  class add_env extends uvm_env;
    `uvm_component_utils(add_env)

    add_driver               drv;
    uvm_sequencer #(add_txn) seqr;
    add_monitor              mon;
    add_scoreboard           sb;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      seqr = uvm_sequencer#(add_txn)::type_id::create("seqr", this);
      drv  = add_driver::type_id::create("drv", this);
      mon  = add_monitor::type_id::create("mon", this);
      sb   = add_scoreboard::type_id::create("sb", this);
    endfunction

    function void connect_phase(uvm_phase phase);
      super.connect_phase(phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
      mon.ap.connect(sb.imp);
    endfunction
  endclass