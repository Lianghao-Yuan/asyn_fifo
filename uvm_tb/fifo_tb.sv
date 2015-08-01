//
//  Module: FIFO testbench
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
`ifndef FIFO_TB_SV
`define FIFO_TB_SV

module fifo_tb;

import uvm_pkg::*;
import fifo_agent_pkg::*;

bit rd_clk;
bit wr_clk;
bit rst_n;

// Generate clock signal
initial begin
  rd_clk = 0;
  forever #10 rd_clk = ~rd_clk;
end

initial begin
  wr_clk = 0;
  forever # 11 wr_clk = ~wr_clk;
end

// Reset signal
initial begin
  rst_n <= 1'b0;
  #5 rst_n <= 1'b1;
end

// interface instantiation
fifo_read_if read_if(rd_clk, rst_n);
fifo_write_if write_if(wr_clk, rst_n);

// Instantiate DUT and coverage module
asyn_fifo # 
(
  .DATA_WIDTH(`DATA_WIDTH),
  .ADDR_WIDTH(`ADDR_WIDTH),
  .DATA_DEPTH(`DATA_DEPTH)
) a_fifo (
  .rst_n,
  .data_in(write_if.data_in),
  .data_out(read_if.data_out),
  .rd_en(read_if.rd_en),
  .wr_en(write_if.wr_en),
  .clk_rd(rd_clk),
  .clk_wr(wr_clk),
  .full(write_if.full),
  .empty(read_if.empty)
);

fifo_coverage fifo_cov(.read_if(read_if), .write_if(write_if));


initial begin
  uvm_config_db # (virtual fifo_read_if)::set(null, "uvm_test_top", "read_if", read_if);
  uvm_config_db # (virtual fifo_write_if)::set(null, "uvm_test_top", "write_if", write_if);
  run_test();
end

initial begin
  $dumpfile("dump.vcd");
  $dumpvars(0, fifo_tb);
end

endmodule: fifo_tb

`endif // FIFO_TB_SV

