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

