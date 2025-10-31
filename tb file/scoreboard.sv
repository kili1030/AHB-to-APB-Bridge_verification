class scoreboard extends uvm_scoreboard;
`uvm_component_utils(scoreboard)

master_xtn ahb;
slave_xtn apb;
uvm_tlm_analysis_fifo #(master_xtn) ahb_fifo;
uvm_tlm_analysis_fifo #(slave_xtn) apb_fifo;



covergroup ahb_cg;

HADDR: coverpoint ahb.Haddr{
		bins slave1={[32'h8000_0000:32'h8000_03ff]};
		bins slave2={[32'h8400_0000:32'h8400_03ff]};
		bins slave3={[32'h8800_0000:32'h8800_03ff]};
		bins slave4={[32'h8c00_0000:32'h8c00_03ff]};}

HSIZE: coverpoint ahb.Hsize{
		bins one_byte={0};
		bins two_byte={1};
		bins four_byte={2};}

HWRITE: coverpoint ahb.Hwrite{
		bins wriite={1};
		bins read={0};}

HTRANS: coverpoint ahb.Htrans{
		bins idle={2'b00};
		bins busy={2'b01};
		bins non_seq={2'b10};
		bins seq={2'b11};}

cross HADDR,HSIZE,HWRITE,HTRANS;
endgroup


covergroup apb_cg;

PSELX: coverpoint apb.Pselx{
		bins firstt={1};
		bins second={2};
		bins third={4};
		bins fourth={8};}

PADDR: coverpoint apb.Paddr{
		bins slave1={[32'h8000_0000:32'h8000_03ff]};
		bins slave2={[32'h8400_0000:32'h8400_03ff]};
		bins slave3={[32'h8800_0000:32'h8800_03ff]};
		bins slave4={[32'h8c00_0000:32'h8c00_03ff]};}

PWRITE: coverpoint apb.Pwrite{
		bins wriite={1};
		bins read={0};}
	
cross PSELX,PADDR,PWRITE;
endgroup
			

function new(string name="scoreboard", uvm_component parent);
super.new(name,parent);
ahb_cg=new();
apb_cg=new();
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);

ahb_fifo=new("ahb_fifo",this);
apb_fifo=new("apb_fifo",this);

endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);

forever
begin
fork

begin
ahb_fifo.get(ahb);
ahb.print;
ahb_cg.sample;
end

begin
apb_fifo.get(apb);
apb.print;
apb_cg.sample;
end
join
checking(ahb,apb);
end
endtask


task comparing(int Haddr,Paddr,Hdata,Pdata);
if(Haddr==Paddr)
$display("address_matched");
else
begin
$display("address_mismatch");
$display("Haddr=%d,Paddr=%d",Haddr,Paddr);
end

if(Hdata==Pdata)
$display("data_matched");
else
begin
$display("data_mismatch");
$display("Hdata=%d,Pdata=%d",Hdata,Pdata);
end
endtask


task checking(master_xtn ahb, slave_xtn apb);

//----------------write_logic----------------//
if(ahb.Hwrite==1)
begin
if(ahb.Hsize==2'b00)
begin
if(ahb.Haddr[1:0]==2'b00)
comparing(ahb.Haddr,apb.Paddr,ahb.Hwdata[7:0],apb.Pwdata[7:0]);

else if(ahb.Haddr[1:0]==2'b01)
comparing(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:8],apb.Pwdata[7:0]);

else if(ahb.Haddr[1:0]==2'b10)
comparing(ahb.Haddr,apb.Paddr,ahb.Hwdata[23:16],apb.Pwdata[7:0]);

else if(ahb.Haddr[1:0]==2'b11)
comparing(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:24],apb.Pwdata[7:0]);

end

if(ahb.Hsize==2'b01)
begin
if(ahb.Haddr[1:0]==2'b00)
comparing(ahb.Haddr,apb.Paddr,ahb.Hwdata[15:0],apb.Pwdata[15:0]);

else if(ahb.Haddr[1:0]==2'b10)
comparing(ahb.Haddr,apb.Paddr,ahb.Hwdata[31:16],apb.Pwdata[15:0]);
end

if(ahb.Hsize==2'b10);
begin
if(ahb.Haddr[1:0]==2'b00)
comparing(ahb.Haddr,apb.Paddr,ahb.Hwdata,apb.Pwdata);
end
end


//----------------read_logic----------------//


if(ahb.Hwrite==0)
begin
if(ahb.Hsize==2'b00)
begin
if(ahb.Haddr[1:0]==2'b00)
comparing(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[7:0]);

else if(ahb.Haddr[1:0]==2'b01)
comparing(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[15:8]);

else if(ahb.Haddr[1:0]==2'b10)
comparing(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[23:16]);

else if(ahb.Haddr[1:0]==2'b11)
comparing(ahb.Haddr,apb.Paddr,ahb.Hrdata[7:0],apb.Prdata[31:24]);
end

if(ahb.Hsize==2'b01)
begin
if(ahb.Haddr[1:0]==2'b00)
comparing(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:0],apb.Prdata[15:0]);

else if(ahb.Haddr[1:0]==2'b10)
comparing(ahb.Haddr,apb.Paddr,ahb.Hrdata[15:0],apb.Prdata[31:16]);
end

if(ahb.Hsize==2'b10);
begin
if(ahb.Haddr[1:0]==2'b00)
comparing(ahb.Haddr,apb.Paddr,ahb.Hrdata,apb.Prdata);
end
end
endtask
endclass































