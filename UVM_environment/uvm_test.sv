//========================
  // Test
  //========================
  class add_test extends uvm_test;
    `uvm_component_utils(add_test)

    add_env env;

    function new(string name, uvm_component parent);
      super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      env = add_env::type_id::create("env", this);
    endfunction

    task run_phase(uvm_phase phase);
      add_seq seq;
      phase.raise_objection(this);

      seq = add_seq::type_id::create("seq");
      seq.n_items = 20;
      seq.start(env.seqr);

      repeat (3) @(posedge env.drv.vif.clk);

      phase.drop_objection(this);
    endtask
  endclass