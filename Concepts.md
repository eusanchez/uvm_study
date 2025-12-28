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
  - build_phase: Create components, get configurations and initialize handles
  - connect_phase: connect TLM ports, wire components together. Used to connect driver <-> sequencer and monitor -> scoreboard.
  - end_of_elaboration_phase: used to display UVM topology and other functions required to be done after connections. 
  - start_of_simulation_phase: set initial run-time configuration or display topology.
2. Run time phases
  - run_phase: clock edges happen. Used for example driver to pull transactions, or driver DUT signals. Ends only when objections are dropped (*phase.raise_objection(this) ... phase.drop_objection(this)*)
3. Clean-up phases
  - extract_phase: collect final results
  - check_phase: final consistency checks
  - report_phase: print summary and error counts. (UVM default implementation automatically)
  - final_phase: used to do last minute operations before exiting the simulation.

### run_phase phases
Either we use a run phase, or we can implement runtime sub-phases.
1. uvm_pre_reset_phase: before reset is asserted
2. *uvm_reset_phase*: reset is asserted
3. uvm_post_reset_phase: after reset is de-asserted
4. uvm_pre_configure_phase: before the DUT is configured by the SW
5. *uvm_configure_phase*: the sw configures the DUT
6. uvm_post_configure_phase: after sw has configured the DUT
7. uvm_pre_main_phase: before the primary test stimulus strats
8. *uvm_main_phase*: primary test stimulus
9. uvm_post_main_phase: after enough of the primary test stimulus
10. uvm_pre_shutdown_phase: before things settle down
11. uvm_shutdown_phase: letting things settle down
12. uvm_post_shutdown_phase: after things have settled down



## Constraints

### Range constraints
Limit values to a range.

```
constraint values_def {
      a inside {[1:20]};
      b inside {[1:20]};
    }
```

### Soft constraints
Is a default that can be overridden by a stronger constraint.
```
constraint c_default soft {
  a inside {[0:100]};
}
```



