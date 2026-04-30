## Levels of observability
1. Black box -> focuses on external behavior
2. White box -> box that focuses on internal behavior 
3. Gray box -> combines black and white box testing partially knows what is internally and partially knows what is externally. (Most common in real practice)

## uvm_object vs uvm_component (UVM util macros)

### uvm_object
**uvm_object** are *transient*, just like transactions they are created and dissapeared when they are no longer in use. They don't have phases. 

the primary role of uvm_object is to define a set of common functions:
- print
- copy
- compare
- record

In our environment some clear examples are:
1. uvm_sequence *-> sequence decides what conditions/scenario should happen*
2. uvm_transaction


### uvm_component
**uvm_component** is *static* they are created during build_phase() and persist throughout the simulation. They participate in phases, constructed with *new(name,parent)*

In our environment some clear examples are:
1. uvm_driver *-> driver decides how those conditions are applied on signals*
2. uvm_monitor
3. etc...

## Factory registration
All uvm_component and uvm_object must be registered with the factory using a pre-defined facotry registration macro. 

Example registration for uvm_object:
```verilog
class sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(reg_seq)
endclass


// For a parametrized class
class param_obj #(int WIDTH = 16) extends uvm_object;

  typedef param_obj #(int WIDTH) obj_p;
  `uvm_object_param_utils(obj_p)

endclass
```

Example registration for uvm_componenet:

```verilog
  class reg_driver extends uvm_driver;
  // factory registration for driver component
  `uvm_component_utils(reg_driver)

endclass

// For parameterized class
class param_env #(int WIDTH = 32, ID = 0) extends uvm_env;
  typedef param_env #(int WIDTH, ID) env_p;
  `uvm_component_param_utils(env_p)

endclass
```

## UVM Phases

uvm_component have phases, they cannot proceed to the next phase until all componenets finish their execution in the current phase. UVM Phases acts as a synchronizing mechanism.

All phases execute at the same time, first all build phases from every component, then all run time phases etc.. ***

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
**Hard Constraints**: Rule over any other constraint. Limit values to a range.

```
constraint values_def {
      a inside {[1:20]};
      b inside {[1:20]};
    }
