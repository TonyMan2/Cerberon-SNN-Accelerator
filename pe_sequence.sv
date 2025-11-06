class pe_sequence extends uvm_sequencer
    `uvm_object_utils(pe_sequence) //sequence is not a object not a component

    //uvm objects dont have parent classes
    function new(string name = "pe_sequence")
        super.new(name);
        `uvm_info("pe_sequence", "sequence constructor", UVM_MEDIUM)
    endfunction
endclass