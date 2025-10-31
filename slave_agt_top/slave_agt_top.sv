class slave_agt_top extends uvm_env;
 
`uvm_component_utils(slave_agt_top)
slave_agent s_agt[];
env_config e_cfg;

extern function new(string name = "slave_agt_top" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);
endclass

function slave_agt_top::new(string name = "slave_agt_top" , uvm_component parent);
super.new(name,parent);
endfunction

function void slave_agt_top::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
`uvm_fatal("GETTING","getting_failed");

s_agt=new[e_cfg.no_of_slave_agt];

foreach(s_agt[i])
begin
s_agt[i]=slave_agent::type_id::create($sformatf("s_agt[%0d]",i),this);
uvm_config_db #(slave_config)::set(this,$sformatf("s_agt[%0d]*",i),"slave_config",e_cfg.s_cfg[i]);
end
endfunction

