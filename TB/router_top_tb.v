module router_top_tb();

reg clk,rst,read_en_0,read_en_1,read_en_2,pkt_valid;
reg [7:0] data_in;
wire [7:0] data_out_0,data_out_1,data_out_02;
wire vld_out_0,vld_out_1,vld_out_2,error,busy;
integer i;

router_top dut(clk,rst,read_en_0,read_en_1,read_en_2,pkt_valid,data_in,data_out_0,data_out_1,data_out_02,vld_out_0,vld_out_1,vld_out_2,error,busy);

initial
begin
clk=1'b1;
forever
#5 clk=~clk;
end

task reset;
begin
@(negedge clk)
clk=1'b0;
@(negedge clk)
clk=1'b1;
end
endtask

task pktm_gen_4;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [3:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=4;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
					repeat(30)
			@(negedge clk);
			read_en_1=1'b1;
			end
endtask 

task pktm_gen_14_0;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [13:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=14;
				pkt_valid=1'b1;
				header={payloadlen,2'b00};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
					repeat(30)
			@(negedge clk);
			read_en_0=1'b1;
			end
endtask 

task pktm_gen_14_1;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [13:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=13;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
					repeat(30)
			@(negedge clk);
			read_en_2=1'b1;
			end
endtask 

task pktm_gen_14_2;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [13:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=13;
				pkt_valid=1'b1;
				header={payloadlen,2'b00};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
					repeat(30)
			@(negedge clk);
			read_en_0=1'b1;
			end
endtask 

task pktm_gen_16_0;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [15:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=16;
				pkt_valid=1'b1;
				header={payloadlen,2'b00};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
					repeat(30)
			@(negedge clk);
			read_en_1=1'b0;
			end
endtask 

initial
begin
reset;
#20;
pktm_gen_4;
pktm_gen_14_0;
pktm_gen_14_1;
pktm_gen_14_2;
pktm_gen_16_0;
#1500; 
$finish();
end

endmodule