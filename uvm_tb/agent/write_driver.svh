//
//  Module: Write driver
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
`ifndef WRITE_DRIVER_SVH
`define WRITE_DRIVER_SVH

class write_driver extends uvm_driver # (data_seq_item);

// UVM factory registration macros
//
`uvm_component_utils(write_driver)

// Virtual interfaces
virtual fifo_write_if write_if;

// Analysis port: driver to scoreboard
uvm_analysis_port #(data_seq_item) wr_driver_ap;

// ----------------------
// Methods
// ----------------------
extern function new(string name = "write_driver", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task drive(data_seq_item req);

endclass: write_driver

// ------------------------
// Extern methods
// ------------------------
// function new
function write_driver::new(string name = "write_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

// function build_phase
function void write_driver::build_phase(uvm_phase phase);
  wr_driver_ap = new("wr_driver_ap", this);
endfunction: build_phase

task write_driver::run_phase(uvm_phase phase);
  data_seq_item req; 
  // Wait till reset is over
  wait(write_if.rst_n == 1'b1);
  @(posedge write_if.clk);
  forever begin: drive_seq_item
    @(posedge write_if.clk);
    seq_item_port.get_next_item(req);
    // Drive the seq_item
    drive(req);
    seq_item_port.item_done();
  end: drive_seq_item
endtask: run_phase

// task drive
task write_driver::drive(data_seq_item req);
  write_if.wr_en <= req.wr_en;
  write_if.data_in <= req.data;
  if(!write_if.full && req.wr_en) begin
    wr_driver_ap.write(req);
  end
endtask: drive    // If not full, send through analysis port

`endif //WRITE_DRIVER_SVH

