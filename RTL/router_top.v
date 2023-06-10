module router_top(input clk,rst,read_en_0,read_en_1,read_en_2,pkt_valid,input [7:0] data_in,
output [7:0] data_out_0,data_out_1,data_out_2,output vld_out_0,vld_out_1,vld_out_2,error,busy);

wire [2:0]write_en;
wire [7:0]dout; 




router_fsm fsm(.clk(clk),.rst(rst),.pkt_valid(pkt_valid),.parity_done(parity_done),
.data_in(data_in[1:0]),.fifo_empty_0(empty_0),.fifo_empty_1(empty_1),.fifo_empty_2(empty_2),
.soft_reset_0(soft_reset_0),.soft_reset_1(soft_reset_1),.soft_reset_2(soft_reset_2),.fifo_full(fifo_full),
.low_pkt_valid(low_pkt_valid),.busy(busy),.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),
.full_state(full_state),.write_enb_reg(write_en_reg),.rst_int_reg(rst_int_reg),.lfd_state(lfd_state));


router_sync syn(.clk(clk),.rst(rst),.detect_add(detect_add),.write_en_reg(write_en_reg),.data_in(data_in[1:0]),
.full_0(full_0),.full_1(full_1),.full_2(full_2),.empty_0(empty_0),.empty_1(empty_1),.empty_2(empty_2),
.read_enb_0(read_en_0),.read_enb_1(read_en_1),.read_enb_2(read_en_2),
.write_en(write_en),.vld_out_0(vld_out_0),.soft_reset_0(soft_reset_0),.vld_out_1(vld_out_1),
.soft_reset_1(soft_reset_1),.vld_out_2(vld_out_2),
.soft_reset_2(soft_reset_2),.fifo_full(fifo_full));

router_reg reg1(.rst(rst),.clk(clk),.pkt_valid(pkt_valid),.data_in(data_in),.fifo_full(fifo_full),.rst_int_reg(rst_int_reg),
.detect_add(detect_add),.ld_state(ld_state),.laf_state(laf_state),.full_state(full_state),.lfd_state(lfd_state),
.parity_done(parity_done),.low_pkt_valid(low_pkt_valid),.error(error),.dout(dout));



router_fifo fifo0(.clk(clk),.rst(rst),.write_en(write_en[0]),.soft_reset(soft_reset_0),.read_enb(read_en_0),.data_in(dout),
.lfd_state(lfd_state),.empty(empty_0),.data_out(data_out_0),.full(full_0));
					
router_fifo fifo1(.clk(clk),.rst(rst),.write_en(write_en[1]),.soft_reset(soft_reset_1),.read_enb(read_en_1),.data_in(dout),
.lfd_state(lfd_state),.empty(empty_1),.data_out(data_out_1),.full(full_1));
					
router_fifo fifo2(.clk(clk),.rst(rst),.write_en(write_en[2]),.soft_reset(soft_reset_2),.read_enb(read_en_2),.data_in(dout),
.lfd_state(lfd_state),.empty(empty_2),.data_out(data_out_2),.full(full_2));
					
					
endmodule