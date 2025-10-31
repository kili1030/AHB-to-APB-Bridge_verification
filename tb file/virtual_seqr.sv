class virtual_seqr extends uvm_sequencer #(uvm_sequence_item);

`uvm_component_utils(virtual_seqr)

env_config e_cfg;
master_sequencer m_seqrh[];
slave_sequencer s_seqrh[];

extern function new(string name="virtual_seqr",uvm_component parent);
extern function void build_phase(uvm_phase phase);
endclass

function virtual_seqr::new(string name="virtual_seqr",uvm_component parent);
super.new(name,parent);
endfunction

function void virtual_seqr::build_phase(uvm_phase phase);
super.build_phase(phase);
 if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
	`uvm_fatal("CONFIG","getting_failed")

m_seqrh=new[e_cfg.no_of_master_agt];
s_seqrh=new[e_cfg.no_of_slave_agt];
endfunction

