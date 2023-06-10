module router_reg (rst,clk,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,error,dout);
input rst,clk;
input pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0] data_in;
output reg [7:0] dout;
output reg parity_done,error,low_pkt_valid;

reg [7:0] header_byte;
reg full_state_reg, internal_parity, packet_parity;
//laf_state is load after full
//parity done

always@(posedge clk)
begin
	if(!rst)
	parity_done<=1'b0;
	else if((ld_state&& ~fifo_full && ~pkt_valid)||(laf_state && low_pkt_valid && ~parity_done))
		begin
			parity_done<=1'b1;
		end
	else if(detect_add==1'b1) //reciving header but not parity
		parity_done<=1'b0;
	else
		parity_done<=parity_done; //avoid unessary latch creation
end

//low packet valid logic

always@(posedge clk)
begin
	if(!rst)
	low_pkt_valid<=1'b0;
	else if(ld_state && ~pkt_valid)
	low_pkt_valid<=1'b1;
	else if(rst_int_reg)
	low_pkt_valid<=1'b0;
end

//internal parity register logic

always@(posedge clk)
begin	
	if(!rst)
		internal_parity<=8'b0;
	else if (detect_add)
		internal_parity<=8'b0;
	else if(lfd_state)
		internal_parity	<=internal_parity ^ header_byte;
	else if(ld_state && low_pkt_valid && !full_state)
		internal_parity<= internal_parity ^ data_in;
	else 
		internal_parity<=internal_parity;
end

//packet_parity	

always@(posedge clk)
begin 
	if(!rst)
		packet_parity<=1'b0;
	else if(detect_add)
		packet_parity<=1'b0;
	else if((ld_state&& ~fifo_full && ~pkt_valid)||(laf_state && low_pkt_valid && ~parity_done))
		packet_parity<=data_in;
	else
		packet_parity<=packet_parity;
end

//error output logic

always@(posedge clk)
begin
	if(!rst)
		error<=1'b0;
	else if(!parity_done)
		error<=1'b0;
	else if(internal_parity != packet_parity)
		error<=1'b1;
	else if(internal_parity == packet_parity)
		error<=1'b0;
end
		
//finding header bite

always@(posedge clk)
begin
	if(!rst)
		header_byte <=8'b0;
	else if(detect_add && pkt_valid && data_in[1:0]!==2'b11)
		header_byte <=data_in;
	else 
		header_byte <= header_byte;
end

//data out

always@(posedge clk)
begin
	if(!rst)
		dout<=header_byte;
	else if(ld_state && !fifo_full)
		dout<= data_in;
	else if(ld_state && fifo_full)
		full_state_reg <= data_in;
	else if(laf_state)
		dout<=fifo_full;
end

endmodule