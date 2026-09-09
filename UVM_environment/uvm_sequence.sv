//========================
  // Sequence
  //========================
  class add_seq extends uvm_sequence #(add_txn);
    `uvm_object_utils(add_seq)

    int unsigned n_items = 10;

    function new(string name="add_seq");
      super.new(name);
    endfunction

    task body();
      add_txn tr;
      repeat (n_items) begin
        tr = add_txn::type_id::create("tr");
        start_item(tr);
        assert(tr.randomize());
        finish_item(tr);
      end
    endtask
  endclass