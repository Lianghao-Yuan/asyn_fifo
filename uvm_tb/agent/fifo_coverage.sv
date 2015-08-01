//
//  Module: FIFO coverage
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
`ifndef FIFO_COVERAGE_SV
`define FIFO_COVERAGE_SV

module fifo_coverage(fifo_read_if read_if, fifo_write_if write_if);

// ------------------
// Cover properties //
// ------------------
// Normal properties
// FIFO_NORMAL_WR_3: three consecutive write when neither empty nor full
property FIFO_NORMAL_WR_3;
  @(posedge write_if.clk)
  (write_if.rst_n) |-> write_if.wr_en[*3];
endproperty: FIFO_NORMAL_WR_3
COV_FIFO_NORMAL_WR_3: cover property(FIFO_NORMAL_WR_3);

// FIFO_NORMAL_RD_3: three consecutive read when neither empty nor full
property FIFO_NORMAL_RD_3;
  @(posedge read_if.clk)
  (write_if.rst_n) |-> read_if.rd_en[*3];
endproperty: FIFO_NORMAL_RD_3
COV_FIFO_NORMAL_RD_3: cover property(FIFO_NORMAL_RD_3);

// FIFO_RD_WR: simultaneous read & write
//COV_FIFO_RD_WR: cover property(read_if.rd_en && write_if.wr_en);

// extreme properties
// FIFO_FULL_WR_3: three consecutive write when full
property FIFO_FULL_WR_3;
  @(posedge write_if.clk)
  (write_if.full) |-> (write_if.full && write_if.wr_en)[*3];
endproperty: FIFO_FULL_WR_3
COV_FIFO_FULL_WR_3: cover property(FIFO_FULL_WR_3);

// FIFO_EMPTY_RD_3: three consecutive read when empty
property FIFO_EMPTY_RD_3;
  @(posedge read_if.clk)
  (read_if.empty) |-> (read_if.empty && read_if.rd_en)[*3];
endproperty: FIFO_EMPTY_RD_3
COV_FIFO_EMPTY_RD_3: cover property(FIFO_EMPTY_RD_3);

// FIFO data all 0 and 1
property FIFO_READ_ALL_1;
  @(posedge read_if.clk)
  1 |-> $past(read_if.rd_en) && !$past(read_if.empty) && (read_if.data_out == 8'hFF);
endproperty: FIFO_READ_ALL_1
COV_FIFO_READ_ALL_1: cover property(FIFO_READ_ALL_1);

property FIFO_READ_ALL_0;
  @(posedge read_if.clk)
  1 |-> $past(read_if.rd_en) && !$past(read_if.empty)&& (read_if.data_out == 8'h0);
endproperty: FIFO_READ_ALL_0
COV_FIFO_READ_ALL_0: cover property(FIFO_READ_ALL_0);

endmodule
`endif // FIFO_COVERAGE_SV


