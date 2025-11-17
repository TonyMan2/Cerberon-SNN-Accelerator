class pe_driver extends uvm_driver;

`uvm_component_utils(pe_driver)

    function new(string name = "pe_driver", uvm_component parent);
        super.new(name,parent);
        `uvm_info("pe_driver", "pe constructor", UVM_MEDIUM)
    endfunction //new()
endclass //pe_driver extendsuvm_drivers