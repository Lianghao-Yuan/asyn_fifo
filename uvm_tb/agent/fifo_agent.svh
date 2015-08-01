//
//  Module: FIFO agent 
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
`ifndef FIFO_AGENT_SVH
`define FIFO_AGENT_SVH

class fifo_agent extends uvm_agent;
// UVM factory registration macro
`uvm_component_utils(fifo_agent)

// ---------------------------------
// Data members
// ---------------------------------
fifo_agent_config m_cfg;
// ---------------------------------
// Component members
// ---------------------------------
fifo_sequencer m_rd_sequencer;
fifo_sequencer m_wr_sequencer;
read_driver m_rd_driver;
write_driver m_wr_driver;
fifo_scoreboard m_scoreboard;
// ---------------------------------
// Methods
// ---------------------------------
extern function new(string name = "fifo_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass: fifo_agent
// ---------------------------------
// Extern methods
// ---------------------------------
function fifo_agent::new(string name = "fifo_agent", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void fifo_agent::build_phase(uvm_phase phase);
  // Retrieve configuration object
  if(!uvm_config_db # (fifo_agent_config)::get(this, "", "fifo_agent_config", m_cfg)) begin
    `uvm_error("build_phase", "Unable to find fifo_agent_config in uvm_config_db")
  end
  // Build components
  m_rd_sequencer = fifo_sequencer::type_id::create("m_rd_sequencer", this);
  m_wr_sequencer = fifo_sequencer::type_id::create("m_wr_sequencer", this);
  m_rd_driver = read_driver::type_id::create("m_rd_driver", this);
  m_wr_driver = write_driver::type_id::create("m_wr_driver", this);
  m_scoreboard = fifo_scoreboard::type_id::create("m_scoreboard", this);
endfunction: build_phase

function void fifo_agent::connect_phase(uvm_phase phase);
  // Pass interfaces
  m_rd_driver.read_if = m_cfg.read_if;
  m_wr_driver.write_if = m_cfg.write_if;
  
  // Connect driver
  m_rd_driver.seq_item_port.connect(m_rd_sequencer.seq_item_export);
  m_wr_driver.seq_item_port.connect(m_wr_sequencer.seq_item_export); 
  m_rd_driver.rd_driver_ap.connect(m_scoreboard.rd_export);
  m_wr_driver.wr_driver_ap.connect(m_scoreboard.wr_export);
  
endfunction: connect_phase

`endif // SWITCH_AGENT_SVH

