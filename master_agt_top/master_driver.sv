class master_driver extends uvm_driver #(master_xtn);
`uvm_component_utils(master_driver)

virtual bus_if.MST_DRV_MP vif;
master_config m_cfg;


extern function new(string name="master_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(master_xtn req);
endclass

function master_driver::new(string name="master_driver", uvm_component parent);
super.new(name,parent);
endfunction

function void master_driver::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(master_config)::get(this,"","master_config",m_cfg))
`uvm_fatal("build_phase","getting failed")	
endfunction

function void master_driver::connect_phase(uvm_phase phase);
vif=m_cfg.vif;
endfunction

task master_driver::run_phase(uvm_phase phase);
super.run_phase(phase);

@(vif.mst_drv_cb);
vif.mst_drv_cb.Hresetn<=1'b0;
@(vif.mst_drv_cb);
vif.mst_drv_cb.Hresetn<=1'b1;

forever 
begin
req=master_xtn::type_id::create("req");
seq_item_port.get_next_item(req);
send_to_dut(req);
seq_item_port.item_done(req);
end
endtask

task master_driver::send_to_dut(master_xtn req);
while(vif.mst_drv_cb.Hreadyout!==1)
@(vif.mst_drv_cb);

vif.mst_drv_cb.Haddr<=req.Haddr;
vif.mst_drv_cb.Hsize<=req.Hsize;
vif.mst_drv_cb.Hwrite<=req.Hwrite;
vif.mst_drv_cb.Htrans<=req.Htrans;
vif.mst_drv_cb.Hreadyin<=1'b1;

@(vif.mst_drv_cb);

while(vif.mst_drv_cb.Hreadyout!==1)
@(vif.mst_drv_cb);
vif.mst_drv_cb.Hwdata<=req.Hwdata;

req.print();
endtask













