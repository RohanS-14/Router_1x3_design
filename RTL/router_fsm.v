module router_fsm(input clk,rst,pkt_valid,parity_done,input [1:0] data_in,input fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,
output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);

reg [3:0] present_state,next_state;

parameter decode_address 	= 		4'b0001;
parameter wait_till_empty	=  		4'b0010;
parameter load_first_data	=		4'b0011;
parameter load_data		 	=		4'b0100;
parameter fifo_full_state	=		4'b0101;
parameter load_after_full	=		4'b0110;
parameter load_parity	 	=		4'b0111;
parameter check_parity_error=		4'b1000;

/*declaring additonal reg to store header value for
 data_in .... at the moment we are keeping in temp coz we dont need to check for the address for now
 later use this condition for fsm part*/

//fsm is written by project specification

reg [1:0] fsm_data_in;

//temp logic 

always@(posedge clk)
begin
	if(~rst)
		fsm_data_in<=2'b00;
	else if(detect_add)
		fsm_data_in<=data_in;
end

/* 1. first block present state logic*/

always@(posedge clk)
begin
	if(~rst)
		present_state<=decode_address;
	else if(((soft_reset_0) && (fsm_data_in==2'b00))||((soft_reset_1) && (fsm_data_in==2'b01))||((soft_reset_2) && (fsm_data_in==2'b10)))
		present_state <=decode_address;
	else
		present_state<=next_state;
end

always@(*)
begin
	next_state=decode_address;
	case(present_state)
	//.1
		decode_address 	: 	
		begin 
			next_state=decode_address;
			if(((pkt_valid) && (data_in==2'b00) && (fifo_empty_0))||((pkt_valid) && (data_in==2'b01) && (fifo_empty_1))||((pkt_valid) && (data_in==2'b10) && (fifo_empty_1)))
				next_state= load_first_data; 
			else if(((pkt_valid) && (data_in==2'b00) && (!fifo_empty_0))||((pkt_valid) && (data_in==2'b01) && (!fifo_empty_1))||((pkt_valid) && (data_in==2'b10) && (!fifo_empty_1)))
				next_state= wait_till_empty;
			else 
				next_state=decode_address;
			end
	//.3
		load_first_data	: next_state = load_data;
						
	//.2
		wait_till_empty :begin 
						next_state=wait_till_empty;
						if((fifo_empty_0 && (fsm_data_in[1:0]==2'b00))||(fifo_empty_0 && (fsm_data_in[1:0]==2'b01))||(fifo_empty_0 && (fsm_data_in[1:0]==2'b10)))
						next_state=load_first_data;
						end
	//.4
		load_data		:begin
						next_state=load_data;
						 if(fifo_full)
						
							next_state= fifo_full_state;
							else 
							begin 
							if(!fifo_full && !pkt_valid)
								next_state=load_parity;
							else
								next_state=load_data;
							end
						end
	//.5
		fifo_full_state	:begin 
						next_state=fifo_full_state;
						if(!fifo_full)
						next_state=load_after_full;
						else if(fifo_full)
						next_state=fifo_full_state;
						end
	//.6
		load_after_full	: begin
						next_state=load_after_full;
						if(!parity_done && low_pkt_valid)
						next_state=load_parity;
						else if(!parity_done && !low_pkt_valid)
						next_state=load_data;
						
						else begin 
								if(parity_done)
									next_state=decode_address;
								else
									next_state = load_after_full;
								end 
						end
	//.7
		load_parity		: begin
			
							next_state=check_parity_error; end
	//.8
		check_parity_error:begin 
						next_state=check_parity_error;
							if(fifo_full)
								next_state=fifo_full_state;
							else if(!fifo_full)
								next_state=decode_address;
						end

		default: next_state=decode_address;
		endcase
end

//output logic

assign lfd_state= (present_state==load_first_data)?1'b1:1'b0;
assign ld_state= (present_state==load_data)?1'b1:1'b0;		
assign full_state= (present_state==fifo_full_state)?1'b1:1'b0;
assign laf_state =((present_state==load_after_full))?1'b1:1'b0;
assign rst_int_reg =((present_state==check_parity_error))?1'b1:1'b0;	
assign detect_add= ((present_state==decode_address))?1'b1:1'b0;					
assign write_enb_reg= ((present_state==load_after_full)||(present_state==load_parity)||(present_state==load_data))?1'b1:1'b0;		
assign busy = ((present_state==load_first_data)||(present_state==fifo_full_state)||(present_state==load_after_full)||(present_state==load_parity)||(present_state==wait_till_empty)||(present_state==check_parity_error))?1'b1:1'b0;	
		
endmodule						
			
			
//load == write en ==1
	
						