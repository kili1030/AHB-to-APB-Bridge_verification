class environment extends uvm_env;

`uvm_component_utils(environment)
scoreboard sb;
master_agt_top m_agt;
slave_agt_top s_agt;
env_config e_cfg;
virtual_seqr v_seqrh;

extern function new(string name="environment",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function environment::new(string name="environment",uvm_component parent);
super.new(name,parent);
endfunction

function void environment::build_phase(uvm_phase phase);
super.build_phase(phase);
m_agt=master_agt_top::type_id::create("m_agt",this);
s_agt=slave_agt_top::type_id::create("s_agt",this);
sb=scoreboard::type_id::create("sb",this);
v_seqrh=virtual_seqr::type_id::create("v_seqrh",this);
endfunction

function void environment::connect_phase(uvm_phase phase);
m_agt.m_agt[0].m_monh.ahb_port.connect(sb.ahb_fifo.analysis_export);
s_agt.s_agt[0].s_monh.apb_port.connect(sb.apb_fifo.analysis_export);
endfunction






