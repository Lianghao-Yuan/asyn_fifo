//
//  Module: Asynchronous Dual Port RAM
//  Author: Lianghao Yuan
//  Email: yuanlianghao@gmail.com
//  Date: 07/21/2015
//  Copyright (C) 2015 Lianghao Yuan
//  Description:
//  In this RAM module, port 0 has priority over port 1 (when two simultanious
//  writes)
//  Signal Description:
//  cs_0: high-level-effective chip-select signal (enable)
//  we_0: high-level-effective write-enable signal (write: 1, read: 0)
//  oe_0: high-level-effective output-enable signal

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
`ifndef ASYN_DUAL_PORT_RAM_V
`define ASYN_DUAL_PORT_RAM_V

module asyn_dual_port_ram #
(
  parameter DATA_WIDTH = 8,
  parameter ADDR_WIDTH = 4,
  parameter DATA_DEPTH = (1 << ADDR_WIDTH)
)
(
  input [ADDR_WIDTH-1:0] addr_0,
  // input cs_0, // Chip select 0
  input we_0, // Write enable 0
  input oe_0, // Write-in enable 0
  input clk_0,
  input [ADDR_WIDTH-1:0] addr_1,
  // input cs_1, // Chip select 1
  input we_1, // Write enable 1
  input oe_1, // Output enable 0 (Read enable)
  // Inout type data ports
  input [DATA_WIDTH-1:0] data_0,
  output [DATA_WIDTH-1:0] data_1
);
// Memory storage
reg [DATA_WIDTH-1:0] ram [0:DATA_DEPTH-1];
// Output before tri-state buffer
// reg [DATA_WIDTH-1:0] data_out_0;
// reg [DATA_WIDTH-1:0] data_out_1;

// Memory write block (no simutanious write)
always @ (posedge clk_0) begin : MEM_WRITE
  // Write operation: cs_X = 1, we_X = 1
  // Port 0 has priority over port 1
  if (we_0 && oe_0) begin
    ram[addr_0] <= data_0;
  end
end

// Tri-state buffer control for port 0
// Output data_0 only when cs_0 = 1, we_0 = 0 and oe_0 = 1
// assign data_0 = (cs_0 && !we_0 && oe_0) ? data_out_0 : 8'bz;
// Memory read block for port 0
//always @ (*) begin : MEM_READ_0
  // Read operation: cs_0 = 1, we_0 = 0, oe_0 = 1
  //if (cs_0 && !we_0 && oe_0) begin
//		data_out_0 = ram[addr_0];
  //end
 // else begin
//		data_out_0 = 0;
 // end
//end

// Tri-state buffer control for port 1
// Output data_1 only when cs_1 = 1, we_1 = 0 and oe_1 = 1
//assign data_1 = (cs_1 && !we_1 && oe_1) ? data_out_1 : 8'bz;
// Memory read block for port 1
/*always @ (*) begin : MEM_READ_1
  // Read operation: cs_1 = 1, we_1 = 0, oe_1 = 1
  if (cs_1 && !we_1 && oe_1) begin
    data_1 = ram[addr_1];
  end
  else begin
    data_1 = 0;
  end
end
*/
assign data_1 = (!we_1 && oe_1) ? ram[addr_1] : 8'bz;

endmodule // asyn_dual_port_ram

`endif // ASYN_DUAL_PORT_RAM_V
