//
//  Module: FIFO read sequence
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
`ifndef FIFO_READ_SEQ_SVH
`define FIFO_READ_SEQ_SVH

class fifo_read_seq extends uvm_sequence #(data_seq_item);
//
// UVM factory registration
`uvm_object_utils(fifo_read_seq)

function new(string name = "fifo_read_seq");
  super.new(name);
endfunction: new

task body();
  data_seq_item read_data;
  int num_data = 1000;
  // Instantiate a data
  read_data = data_seq_item::type_id::create("read_data");
  // Generate packets
  for(int i = 0; i < num_data; i++) begin
    start_item(read_data);
    if(!read_data.randomize()) begin
      `uvm_error("body", "Unable to randomize the data_seq_item")
    end
    finish_item(read_data);
    `uvm_info("body", "Generated a read_data", UVM_LOW)
  end

endtask: body

endclass: fifo_read_seq
`endif // FIFO_READ_SEQ_SVH
