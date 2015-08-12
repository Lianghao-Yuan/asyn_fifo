//
//  Module: Asynchronous FIFO
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/21/2015
//  Copyright (C) 2015 Lianghao Yuan
//  Description:
//  This is an asynchronous FIFO with two synchronizers for each pointer
//  synchronization. Both input clocks are positive edge triggered.
//
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
`ifndef ASYN_FIFO_V
`define ASYN_FIFO_V

module asyn_fifo #
(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4,
  parameter DATA_DEPTH = (1 << ADDR_WIDTH)
)
(
  // Reset signal (Low-level effective)
  input rst_n,
  // Data 
  input [DATA_WIDTH-1:0] data_in,
  output reg [DATA_WIDTH-1:0] data_out,
  // Controls
  input rd_en, // Enable read signal (High-level effective)
  input wr_en, // Enable write signal (High-level effective)
  // Clocks
  input clk_rd,
  input clk_wr,
  // Flags
  output full,
  output empty
);
// read and write pointer
reg [ADDR_WIDTH-1:0] rd_ptr;
reg [ADDR_WIDTH-1:0] wr_ptr;

// Old read & write pointer (for flag generation)
reg [ADDR_WIDTH-1:0] old_rd_ptr;
reg [ADDR_WIDTH-1:0] old_wr_ptr;

// Synchronized pointers
reg [ADDR_WIDTH-1:0] sync_rd_ptr;
reg [ADDR_WIDTH-1:0] sync_wr_ptr;

// Registered flag
reg full_reg;
reg empty_reg;

reg [DATA_WIDTH-1:0] fifo_ram [0:DATA_DEPTH-1];

// -------------------------------
// Full & Empty flag generation //
// -------------------------------
assign full  = (wr_ptr == sync_rd_ptr) && ((wr_ptr == old_wr_ptr + 1) || full_reg);
assign empty = (rd_ptr == sync_wr_prt) && ((rd_ptr == old_rd_ptr + 1) || empty_reg);

// -------------------
// FIFO write logic //
// -------------------
always @ (posedge clk_wr or negedge rst_n) begin
  if(!rst_n) begin
    wr_ptr <= 'b0;
    old_wr_ptr <= 'b0;
    full_reg <= full;
  end
  else begin
    old_wr_ptr <= wr_ptr;
    full_reg <= full;
    if(!full && wr_en) begin
      // Register all write-related signals
      fifo_ram[wr_ptr] <= data_in;
      wr_ptr <= wr_ptr + 1;
    end
  end
end

// ------------------
// FIFO read logic //
// ------------------
always @ (posedge clk_rd or negedge rst_n) begin
  if(!rst_n) begin
    rd_ptr <= 'b0;
    old_rd_ptr <= 'b0;
    empty_reg <= 1'b1;    
  end
  else begin
    old_rd_ptr <= rd_ptr;
    empty_reg <= empty;
    if(!empty && rd_en) begin
      data_out <= fifo_ram[rd_ptr];
      rd_ptr <= rd_ptr + 1;
    end
  end
end

// ------------------------
// Synchronization logic //
// ------------------------
// Read-to-write pointer sync
wire [ADDR_WIDTH-1:0] rd2wr_gray_in;
wire [ADDR_WIDTH-1:0] rd2wr_gray_out;

bin2gray #(.WIDTH(ADDR_WIDTH))
rd2wr_bin2gray(
  .bin_i(rd_ptr),
  .gray_o(rd2wr_gray_in)
);

synchronizer #(.WIDTH(ADDR_WIDTH))
rd2wr(
  .clk(clk_wr),
  .data_in(rd2wr_gray_in),
  .data_out(rd2wr_gray_out)
);

gray2bin #(.WIDTH(ADDR_WIDTH))
rd2wr_gray2bin(
  .gray_i(rd2wr_gray_out),
  .bin_o(sync_rd_ptr)
);

// Write-to-read pointer sync
wire [ADDR_WIDTH-1:0] wr2rd_gray_in;
wire [ADDR_WIDTH-1:0] wr2rd_gray_out;

bin2gray #(.WIDTH(ADDR_WIDTH))
wr2rd_bin2gray(
  .bin_i(wr_ptr),
  .gray_o(wr2rd_gray_in)
);

synchronizer #(.WIDTH(ADDR_WIDTH))
wr2rd(
  .clk(clk_rd),
  .data_in(wr2rd_gray_in),
  .data_out(wr2rd_gray_out)
);

gray2bin #(.WIDTH(ADDR_WIDTH))
wr2rd_gray2bin(
  .gray_i(wr2rd_gray_out),
  .bin_o(sync_wr_ptr)
);

endmodule // asyn_fifo

`endif // ASYN_FIFO_V
