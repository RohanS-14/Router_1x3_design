module router_fifo_tb();

parameter depth = 16;
parameter width=9 ; 

reg clk,rst,write_en,soft_reset,read_enb,lfd_state;
reg [7:0] data_in;
wire [7:0] data_out;
wire empty,full;

integer i;

router_fifo dut(clk,rst,write_en,soft_reset,read_enb,data_in,lfd_state,empty,data_out,full);

initial
begin
clk=1'b1;
forever #5 clk=~clk;
end

//test for write operation

task write(input we);
begin
@(negedge clk)
	data_in= $random;
	write_en=we;
end
endtask		

//test for read operation

task read(input re);
begin
@(negedge clk)
	read_enb=re;
end
endtask

//initilize 
task initilize();
begin
@(negedge clk)
	rst=0;#5;
	soft_reset=1;#5;
	rst=1;soft_reset=0;
	lfd_state=1;
	read_enb=0;
	write_en=0;
end
endtask

//test 

initial
begin
	initilize;
	write(0);
	read(0);#20;
	repeat(17)
	begin
	write(1);
	#10;
	end
	write(0);#5;
	read(1);#100;
	$finish();
end 
/*
initial 
	begin
	rst=1'b0;
	#10;
	rst=1'b1;
	soft_reset=1'b0;
	lfd_state=1'b1;
	write_enb=1'b1;
	#10;
	repeat(17)
		begin
			data_in=$random;
			#10;
		end
	write_enb=1'b0;
	#5;
	
	read_enb=1'b1;
	#100;
	
 
	$finish; 
end */ 

endmodule
