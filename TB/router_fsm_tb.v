module router_fsm_tb();

reg clk,rst,pkt_valid,parity_done;
reg [2:0] data_in;
reg soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
wire busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;

router_fsm dut(clk,rst,pkt_valid,parity_done,data_in,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);

initial 
begin
clk=1'b1;
forever #5 clk=~clk;
end

//reset

task reset;
begin
@(negedge clk)
		rst=1'b0;
@(negedge clk)
		rst=1'b1;
end
endtask

task initilize;
begin
@(negedge clk)
pkt_valid=1'b1;
data_in=2'b00;
fifo_full=1'b0;
fifo_empty_0=1'b1;
fifo_empty_1=1'b0;
fifo_empty_2=1'b0;
soft_reset_0=1'b0;
soft_reset_1=1'b1;
soft_reset_2=1'b0;
parity_done=1'b0;
low_pkt_valid=1'b0;
end
endtask

/*
task task1;
begin
@(negedge clk)
fifo_full=1'b0;
pkt_valid=1'b0;
end
endtask

task task2;
begin
@(negedge clk)
fifo_full=1'b0;
end
endtask



initial
begin
reset;#20;
initilize;#40;
task1;#40;
task2;

end
*/

task DA_LFD_LD_LP_CPE_DA;
begin
rst=1'b0;#20;
rst=1'b1;#20;
@(negedge clk)
pkt_valid=1'b1;
data_in=2'b00;
fifo_empty_0=1;
#50; @(negedge clk)
fifo_full=1'b0;
pkt_valid=1'b0;
#20;@(negedge clk)
fifo_full=1'b0;
end
endtask

task DA_LFD_LD_FFS_LAF_LP_CPE_DA;
begin
rst=1'b0;#20;
rst=1'b1;#20;
@(negedge clk)
parity_done=1'b1;
data_in=2'b01;
fifo_empty_1=1'b1;
#50;@(negedge clk)
fifo_full=1'b1;
#50;@(negedge clk)
fifo_full=1'b0;
#30;@(negedge clk)
parity_done=1'b0;
low_pkt_valid=1'b1;
#30;@(negedge clk)
fifo_full=1'b0;
end
endtask

task DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;
begin
rst=1'b0;#20;
rst=1'b1;#20;@(negedge clk)
parity_done=1'b1;
data_in=2'b01;
fifo_empty_1=1'b1;
#50;@(negedge clk)
fifo_full=1'b1;
#50;@(negedge clk)
fifo_full=1'b0;
#30;@(negedge clk)
parity_done=1'b0;
low_pkt_valid=1'b0;
#30;@(negedge clk)
fifo_full=1'b0;
pkt_valid=1'b0;
#30;@(negedge clk)
fifo_full=1'b0;
end
endtask

task DA_LFD_LD_LP_CPE_FFS_LAF_DA;
begin
rst=1'b0;#20;
rst=1'b1;#20;@(negedge clk)
parity_done=1'b1;
data_in=2'b01;
fifo_empty_1=1'b1;
#50;@(negedge clk)
fifo_full=1'b0;
pkt_valid=1'b0;
#50;@(negedge clk)
fifo_full=1'b1;
#50;@(negedge clk)
fifo_full=1'b0;
#50;@(negedge clk)
parity_done=1'b1;
end
endtask

initial
begin
reset;#20;
initilize;
DA_LFD_LD_LP_CPE_DA;#20;
initilize;
reset;
DA_LFD_LD_FFS_LAF_LP_CPE_DA;#20;
initilize;
reset;
DA_LFD_LD_FFS_LAF_LD_LP_CPE_DA;#20;
initilize;
reset;
DA_LFD_LD_LP_CPE_FFS_LAF_DA;
$finish;
end

endmodule


