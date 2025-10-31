class master_xtn extends uvm_sequence_item;

`uvm_object_utils(master_xtn)

rand bit [31:0] Haddr,Hwdata;
rand bit [2:0]Hsize,Hburst;
rand bit [1:0]Htrans;
rand bit Hwrite;
rand bit [9:0]Hlength;
bit Hreadyin,Hreadyout,Hresetn;
bit [31:0]Hrdata;
bit [1:0]Hresp;

constraint VALID_ADDR{Haddr inside {[32'h8000_0000:32'h8000_03ff],
				[32'h8400_0000:32'h8400_03ff],
				[32'h8800_0000:32'h8800_03ff],
				[32'h8c00_0000:32'h8c00_03ff]};}

constraint ALIGNED_ADDR {Hsize==1 ->(Haddr%2==0); Hsize==2->(Haddr%4==0);}

constraint BOUNDARY {(Haddr%1024)+(2**Hsize)*Hlength <=1023;}

constraint HSIZE {Hsize inside {0,1,2};}

constraint LENGTH {(Hburst==0)->Hlength==1; 
		(Hburst==2)->Hlength==4; 
		(Hburst==3)->Hlength==4; 
		(Hburst==4)->Hlength==8; 
		(Hburst==5)->Hlength==8; 
		(Hburst==6)->Hlength==16; 
		(Hburst==7)->Hlength==16;}

extern function new(string name="master_xtn");
extern function void do_print(uvm_printer printer);
endclass

function master_xtn::new(string name="master_xtn");
super.new(name);
endfunction

function void master_xtn::do_print(uvm_printer printer);
super.do_print(printer);
 printer.print_field("Haddr",this.Haddr,32,UVM_DEC);
 printer.print_field("Hwdata",this.Hwdata,32,UVM_DEC);
 printer.print_field("Hsize",this.Hsize,3,UVM_DEC);
 printer.print_field("Hburst",this.Hburst,3,UVM_DEC);
 printer.print_field("Htrans",this.Htrans,2,UVM_DEC);
 printer.print_field("Hwrite",this.Hwrite,1,UVM_DEC);
 printer.print_field("Hlength",this.Hlength,10,UVM_DEC);
 printer.print_field("Hreadyin",this.Hreadyin,1,UVM_DEC);
 printer.print_field("Hreadyout",this.Hreadyout,1,UVM_DEC);
 printer.print_field("Hresetn",this.Hresetn,1,UVM_DEC);
 printer.print_field("Hrdata",this.Hrdata,32,UVM_DEC);
 printer.print_field("Hresp",this.Hresp,2,UVM_DEC);
endfunction




