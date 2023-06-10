module router_sync_tb();

reg clk,rst,detect_add,write_en_reg; 
reg [1:0]data_in;
reg full_0,full_1,full_2,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2;
wire[2:0] write_en;
wire vld_out_0,soft_reset_0, vld_out_1,soft_reset_1, vld_out_2,soft_reset_2; 
wire fifo_full;
realtime t1,t2;

router_sync dut(clk,rst,detect_add,write_en_reg,data_in,full_0,full_1,full_2,empty_0,empty_1,empty_2,read_enb_0,read_enb_1,read_enb_2,write_en,vld_out_0,soft_reset_0, vld_out_1,soft_reset_1, vld_out_2,soft_reset_2, fifo_full);

initial
begin 
clk=1'b1;
forever #5
clk=~clk; 
end

task initialize();
begin
@(negedge clk)
	{empty_0,empty_1,empty_2}=3'bzzz;
	rst=1'b1;
	empty_0=1'b0;
	detect_add=1'b0;
	data_in=2'bzz;
	write_en_reg=1'b1;
	read_enb_0=1'b1;
end
endtask

task reset;
		begin
			rst=1'b0;
			#10;
			rst=1'b1;
		end
	endtask

task run();
begin
@(negedge clk)
			
		detect_add=1'b1;
		data_in=2'b10;
		read_enb_0=1'b0;
		read_enb_1=1'b1;
		read_enb_2=1'b0;
		write_en_reg =1'b1;
		full_0=1'b0;
		full_1=1'b1;
		full_2=1'b1;
		empty_0=1'b1;
		empty_1=1'b0;
		empty_2=1'b0;
	
	@(posedge clk) t1= $realtime;
	
end
endtask

task run1();
begin
@(negedge clk)
		detect_add=1'b1;
		data_in=2'b00;
		read_enb_0=1'b1;
		read_enb_1=1'b1;
		read_enb_2=1'b0;
		write_en_reg =1'b1;
		full_0=1'b0;
		full_1=1'b1;
		full_2=1'b1;
		empty_0=1'b1;
		empty_1=1'b0;
		empty_2=1'b0;
		read_enb_0=1'b0;#70;
	
	@(posedge clk) t1= $realtime;
	
end
endtask

task run2();
begin
@(negedge clk)
		detect_add=1'b1;
		data_in=2'b10;
		read_enb_1=1'b0;
		read_enb_2=1'b1;
		write_en_reg =1'b1;
		full_0=1'b0;
		full_1=1'b1;
		full_2=1'b0;
		empty_0=1'b0;
		empty_1=1'b0;
		empty_2=1'b1;
		read_enb_0=1'b0;#70;
	
	@(posedge clk) t1= $realtime;
	
end
endtask

initial
begin
	initialize;
	reset;
	run;
	run1;
	initialize;
	reset;
	run2;
$finish();
end


endmodule
	




	