## uvm_object vs uvm_component

### uvm_object
**uvm_object** are *transient*, just like transactions they are created and dissapeared when they are no longer in use. 

the primary role of uvm_object is to define a set of common functions:
- print
- copy
- compare
- record


### uvm_component
**uvm_component** is *static* they are created during build_phase() and persist throughout the simulation. 