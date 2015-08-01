//
//  Module: FIFO agent configuration
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
`ifndef FIFO_AGENT_CONFIG_SVH
`define FIFO_AGENT_CONFIG_SVH

class fifo_agent_config extends uvm_object;

// UVM factory registration macro
//
`uvm_object_utils(fifo_agent_config)

// Virtual interfaces
virtual fifo_read_if read_if;
virtual fifo_write_if write_if;

extern function new(string name = "fifo_agent_config");

endclass: fifo_agent_config

function fifo_agent_config::new(string name = "fifo_agent_config");
  super.new(name);
endfunction: new

`endif // FIFO_AGENT_CONFIG_SVH
