//========================
  // Transaction
  //========================
  class add_txn extends uvm_sequence_item;
    rand bit [7:0] a;
    rand bit [7:0] b;
         bit [8:0] y; // observed
    
    constraint values_def {
      a inside {[1:20]};
      b inside {[1:20]};
    }
    
    `uvm_object_utils_begin(add_txn)
      `uvm_field_int(a, UVM_ALL_ON)
      `uvm_field_int(b, UVM_ALL_ON)
      `uvm_field_int(y, UVM_ALL_ON)
    `uvm_object_utils_end

    function new(string name="add_txn");
      super.new(name);
    endfunction
  endclass

