class master_seqs extends uvm_sequence #(master_xtn);
`uvm_object_utils(master_seqs)

bit [31:0]haddr;
bit [2:0]hburst,hsize;
bit hwrite;
bit [9:0]hlength;

function new(string name="master_seqs");
super.new(name);
endfunction

endclass

//////-----------------single_transfer--------------///////

class single_transfer extends master_seqs;

`uvm_object_utils(single_transfer)

function new(string name="single_transfer");
super.new(name);
endfunction 	       	 														      						       		
task body();
req=master_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {Htrans==2'b10;Hwrite==1;});
finish_item(req);
endtask
endclass

//////-----------------Increment_transfer--------------///////

class incr_transfer extends master_seqs;

`uvm_object_utils(incr_transfer)

function new(string name="incr_transfer");
super.new(name);
endfunction

task body();
req=master_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {Htrans==2'b10; Hburst inside {1,3,5,7};});
finish_item(req);

haddr=req.Haddr;
hwrite=req.Hwrite;
hsize=req.Hsize;
hburst=req.Hburst;
hlength=req.Hlength;

for(int i=1;i<hlength;i++)
begin
start_item(req);
assert(req.randomize() with {Hwrite==hwrite; Hsize==hsize; Hburst==hburst; Htrans==2'b11; Haddr==haddr+(2**hsize);});
finish_item(req);
haddr=req.Haddr;
end
endtask
endclass

//////-----------------Wrap_transfer--------------///////

class wrap_transfer extends master_seqs;

`uvm_object_utils(wrap_transfer)

bit [31:0]start_addr,bound_addr;

function new(string name="wrap_trasnfer");
super.new(name);
endfunction

task body();

req=master_xtn::type_id::create("req");

start_item(req);
req.randomize() with {Htrans==2'b10;Hburst inside {2,4,6};};
finish_item(req);

haddr=req.Haddr;
//htrans=req.Htrans;
hsize=req.Hsize;
hwrite=req.Hwrite;
hlength=req.Hlength;


start_addr= int'(haddr/(hlength*(2**hsize)))*(hlength*(2**hsize));
bound_addr=  start_addr+(2**hsize*(hlength));
haddr=req.Haddr+(2**req.Hsize);

for(int i=1;i<hlength;i++)
begin

if(haddr==bound_addr)
haddr=start_addr;

start_item(req);
assert(req.randomize() with {Haddr==haddr;Hsize==hsize;Hwrite==hwrite;Htrans==2'b11;Hlength==hlength;});
finish_item(req);
haddr=req.Haddr+(2**req.Hsize);

$display("start_addr=%d",start_addr);
$display("boundary=%d",bound_addr);
end
endtask
endclass










