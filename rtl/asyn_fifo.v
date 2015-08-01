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
  output reg full,
  output reg empty
);
// read and write pointer
reg [ADDR_WIDTH-1:0] rd_ptr;
reg [ADDR_WIDTH-1:0] wr_ptr;

// Synchronized pointers
reg [ADDR_WIDTH-1:0] sync_rd_ptr;
reg [ADDR_WIDTH-1:0] sync_wr_ptr;

// Registered signals (sampled by appropriate clock)
// We register write control signal so that there's a complete cycle for
// memory to write data in, in order to avoid metastability or hazard.
reg [3:0] wr_ptr_reg; // Ptr for RAM
reg wr_en_reg; // Wr_en for RAM

// Synchronized data signal
reg [DATA_WIDTH-1:0] data_in_reg;
reg [DATA_WIDTH-1:0] data_out_reg;


// Old pointer (for calculation of full & empty flags)
reg [3:0] old_wr_ptr;
reg [3:0] old_rd_ptr;

// -------------------
// FIFO write logic //
// -------------------
always @ (posedge clk_wr or negedge rst_n) begin
  if(!rst_n) begin
    wr_ptr <= 1'b0;
    old_wr_ptr <= 1'b0;
    wr_ptr_reg <= 4'b0;
    wr_en_reg <= 1'b0;
    data_in_reg <= 0;
  end
  else begin
    // Update old pointer
    old_wr_ptr <= wr_ptr;
    if(!full) begin
      // Register all write-related signals
      data_in_reg <= data_in;
      wr_en_reg <= wr_en;
      // Update pointer
      if(wr_en) begin
        wr_ptr_reg <= wr_ptr;
        wr_ptr <= wr_ptr + 1;
      end
    end
  end
end

// ------------------
// FIFO read logic //
// ------------------
always @ (posedge clk_rd or negedge rst_n) begin
  if(!rst_n) begin
    rd_ptr <= 1'b0;
    old_rd_ptr <= 1'b0;
    data_out <= 0;
  end
  else begin
    old_rd_ptr <= rd_ptr;
    if((!empty) && rd_en) begin
      // Generate output
      data_out <= data_out_reg;
      // Update pointers
      rd_ptr <= rd_ptr + 1;
    end
  end
end

// ------------------------
// Synchronization logic //
// ------------------------
// Read-to-write pointer sync
synchronizer #(.WIDTH(ADDR_WIDTH))
rd2wr(
  .clk(clk_wr),
  .data_in(rd_ptr),
  .data_out(sync_rd_ptr)
);

// Write-to-read pointer sync
synchronizer #(.WIDTH(ADDR_WIDTH))
wr2rd(
  .clk(clk_rd),
  .data_in(wr_ptr),
  .data_out(sync_wr_ptr)
);

// --------------------------------
// FIFO full & empty flags logic //
// --------------------------------
// Since we use two-stage synchronizer, potential pointer delay is 2 cycles.
// So we should be pessimistic in calculating flags.
//
// Empty flag
always @ (posedge clk_rd or negedge rst_n) begin
  if(!rst_n) begin
    empty <= 1'b1;
  end
  // Only set the boundary conditions here.
  // Since ptr can only increment in inverval of one, it cannot skip the
  // boundary we set.
  else begin
    if(sync_wr_ptr == rd_ptr + 2) begin
      empty <= 1'b1;
    end
    else if(sync_wr_ptr == rd_ptr + 3) begin
      empty <= 1'b0;
    end
    else begin
      empty <= empty;
    end
  end
end

// Full flag
always @ (posedge clk_wr or negedge rst_n) begin
  if(!rst_n) begin
    full <= 1'b0;
  end
  // Only set the boundary conditions here.
  // Since ptr can only increment in inverval of one, it cannot skip the
  // boundary we set.
  else begin
    if(sync_rd_ptr == wr_ptr + 2) begin
      full <= 1'b1;
    end
    else if(sync_rd_ptr == wr_ptr + 3) begin
      full <= 1'b0;
    end
    else begin
      full <= full;
    end
  end
end

// --------------------
// RAM instantiation //
// --------------------
asyn_dual_port_ram #
(
  .DATA_WIDTH(DATA_WIDTH),
  .ADDR_WIDTH(ADDR_WIDTH),
  .DATA_DEPTH(DATA_DEPTH)
)
RAM(
  // Port 0 is for write (since port 0 has higher priority on write)
  .addr_0(old_wr_ptr),
  //.cs_0(wr_en_reg),
  .clk_0(clk_wr),
  .we_0(1'b1),
  .oe_0(wr_en_reg),
  .data_0(data_in_reg),
  // Port 1 is for read
  // We keeps reading memory
  .addr_1(rd_ptr),
  //.cs_1(1'b1),
  .we_1(1'b0),
  .oe_1(1'b1),
  .data_1(data_out_reg)
);

endmodule // asyn_fifo

`endif // ASYN_FIFO_V
