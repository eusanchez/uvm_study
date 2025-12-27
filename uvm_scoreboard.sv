//========================
  // Scoreboard
  //========================
  class add_scoreboard extends uvm_component;
    `uvm_component_utils(add_scoreboard)

    uvm_analysis_imp #(add_txn, add_scoreboard) imp;
    
    bit [8:0] exp_q[$];

    function new(string name, uvm_component parent);
      super.new(name, parent);
      imp = new("imp", this);
    endfunction

    function void write(add_txn tr);
      bit [8:0] exp_now;
      bit [8:0] exp_old;
      exp_now = tr.a + tr.b;
      exp_q.push_back(exp_now);
      
      if (exp_q.size() < 2) begin
      `uvm_info("WARMUP",
        $sformatf("Skipping compare (pipeline warmup). a=%0d b=%0d y=%0d", tr.a, tr.b, tr.y),
        UVM_LOW)
      return;
    end

      exp_old = exp_q.pop_front();

      if (tr.y !== exp_old) begin
        `uvm_error("MISMATCH",
                   $sformatf("a=%0d b=%0d exp=%0d got=%0d", tr.a, tr.b, exp_old, tr.y))
      end else begin
        `uvm_info("OK",
          $sformatf("a=%0d b=%0d y=%0d", tr.a, tr.b, tr.y),
          UVM_LOW)
      end
    endfunction
  endclass