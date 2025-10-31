class slave_monitor extends uvm_monitor;
`uvm_component_utils(slave_monitor);

virtual bus_if.SLV_MON_MP vif;
slave_config s_cfg;
uvm_analysis_port #(slave_xtn) apb_port;



extern function new(string name="slave_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();
endclass

function slave_monitor::new(string name="slave_monitor", uvm_component parent);
super.new(name,parent);
endfunction

function void slave_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg))
`uvm_fatal("build_phase","getting failed")

apb_port=new("apb_port",this);	
endfunction

function void slave_monitor::connect_phase(uvm_phase phase);
vif=s_cfg.vif;
endfunction


task slave_monitor::run_phase(uvm_phase phase);
super.run_phase(phase);
forever
begin
collect_data();
end
endtask

task slave_monitor::collect_data();
slave_xtn xtn;
xtn=slave_xtn::type_id::create("xtn");

while(vif.slv_mon_cb.Penable!==1)
@(vif.slv_mon_cb);

$display("sadashdbashdbashdbad");

xtn.Paddr=vif.slv_mon_cb.Paddr;
xtn.Pselx=vif.slv_mon_cb.Pselx;
xtn.Penable=vif.slv_mon_cb.Penable;
xtn.Pwrite=vif.slv_mon_cb.Pwrite;

if(vif.slv_mon_cb.Pwrite)
xtn.Pwdata=vif.slv_mon_cb.Pwdata;
else
xtn.Prdata=vif.slv_mon_cb.Prdata;
@(vif.slv_mon_cb);

xtn.print();
apb_port.write(xtn);
endtask





