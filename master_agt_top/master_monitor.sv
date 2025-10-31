class master_monitor extends uvm_monitor;
`uvm_component_utils(master_monitor);

virtual bus_if.MST_MON_MP vif;
master_config m_cfg;
uvm_analysis_port #(master_xtn) ahb_port;


extern function new(string name="master_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();


endclass

function master_monitor::new(string name="master_monitor", uvm_component parent);
super.new(name,parent);
endfunction

function void master_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
`uvm_fatal("build_phase","getting failed")

ahb_port=new("ahb_port",this);	
endfunction

function void master_monitor::connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction


task master_monitor::run_phase(uvm_phase phase);
super.run_phase(phase);
forever
begin
collect_data();
end
endtask

task master_monitor::collect_data();
master_xtn xtn;
xtn=master_xtn::type_id::create("xtn");

while(vif.mst_mon_cb.Hreadyout!==1)
@(vif.mst_mon_cb);

xtn.Haddr=vif.mst_mon_cb.Haddr;
xtn.Hsize=vif.mst_mon_cb.Hsize;
xtn.Hwrite=vif.mst_mon_cb.Hwrite;
xtn.Hreadyin=vif.mst_mon_cb.Hreadyin;
xtn.Htrans=vif.mst_mon_cb.Htrans;
@(vif.mst_mon_cb);

while(vif.mst_mon_cb.Hreadyout!==1)
@(vif.mst_mon_cb);
if(xtn.Hwrite)
xtn.Hwdata=vif.mst_mon_cb.Hwdata;
else
xtn.Hrdata=vif.mst_mon_cb.Hrdata;

xtn.print();


ahb_port.write(xtn);
endtask



