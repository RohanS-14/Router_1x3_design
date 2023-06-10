module router_reg_tb();
reg rst,clk;
reg pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
reg [7:0] data_in;
wire [7:0] dout;
wire parity_done,error,low_pkt_valid;
integer i;

router_reg utt(rst,clk,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,error,dout);

//clk

initial
begin
clk=1'b0;
forever #5 clk=~clk;
end

//reset

task reset;
begin
  rst=1'b0;
  rst_int_reg=1'b1;
  #10;
  rst=1'b1;
  rst_int_reg=1'b0;
 end
 endtask

task intilise;
begin
ld_state=1'b1;
fifo_full=1'b1;
pkt_valid=1'b0;
#5 fifo_full=1'b0;
data_in=$random;
end
endtask

task din;
begin
detect_add=1'b1;
pkt_valid=1'b1;
data_in=$random;
lfd_state=1'b1;
fifo_full=1'b0;
end
endtask

task packet1();
	
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			begin
				@(negedge clk);
				payloadlen=8;
				parity=0;
				detect_add=1'b1;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in = header;
				parity=parity^data_in;

				@(negedge clk);
				detect_add=1'b0;
				lfd_state=1'b1;
		
				for(i=0;i<payloadlen;i=i+1)	
					begin
					@(negedge clk);	
					lfd_state=0;
					ld_state=1;
	
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end

					@(negedge clk);	
					pkt_valid =0;
					data_in=parity;
				
					@(negedge clk);
					ld_state=0;
					end
		
endtask

task packet2();
	
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			begin
				@(negedge clk);
				payloadlen=8;
				parity=0;
				detect_add=1'b1;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;

				@(negedge clk);
				detect_add=1'b0;
				lfd_state=1'b1;
		
				for(i=0;i<payloadlen;i=i+1)	
					begin
					@(negedge clk);	
					lfd_state=0;
					ld_state=1;
	
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end

					@(negedge clk);	
					pkt_valid=0;
					data_in=!parity;
				
					@(negedge clk);
					ld_state=0;
					end
		endtask

initial
begin
reset;
intilise;
din;
fifo_full=1'b0;
laf_state=1'b0;
full_state=1'b0;
reset;
packet1;
packet2;
$finish;
end

endmodule