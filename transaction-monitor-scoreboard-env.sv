
// How connections from monitor to scoreboard works.

// Transaction class.
class uvm_transaction extends uvm_sequence_item;
    rand bit [7:0] addr;
    rand bit [31:0] data;

    `uvm_object_utils(uvm_transaction);

    function new(string name = "uvm_transaction");
        super.new(name);
    endfunction
endclass


// Monitor class
class my_monitor extends uvm_monitor;
    `uvm_component_utils(my_monitor);

    uvm_analysis_port#(uvm_transaction) ap;

    function new(string name= "my_monitor", uvm_component parent);
        super.new(name, parent);
    endfunction

    function build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endfunction

    task run_phase(uvm_phase phase);
        uvm_transaction tx;
        forever begin
            tx = my_txn::type_id::create("tx");
            ap.write(tx);
        end
    endtask
endclass

// Scoreboard class
class my_scoreboard extends uvm_scoreboard; 
    `uvm_component_utils(my_scoreboard);

    uvm_analysis_imp#(my_txn, my_scoreboard) ap;

    function new(string name="my_scoreboard", uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        ap = new("ap", this);
    endfunction

    function void write(my_transaction tx);
        `uvm_info("SBC", $sformatf("..."), UVM_MEDIUM)
    endfunction
endclass

// Environment class
class my_env extends uvm_env;
    `uvm_component_ultis(my_env);

    my_monitor mon;
    my_scoreboard scb;

    function new(string name= "my_env", uvm_component parent);
        super.new(name,parent);
    endfunction

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);
        mon = my_monitor::type_id::create("mon",this);
        scb = my_scoreboard::type_id::create("scb",this);
    endfunction

    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        mon.ap.connect(scb.ap);
    endfunction

endclass