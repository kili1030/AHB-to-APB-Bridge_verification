class env_config extends uvm_object;

master_config m_cfg[];
slave_config s_cfg[];

`uvm_object_utils(env_config)

int no_of_master_agt;
int no_of_slave_agt;

extern function new(string name="env_config");
endclass

function env_config::new(string name="env_config");
super.new(name);
endfunction

