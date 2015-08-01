//
//  Module: data sequence item
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
`ifndef DATA_SEQ_ITEM_SVH
`define DATA_SEQ_ITEM_SVH

class data_seq_item extends uvm_sequence_item;

`uvm_object_utils(data_seq_item)

// ---------------
// Data members //
// ---------------
rand bit [`DATA_WIDTH-1:0] data;
rand bit rd_en;
rand bit wr_en;

function new(string name = "data_seq_item");
  super.new(name);
endfunction: new
// -----------------
// Extern methods //
// -----------------
extern function void do_copy(uvm_object rhs);
extern function bit do_compare(uvm_object rhs, uvm_comparer comparer);
extern function string convert2string();

endclass: data_seq_item

// ----------
// Methods //
// ----------
// do_copy
function void data_seq_item::do_copy(uvm_object rhs);
  data_seq_item rhs_;
  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_copy", "Cast failed")
    return;
  end

  super.do_copy(rhs);
  data = rhs_.data;
  rd_en = rhs_.rd_en;
  wr_en = rhs_.wr_en;
endfunction: do_copy

// do_compare
function bit data_seq_item::do_compare(uvm_object rhs, uvm_comparer comparer);
  data_seq_item rhs_;
  if(!$cast(rhs_, rhs)) begin
    `uvm_error("do_compare", "Cast failed")
    return 0;
  end

  return (rhs_.data == data);
endfunction: do_compare

// convert2string
function string data_seq_item::convert2string();
  string s;
  $sformat(s, "%s \n", super.convert2string());

  $sformat(s, "%s \n data = %d", s, data);
  return s;
endfunction: convert2string

`endif // DATA_SEQ_ITEM_SVH
