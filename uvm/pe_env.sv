class pe_env extends uvm_env;
    `uvm_component_utils(pe_env)

    //standard constructor
    function new(string name = "pe_env", uvm_component parent);
        super.new(name, parent);
        `uvm_info("Env class", "env constructor", UVM_MEDIUM)`
    endfunction //new()
endclass //pe_env extends superClass