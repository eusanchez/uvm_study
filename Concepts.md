## uvm_object vs uvm_component

### uvm_object
**uvm_object** are *transient*, just like transactions they are created and dissapeared when they are no longer in use. They don't have phases. 

the primary role of uvm_object is to define a set of common functions:
- print
- copy
- compare
- record

In our environment some clear examples are:
1. uvm_sequence
2. uvm_transaction


### uvm_component
**uvm_component** is *static* they are created during build_phase() and persist throughout the simulation. They participate in phases, constructed with *new(name,parent)*

In our environment some clear examples are:
1. uvm_driver
2. uvm_monitor
3. etc...

## UVM Phases

uvm_component have phases, they cannot proceed to the next phase until all componenets finish their execution in the current phase. UVM Phases acts as a synchronizing mechanism.

### Function and Tasks.

Each phase can be either a function or a task. Methods that do not consume simulation time are *functions* and methods that consume simulation time are *tasks*. 

Example of a function:

```
function new(string name, uvm_component parent);
    super.new(name, parent);
    imp = new("imp", this);
endfunction
```

Example of a task:
```
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
```

### The 3 categories of phases
1. Build time phases
2. Run time phases
3. Clean-up phases

