class pe_sequencer extends uvm_sequencer;
    
    `uvm_component_utils(pe_sequencer)
    function new(string name = "pe_sequencer", uvm_component parent)
        super.new(name,parent);
        `uvm_info("pe_sequencer", "sequencer constructor", UVM_MEDIUM)
    endfunction
endclass