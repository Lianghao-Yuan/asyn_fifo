//
//  Module: Synchronizer (including bin2gray and gray2bin converters)
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/21/2015
//  Copyright (C) 2015 Lianghao Yuan
//  Description:
//  This is a synchronizer for complete synchronizatin path.
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
`ifndef SYNCHRONIZER_V
`define SYNCHRONIZER_V

module synchronizer #
(
  WIDTH = 4
)
(
  // Clock
  input clk,
  // Data
  input [WIDTH-1:0] data_in, //Data_in is binary code
  output [WIDTH-1:0] data_out // Data_out is binary code
);
// Data on the synchronization path is gray code
// Below is gray-coded data on different stages
reg [WIDTH-1:0] gray_0;
reg [WIDTH-1:0] gray_1;
reg [WIDTH-1:0] gray_2;

// First stage: binary to gray
bin2gray #(.WIDTH(WIDTH))
m_bin2gray(
  .bin_i(data_in),
  .gray_o(gray_0)
);

// Second & third stage: through first & second synchronizer flip-flops
always @ (posedge clk) begin
  gray_1 <= gray_0;
  gray_2 <= gray_1;
end

// Fourth stage: gray to binary
gray2bin #(.WIDTH(WIDTH))
m_gray2bin(
  .gray_i(gray_2),
  .bin_o(data_out)
);

endmodule // synchronizer

`endif // SYNCHRONIZER_V
