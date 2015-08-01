//
//  Module: Read driver
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/22/2015
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
`ifndef READ_DRIVER_SVH
`define READ_DRIVER_SVH

class read_driver extends uvm_driver # (data_seq_item);

// UVM factory registration macros
//
`uvm_component_utils(read_driver)

// Virtual interfaces
virtual fifo_read_if read_if;

// Analysis port: driver to scoreboard
uvm_analysis_port #(data_seq_item) rd_driver_ap;

// ----------------------
// Methods
// ----------------------
extern function new(string name = "read_driver", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task drive(data_seq_item req);

endclass: read_driver

// ------------------------
// Extern methods
// ------------------------

function read_driver::new(string name = "read_driver", uvm_component parent = null);
  super.new(name, parent);
endfunction: new


function void read_driver::build_phase(uvm_phase phase);
  rd_driver_ap = new("rd_driver_ap", this);
endfunction: build_phase

task read_driver::run_phase(uvm_phase phase);
  data_seq_item req; 
  // Wait till reset is over
  wait(read_if.rst_n == 1'b1);
  @(posedge read_if.clk);
  forever begin: drive_seq_item
    @(posedge read_if.clk);
    seq_item_port.get_next_item(req);
    // Drive the seq_item
    drive(req);
    seq_item_port.item_done();
  end: drive_seq_item
endtask: run_phase

task read_driver::drive(data_seq_item req);
  data_seq_item rhs_;
  if(!$cast(rhs_, req.clone())) begin
    `uvm_error("drive", "Cast failed")    
  end
  fork begin
    //@(posedge read_if.clk);
    read_if.rd_en <= rhs_.rd_en;
    // read_if.data_out <= req.data;
    if(!read_if.empty && rhs_.rd_en) begin
      @(posedge read_if.clk);
      @(posedge read_if.clk) begin
        rhs_.data = read_if.data_out;
        rd_driver_ap.write(rhs_);
      end
    end
  end
  join_none
endtask: drive    // If not empty, send through analysis port

`endif //READ_DRIVER_SVH

