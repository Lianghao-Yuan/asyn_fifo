//
//  Module: FIFO write sequence
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
`ifndef FIFO_WRITE_SEQ_SVH
`define FIFO_WRITE_SEQ_SVH

class fifo_write_seq extends uvm_sequence #(data_seq_item);
//
// UVM factory registration
`uvm_object_utils(fifo_write_seq)

function new(string name = "fifo_write_seq");
  super.new(name);
endfunction: new

task body();
  data_seq_item write_data;
  int num_data = 1000;
  // Instantiate a data
  write_data = data_seq_item::type_id::create("write_data");
  // Generate packets
  for(int i = 0; i < num_data; i++) begin
    start_item(write_data);
    if(!write_data.randomize()) begin
      `uvm_error("body", "Unable to randomize the data_seq_item")
    end
    finish_item(write_data);
    `uvm_info("body", "Generated a write_data", UVM_LOW)
  end

endtask: body

endclass: fifo_write_seq
`endif // FIFO_WRITE_SEQ_SVH
