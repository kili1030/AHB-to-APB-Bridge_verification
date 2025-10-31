package test_pkg;

import uvm_pkg::*;

`include "uvm_macros.svh"

`include "master_config.sv"
`include "slave_config.sv"
`include "env_config.sv"
`include "master_xtn.sv"
`include "slave_xtn.sv"
`include "master_seqs.sv"

`include "master_driver.sv"
`include "master_monitor.sv"
`include "master_sequencer.sv"
`include "master_agent.sv"
`include "master_agt_top.sv"

`include "slave_driver.sv"
`include "slave_monitor.sv"
`include "slave_sequencer.sv"
`include "slave_agent.sv"
`include "slave_agt_top.sv"

`include "virtual_seqr.sv"
`include "scoreboard.sv"
`include "environment.sv"
`include "test_lib.sv"

endpackage
