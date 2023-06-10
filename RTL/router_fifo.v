//fifo router project

module router_fifo(clk,rst,write_en,soft_reset,read_enb,data_in,lfd_state,empty,data_out,full);

parameter depth = 16;
parameter width=9 ; //9th bit is for header

input clk,rst,write_en,soft_reset,read_enb,lfd_state; //soft_reset is time ,,,,,Ifd_state detects the header byte
input [7:0] data_in;
output reg [7:0] data_out;
output empty,full;

reg [4:0] wr_ptr,rd_ptr;
reg [width-1:0] mem [depth-1:0];
reg [6:0] fifocounter;
reg temp;
integer i;
//------------------------------------------------------------------------------------------------------------------------------------
//lfd_state as we are getting data in from register we have to delay by 1 clk pulse

always@(posedge clk)
	begin
	if(!rst)
		temp<=1'b0;
		else
		temp<=lfd_state;
		end
//------------------------------------------------------------------------------------------------------------------------------------		
//empty or full
assign full = (wr_ptr=={~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;
assign empty = (wr_ptr==rd_ptr)?1'b1:1'b0;
//------------------------------------------------------------------------------------------------------------------------------------
//pointer logic
	
always@(posedge clk)
begin
	if(!rst || soft_reset)
		begin
			rd_ptr<=5'b00000;
			wr_ptr<=5'b00000;
		end
	else
		begin
			if(!full && write_en)
			wr_ptr <= wr_ptr+1;
			else
			wr_ptr <= wr_ptr;
			
			if(!empty && read_enb)
			rd_ptr <= rd_ptr+1;
			else
			rd_ptr <= rd_ptr;
	end
end

//------------------------------------------------------------------------------------------------------------------------------------
//counter logic
always@(posedge clk)
begin
	if(rd_ptr & ~empty)
		begin
			if(mem[rd_ptr[3:0]][8])
				fifocounter <= mem[rd_ptr[3:0]][7:2]+1'b1;
			else if(fifocounter !=0)
				fifocounter<= fifocounter-1'b1;
		end
		
end 
//------------------------------------------------------------------------------------------------------------------------------------
//1. read opertation

always@(posedge clk)
	begin
		if(!rst)
		data_out<=8'd0;
		else if(soft_reset)
		data_out<=8'dz;
		else
			begin
			if(fifocounter==0)
				data_out<=8'dz;
			if(read_enb && !empty)
				data_out <= mem[rd_ptr[3:0]];
			end
		
	end
//------------------------------------------------------------------------------------------------------------------------------------
//2. write operation

always@(posedge clk)
	begin
		if(!rst)
		begin
			for(i=0;i<16;i=i+1)
			begin
				mem[i]<=0;
			end
		end
		
		else if(soft_reset)
		begin
			for(i=0;i<16;i=i+1)
			begin
				mem[i]<=0;
			end
		end
		
		else if(write_en && !full)
			
			{mem[wr_ptr[3:0]][8],mem[wr_ptr[4:0]][7:0]}<={temp,data_in};
	
	end

endmodule
	