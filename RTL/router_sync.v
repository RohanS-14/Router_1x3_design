//router synchronizer
module router_sync(clk,rst,detect_add,write_en_reg,data_in,full_0,full_1,full_2,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2,write_en,vld_out_0,soft_reset_0, vld_out_1,soft_reset_1, vld_out_2,soft_reset_2, fifo_full);

input clk,rst,detect_add,write_en_reg; 
input[1:0]data_in;
input full_0,full_1,full_2,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2;
output  reg [2:0] write_en;
output vld_out_0, vld_out_1, vld_out_2;
output reg soft_reset_0,soft_reset_1,soft_reset_2; 
output reg fifo_full;

reg [1:0]temp;
integer timer0,timer1,timer2;

//5. timer for 30 clk cycles 
//timer 0
always@(posedge clk)
begin
if(!rst)
begin
	timer0 <=5'b0;
	soft_reset_0 <=0;
	end
else if(vld_out_0 )
	begin
	if(!read_enb_0)
		begin
			if(timer0==5'd29)
			begin
			soft_reset_0<=1'b1;
			timer0<=1'b0;
			end
			else
			begin
			soft_reset_0<=1'b0;
			timer0<=timer0+1'b1;
			end
		end
	end
end

always@(posedge clk)
begin
if(!rst)
begin
	timer1 <=5'b0;
	soft_reset_1 <=0;
	end
else if(vld_out_1 )
	begin
	if(!read_enb_1)
		begin
			if(timer1==5'd29)
			begin
			soft_reset_1<=1'b1;
			timer1<=1'b0;
			end
			else
			begin
			soft_reset_1<=1'b0;
			timer1<=timer1+1'b1;
			end
		end
	end
end


always@(posedge clk)
begin
if(!rst)
begin
	timer2 <=5'b0;
	soft_reset_2 <=0;
	end
else if(vld_out_2 )
	begin
	if(!read_enb_2)
		begin
			if(timer2==5'd29)
			begin
			soft_reset_2<=1'b1;
			timer2<=0;
			end
			else
			begin
			soft_reset_2<=0;
			timer2<=timer2+1'b1;
			end
		end
	end
end




//1. detect_add and data_in
always@(posedge clk)
begin
	if(!rst)
	temp<=0;
	else if(detect_add)
	temp<=data_in;
end

//2. fifo full
always@(*)
begin
	case(temp)
		2'b00 :fifo_full=full_0;
		2'b01 :fifo_full=full_1;
		2'b10 :fifo_full=full_2;
		default fifo_full=0;
	endcase
end

//3. valid out

assign vld_out_0 = ~empty_0;
assign vld_out_1 = ~empty_1;
assign vld_out_2 = ~empty_2;

//4. write enable
always@(*)
begin
if(write_en_reg)
begin
	case(temp) //address register
	2'b00 :write_en =3'b001;
	2'b01: write_en =3'b010;
	2'b10: write_en =3'b100;
	default:write_en=3'b000;
	endcase
end
	else
	write_en=3'b000;
end

endmodule