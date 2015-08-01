//
//  Module: FIFO scoreboard
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
`ifndef FIFO_SCOREBOARD_SVH
`define FIFO_SCOREBOARD_SVH

class fifo_scoreboard extends uvm_scoreboard;

// UVM factory registration macro
`uvm_component_utils(fifo_scoreboard)
// uvm_analysis_imp_decl: write port and read port
`uvm_analysis_imp_decl(_rd_port)
`uvm_analysis_imp_decl(_wr_port)
// ----------------------------------
// Data members
// ----------------------------------
// Declare uvm_analysis_imp export
uvm_analysis_imp_rd_port # (data_seq_item, fifo_scoreboard) rd_export;
uvm_analysis_imp_wr_port # (data_seq_item, fifo_scoreboard) wr_export;
// Queue for storing data
data_seq_item data_queue[$];
// ----------------------------------
// Methods
// ----------------------------------

extern function new(string name = "fifo_scoreboard", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void write_rd_port(data_seq_item rhs);
extern function void write_wr_port(data_seq_item rhs);

endclass: fifo_scoreboard
// ----------------------------------
// Extern methods
// ----------------------------------
function fifo_scoreboard::new(string name = "fifo_scoreboard", uvm_component parent = null);
  super.new(name, parent);
endfunction: new

function void fifo_scoreboard::build_phase(uvm_phase phase);
  rd_export = new("rd_export", this);
  wr_export = new("wr_export", this);
endfunction: build_phase
//
// Write method after receiving data from rd_port
//
function void fifo_scoreboard::write_rd_port(data_seq_item rhs);
  data_seq_item received_data;
  data_seq_item expected_data;
  if(rhs == null) begin
    `uvm_error("write_rd_port", "Null object")
  end
  if(!$cast(received_data, rhs.clone())) begin
    `uvm_error("write_rd_port", "Cast failed")
    return;
  end
  // If queue is not empty, start comparing
  if(data_queue.size() == 0) begin
    `uvm_error("write_rd_port", "No data in the data_queue")
  end
  else begin
    expected_data = data_queue.pop_front();
    if(received_data.compare(expected_data)) begin
      `uvm_info("write_rd_port", "Written data and read data matched", UVM_LOW)
      `uvm_info("write_rd_port", $psprintf("expected: %h", expected_data.data), UVM_LOW)
    end
    else begin
      `uvm_error("write_rd_port", "Written data and read data mismatched")
      `uvm_error("write_rd_port", $psprintf("expected: %h, received: %h", expected_data.data, received_data.data))
    end
  end
endfunction: write_rd_port 
//
// Write method after writing data to wr_port
//
function void fifo_scoreboard::write_wr_port(data_seq_item rhs);
  data_seq_item written_data;
  if(rhs == null) begin
    `uvm_error("write_wr_port", "Null object")
  end
  if(!$cast(written_data, rhs.clone())) begin
    `uvm_error("write_wr_port", "Cast failed")
    return;
  end
  data_queue.push_back(written_data);
endfunction: write_wr_port

`endif // FIFO_SCOREBOARD_SVH
