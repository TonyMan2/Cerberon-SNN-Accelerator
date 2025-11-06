class pe_test extends uvm_test;
    `uvm_component_utils(pe_test)

    //constructor function new( string name == " name of class", parent class)
    function new(string name = "pe_test" , uvm_component parent );
        super.new(name,parent)
        
        //prints out the message "constructor", the first part is the id(can use to print out what class its from)
        //UVM_MEDIUM is the verbosity
        `uvm_info("Test Class", "Test constructor", UVM_MEDIUM)
    endfunction //new()
endclass //pe_test extends uvm_test