```

```
constraint value_addr {
  addr[1:0] == 2'b00;
}
```

**Soft Constraints** : Is a default that can be overridden by a stronger constraint.
```
constraint c_default soft {
  a inside {[0:100]};
}
```


## uvm_config_db
UVM global configuration database. Pass information from higher levels of the testbench (top module, test, env) to lower-level UVM components (env, agent, driver...)

Interfaces live in modules, and UVM components are classes, **CLASSES CAN'T DIRECTLY REFERENCE MODULES**, so *uvm_config_db* is the bridge that connects them.

This is composed by *set()* (puts the data in the database) and *get()* (retrieves data).

set():
```
uvm_config_db#(TYPE)::set(context, scope, key, value);
```

get():
```
uvm_config_db#(TYPE)::get(context, scope, key, variable);
```

Arguments:
- TYPE: Data type, usually *virtual my_if*
- context : where the call is made from, usually *null* or *this*.
- scope : who this applies to (hierarchical path)
- key : name of data
- value : the data itself

Example from uvm_monitor.sv using *get()*. 
```
function void build_phase(uvm_phase phase);
      super.build_phase(phase);
      if (!uvm_config_db#(virtual dut_if)::get(this, "", "vif", vif))
        `uvm_fatal("NOVIF", "Monitor: virtual interface not set")
    endfunction
```

The "" means: "Search upward from this component's hierarchy." In other words, using our example context: “From where I am, look upward in the hierarchy and find something called vif.”.

Example from tb_top.sv using *set()*
```
initial begin
    // Provide vif to all components
    uvm_config_db#(virtual dut_if)::set(null, "*", "vif", vif);

    run_test("add_test");
  end
```

## task body() vs task run_phase()

```task body()``` is used in **uvm_sequence**, it describes what transactions to generate.

```task run_phase()``` is used in **uvm_component**, describes how a component behaves over time. 


## seq_item_port.____()

**get_next_item()**

It is the driver pulling the next transaction from the sequencer. It is the exact handshake point between *Sequences* (stimulus intent) and *Driver* (signal-level execution)

**item_done()**


## Coverage

### Code Coverage
This metric is used to determine the degree to which the code has been executed by a set of test cases. Code coverage is generated using specialized tools that track signals and statements in the RTL code that have been executed during simulation. 

The simulation tool uses a coverage database to keep track of which part of the design have been exercised during simulation. Once completed coverage data is analyzed to determine different metrics like: branch, condition expression and toggle coverage. 

Types of RTL coverage:
- Statement coverge
- Branch coverage
- Condition coverage
- Expression coverage
- Toggle coverage
- Path Coverage
- Finite State Machine (FSM) coverage

Code coverage is automatically extracted by the simulator tool from the design code without requiring any user-defined constructs. 

### Functional Coverage 
Measures how much of the design specification or inteded functionality has been tested. 

Functional coverage is defined using *covergroups, coverpoints* and *bins* that specify which values, ranges, or conditions of signals and variables are important for verification. 

Ex: For testing an ALU opcode signal, you would create a coverpoint for that signal and define bins for each valid opcode value that should be exercised.

#### Basic Covergroup Syntaxis

```verilog
covergroup cg @(posedge clk);
  c1: coverpoint addr {
    bins b1 = {0, 2, 7};              // Single bin for values 0, 2, or 7
    bins b2[3] = {11:20};             // Three bins splitting range 11-20
    bins b3 = {[30:40], [50:60], 77}; // One bin for multiple ranges
    bins b4[] = {160, 170, 180};      // Three separate bins (auto-split)
    bins b5 = {200:$};                // Bin for 200 to max value
    bins b6 = default;                // Catches uncovered values
  }
endgroup
```

There also exist the posibility where no bins are created:

```verilog
bit [2:0] addr;  // 3-bit signal

covergroup cg @(posedge clk);
  c1: coverpoint addr;  // No explicit bins
endgroup
```

In this specific case, SystemVerilog will automatically create bins for you. The number of automatic bins created depends on variable's bit width and ```auto_bin_max``` limit, the limit is set by default to max of 64 bins. 

In the case above the automatically create bins equivalent to:

```verilog
coverpoint addr {
  bins auto[8] = {0, 1, 2, 3, 4, 5, 6, 7};
}
```

Also there is the option to create this bins without the ```@(posedge clk)```.

Example:
```verilog
covergroup cov_grp;
  cov_p1: coverpoint addr;
  cov_p2: coverpoint data;
endgroup

cov_grp cov_inst = new();

initial begin
  cov_inst.start();
  
  // Sample manually when needed
  addr = 8'h10;
  data = 8'hFF;
  cov_inst.sample();  // Explicit sampling
  
  addr = 8'h20;
  data = 8'hAA;
  cov_inst.sample();  // Sample again
end
```

Where you must explicitly call the ```.sample()``` to trigger the covergroup, as well as ```.start()``` to enable the coverage collection.

There is also the transition bins, capture sequences of value susing the ```=>``` operator.

```verilog
covergroup cg @(posedge clk);
  c1: coverpoint addr {
    bins b1 = (10 => 20 => 30);           // Sequence 10→20→30
    bins b2[] = (40 => 50), (80 => 90 => 100 => 120); // The [] means to create separate bins for each transition sequence rather than grouping them into a single bin.
    bins b3 = (1, 5 => 6, 7);             // 1→6, 1→7, 5→6, or 5→7
  }
endgroup
```

Syntax monitor specific value transitions rather than individual states.

There is also the posibility of doing a coverpoint using an ```iff``` in a coverpoint.

```verilog 
cp_pwrite : coverpoint pwrite iff (state==ACCESS);
```

**THE covergroup_name covergroup_name_inst = new(); IS ALWAYS REQUIRED.**

**Note:** *Code coverage adopts an implementation view while functional coverage takes a specification view.*

## UVM Components

### Environment
The higher-level component that integrates one or more agents along with other key verification componenets. Besides the agent, it include the *scoreboard*.

Also contain coverage collectors to mesure how throughly the DUT has been tested.

### Scoreboard
Compares DUT's actual outputs with expected results to identify mistmatches.

### Agent

An agent can be configured to operate in **active mode** (generating stimuli and monitoring outputs) or **passive mode** (only monitoring outputs). 

