//
//  Module: FIFO test
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/28/2015
//  Copyright (C) 2015 Lianghao Yuan

//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation; either version 2 of the License, or
//  (at your option) any later version.

//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.

//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//

`ifndef FIFO_TEST_SVH
`define FIFO_TEST_SVH

class fifo_test extends uvm_test;
// UVM factory registration macro
`uvm_component_utils(fifo_test)

// ------------------------------
// Component members
// ------------------------------
fifo_agent m_agent;
fifo_sequencer m_rd_sequencer;
fifo_sequencer m_wr_sequencer;

fifo_read_seq m_rd_seq;
fifo_write_seq m_wr_seq;

// ------------------------------
// Data members
// ------------------------------
fifo_agent_config m_agent_cfg;

// ------------------------------
// Methods
// ------------------------------
extern function new(string name = "fifo_test", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass: fifo_test
// ------------------------------
// Extern methods
// ------------------------------
function fifo_test::new(string name = "fifo_test", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void fifo_test::build_phase(uvm_phase phase);
  // Build components
  m_agent = fifo_agent::type_id::create("m_agent", this);
  m_agent_cfg = fifo_agent_config::type_id::create("m_agent_cfg");
  if(!uvm_config_db # (virtual fifo_read_if)::get(this, "", "read_if", m_agent_cfg.read_if)) begin
    `uvm_error("build_phase", "Unable to find read_if in uvm_config_db")
  end
  // Configuring output interface one by one
  if(!uvm_config_db # (virtual fifo_write_if)::get(this, "", "write_if", m_agent_cfg.write_if)) begin
    `uvm_error("build_phase", "Unable to find write_if in uvm_config_db")
  end
  uvm_config_db # (fifo_agent_config)::set(this, "m_agent", "fifo_agent_config", m_agent_cfg);
endfunction: build_phase

function void fifo_test::end_of_elaboration_phase(uvm_phase phase);
  m_rd_sequencer = m_agent.m_rd_sequencer;
  m_wr_sequencer = m_agent.m_wr_sequencer;
endfunction: end_of_elaboration_phase

task fifo_test::run_phase(uvm_phase phase);
  m_rd_seq = new("m_rd_seq");
  m_wr_seq = new("m_wr_seq");
  phase.raise_objection(this);
  fork
    m_rd_seq.start(m_rd_sequencer);
    m_wr_seq.start(m_wr_sequencer);
  join
  phase.drop_objection(this);
endtask: run_phase

`endif // FIFO_TEST_SVH

