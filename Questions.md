# Questions

1. When and how would you perform a factory override?


2. Describe the differences between components and objects in UVM.

3. How do you connect a DUT interface to a UVM component?
    - Using uvm_config_db and a virtual interface.

4. Which UVM phase do you integrate to for phase runs for test cases?
    - run_phase

5. How would you reduce the time it takes to initiate a UVM run phase?
    - Don't spend time in run_phase building or configuring, for that there is build_phase or connect_phase. Avoid doing unnecessary wait().

6. How do you use simulations to develop functioning components?

7. What approach would you take to run a test case for a digital data storage device?

8. When is it advantageous to implement a class-based testbench?

9. How do you ensure the functionality of util macros within component infrastructure?

10. What steps do you take to create a sequence item?

11. How do you program hierarchical status communication within an object mechanism?

12. How do you initiate new sequence requests within a driver?

13. What are interfaces and why are they useful?
    - Interfaces encapsulates communication signals, and make the code more organizable, readable and reusable.

14. Difference between logic, reg, and wire.
    - Wire is used for connections, reg register used in Verilog and saves values, logic is the replace of a reg in SystemVerilog.

15. What happens if you forget an else in combinational logic?
    - A latch will be inferred, you will probably have the same previous value. This in some cases could case an X propagation in simulation. 

16. Can you explain pass-by-value vs pass-by-reference?
    - pass-by-value is a copy of the value passed to the function or task, changes do not affect the original variable. pass-by-reference is the original value is passed. 

17. What are analysis ports used for?
    - Analysis port re used to bradcast transactions from monitors to scoreboards and coverage components in a non-blocking, decoupled way. 

18. What is the UVM factory?
    - Is a mechanism that controls how UVM objects and components are created, allowing modification without actually changing the code. It helps reuse environments, without editing env code. 

    It not only contains all the registered base types, but also the new register types that are registered in the uvm code. 

19. Difference between immediate and concurrent assertions.
    - Immediate assertions, are checked at the moment they are executed, live insidee procedural code. 
    ```
    always_ff @(posedge clk) begin
        assert (req != 1'bx)
            else $error ("req is X");
    end
    ```
    Concurrent assetions are through the whole simulation. 
    ```
    property assert_gnt;
        @(posedge clk) req |-> ##[1:3] gnt;
    endproperty

    assert property(assert_gnt);
    ```

