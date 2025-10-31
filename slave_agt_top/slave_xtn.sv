class slave_xtn extends uvm_sequence_item;

`uvm_object_utils(slave_xtn)

bit Penable,Pwrite;
bit [3:0]Pselx;
bit [31:0]Paddr,Pwdata;
rand bit [31:0]Prdata;

extern function new(string name="slave_xtn");
extern function void do_print(uvm_printer printer);
endclass

function slave_xtn::new(string name="slave_xtn");
super.new(name);
endfunction

function void slave_xtn::do_print(uvm_printer printer);
super.do_print(printer);
 printer.print_field("Penable",this.Penable,1,UVM_DEC);
 printer.print_field("Pwrite",this.Pwrite,1,UVM_DEC);
 printer.print_field("Pselx",this.Pselx,4,UVM_DEC);
 printer.print_field("Paddr",this.Paddr,32,UVM_DEC);
 printer.print_field("Pwdata",this.Pwdata,32,UVM_DEC);
 printer.print_field("Prdata",this.Prdata,32,UVM_DEC);
endfunction





