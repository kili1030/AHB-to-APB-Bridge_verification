class master_agt_top extends uvm_env;
 
`uvm_component_utils(master_agt_top)
master_agent m_agt[];
env_config e_cfg;

extern function new(string name = "master_agt_top" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);
endclass

function master_agt_top::new(string name = "master_agt_top" , uvm_component parent);
super.new(name,parent);
endfunction

function void master_agt_top::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
`uvm_fatal("GETTING","getting_failed");

m_agt=new[e_cfg.no_of_master_agt];

foreach(m_agt[i])
begin
m_agt[i]=master_agent::type_id::create($sformatf("m_agt[%0d]",i),this);
uvm_config_db #(master_config)::set(this,$sformatf("m_agt[%0d]*",i),"master_config",e_cfg.m_cfg[i]);
end
endfunction

