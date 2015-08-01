//
//  Module: Gray code to binary converter
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/21/2015
//  Copyright (C) 2015 Lianghao Yuan
//  Description:
//  Gray code to binary converter (ripple)
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
`ifndef GRAY2BIN_V
`define GRAY2BIN_V

module gray2bin #
(
  parameter WIDTH = 4 // Here is the address width for pointer
)
(
  input [WIDTH-1:0] gray_i,
  output [WIDTH-1:0] bin_o
);

// Main conversion logic:
// MSB is the same
assign bin_o[WIDTH-1] = gray_i[WIDTH-1];
// Generate the rest of logic
genvar i;
generate
  for (i = 0; i < WIDTH-1; i = i + 1) begin: generate_block
    assign bin_o[i] = gray_i[i] ^ bin_o[i+1];
  end
endgenerate

endmodule // gray2bin

`endif // GRAY2BIN_V
