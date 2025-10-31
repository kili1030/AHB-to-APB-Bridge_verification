class test_lib extends uvm_test;

`uvm_component_utils(test_lib)

environment envh;
master_config m_cfg[];
slave_config s_cfg[];
env_config e_cfg;

int no_of_master_agt=1;
int no_of_slave_agt=1;

function new(string name="test_lib",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
e_cfg=env_config::type_id::create("e_cfg",this);

e_cfg.m_cfg=new[no_of_master_agt];
e_cfg.s_cfg=new[no_of_slave_agt];

m_cfg=new[no_of_master_agt];

foreach(m_cfg[i])
begin
m_cfg[i]=master_config::type_id::create($sformatf("m_cfg[%0d]",i),this);

if(!uvm_config_db #(virtual bus_if)::get(this,"","in0",m_cfg[i].vif))
`uvm_fatal("getting","getting_failed")


m_cfg[i].is_active=UVM_ACTIVE;
e_cfg.m_cfg=m_cfg;
end

s_cfg=new[no_of_slave_agt];

foreach(s_cfg[i])
begin
s_cfg[i]=slave_config::type_id::create($sformatf("s_cfg[%0d]",i),this);

if(!uvm_config_db #(virtual bus_if)::get(this,"","in1",s_cfg[i].vif))
`uvm_fatal("getting","getting_failed")


s_cfg[i].is_active=UVM_ACTIVE;
e_cfg.s_cfg=s_cfg;
end


uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);

e_cfg.no_of_master_agt=no_of_master_agt;
e_cfg.no_of_slave_agt=no_of_slave_agt;


envh=environment::type_id::create("envh",this);

endfunction

function void end_of_elaboration_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction
endclass

//////-----------------Single_test--------------///////


class single_test extends test_lib;

`uvm_component_utils(single_test)

single_transfer single_xtn;

function new(string name="single_test",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
single_xtn=single_transfer::type_id::create("single_xtn");
phase.raise_objection(this);
single_xtn.start(envh.m_agt.m_agt[0].m_seqrh);
#20;
phase.drop_objection(this);
endtask

endclass

//////-----------------Increment_test--------------///////


class incr_test extends test_lib;

`uvm_component_utils(incr_test)

incr_transfer inc_xtn;

function new(string name="incr_test",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
inc_xtn=incr_transfer::type_id::create("inc_xtn");
phase.raise_objection(this);
inc_xtn.start(envh.m_agt.m_agt[0].m_seqrh);
phase.drop_objection(this);
endtask
endclass

//////-----------------Wrap_test--------------///////


class wrap_test extends test_lib;

`uvm_component_utils(wrap_test)

wrap_transfer wrap_xtn;

function new(string name="wrap_test",uvm_component parent);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction

task run_phase(uvm_phase phase);
super.run_phase(phase);
wrap_xtn=wrap_transfer::type_id::create("wrap_xtn");
phase.raise_objection(this);
wrap_xtn.start(envh.m_agt.m_agt[0].m_seqrh);
phase.drop_objection(this);
endtask
endclass



