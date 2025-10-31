class slave_driver extends uvm_driver #(slave_xtn);
`uvm_component_utils(slave_driver)

virtual bus_if.SLV_DRV_MP vif;
slave_config s_cfg;


extern function new(string name="slave_driver", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut();
endclass

function slave_driver::new(string name="slave_driver", uvm_component parent);
super.new(name,parent);
endfunction

function void slave_driver::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(slave_config)::get(this,"","slave_config",s_cfg))
`uvm_fatal("build_phase","getting failed")
endfunction	

function void slave_driver::connect_phase(uvm_phase phase);
vif=s_cfg.vif;
endfunction

task slave_driver::run_phase(uvm_phase phase);
super.run_phase(phase);
forever
begin
send_to_dut();
end
endtask


task slave_driver::send_to_dut();

while(vif.slv_drv_cb.Pselx!==(1||2||4||8))
@(vif.slv_drv_cb);

if(vif.slv_drv_cb.Pwrite==0)
vif.slv_drv_cb.Prdata<=$random;
@(vif.slv_drv_cb);

endtask
