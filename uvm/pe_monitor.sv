class pe_monitor extends uvm_monitor;
    `uvm_component_utils(pe_monitor)
    function new(string name = "pe_monitor", uvm_component parent);
        super.new(name, parent);
        `uvm_info("pe_monitor", "pe_monitor constructor", UVM_MEDIUM)
        
    endfunction //new()
endclass //pe_monitor extends uvm_monitor
 