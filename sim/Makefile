# You may change these configuration to fit your need
UVM_VERBOSITY = UVM_LOW
# You HAVE TO change this to your UVM package path
UVM_HOME = /nethome/lyuan39/uvm-1.2
# Files declaration
FIFO_RTL = ../rtl/bin2gray.v \
           ../rtl/gray2bin.v \
           ../rtl/synchronizer.v \
           ../rtl/asyn_dual_port_ram.v \
           ../rtl/asyn_fifo.v

FIFO_FILES = ../uvm_tb/agent/fifo_agent_pkg.sv \
             ../uvm_tb/agent/fifo_coverage.sv \
             ../uvm_tb/agent/fifo_read_if.sv \
             ../uvm_tb/agent/fifo_write_if.sv \
             ../uvm_tb/fifo_test_pkg.sv \
             ../uvm_tb/fifo_tb.sv
# Directory declaration
FIFO_RTL_DIR = +incdir+../rtl
FIFO_AGENT_DIR = +incdir+../uvm_tb/agent
FIFO_TB_DIR = +incdir+../uvm_tb


# Other declarations
UVM_TESTNAME = fifo_test

# VCS related commands
VCS = vcs
VCS_OPTS = -sverilog -timescale=1ns/1ns +acc +vpi +v2k -full64
UVM_OPTS = +incdir+$(UVM_HOME)/src \
                   $(UVM_HOME)/src/uvm.sv \
                   $(UVM_HOME)/src/dpi/uvm_dpi.cc -CFLAGS -DVCS
DEBUG_OPTS = -cm line -debug_all

INCDIRS = $(FIFO_RTL_DIR) \
          $(FIFO_AGENT_DIR) \
          $(FIFO_TB_DIR)

SRC_FILES = $(FIFO_RTL) \
            $(FIFO_FILES) 

.PHONY: vcs_std run_test vcs_urg vcs_debug run_test_debug clean

all: vcs_std run_test vcs_urg 

vcs_std:
	$(VCS) $(VCS_OPTS) $(UVM_OPTS) $(INCDIRS) $(SRC_FILES)

run_test:
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) +UVM_VERBOSITY=$(UVM_VERBOSITY)

vcs_urg:
	urg -dir simv.vdb
# Debug options
vcs_debug:
	$(VCS) $(VCS_OPTS) $(UVM_OPTS) $(DEBUG_OPTS) $(INCDIRS) $(SRC_FILES)

run_test_debug:
	./simv +UVM_TESTNAME=$(UVM_TESTNAME) +UVM_VERBOSITY=$(UVM_VERBOSITY) -cm line+code+tgl+path	
clean:
	rm -rf *~ core csrc simv* vc_hdrs.h ucli.key urg* *.log dump* DVE*


