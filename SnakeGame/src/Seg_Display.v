/*
 * @Discription:  数码管计分模块
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:22:00
 */

module seg_display
(
	input clk,
	input rst,
	
	input add_cube,
	input	reward_grade,
	inout [1:0]game_status,
	
	output reg[7:0]seg_out,
	output reg[3:0]sel
);

	reg addPointActive;
    localparam RESTART = 2'b00;
    
	reg[15:0]point;
	reg[31:0]clk_cnt;
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst)
			begin
				seg_out <= 0;
				clk_cnt <= 0;
				sel <= 0;
			end
	    else if (game_status == RESTART) begin
	    seg_out <= 0;
            clk_cnt <= 0;
            sel <= 0;                
        end
		else
			begin
				if(clk_cnt <= 20_0000)	
				begin
					clk_cnt <= clk_cnt+1;
					if(clk_cnt == 5_0000)
						begin
							sel <= 4'b0111;
							case(point[3:0])
								4'b0000:seg_out <= 8'b1100_0000;
								4'b0001:seg_out <= 8'b1111_1001;
								4'b0010:seg_out <= 8'b1010_0100;
								
								4'b0011:seg_out <= 8'b1011_0000;
								4'b0100:seg_out <= 8'b1001_1001;
								4'b0101:seg_out <= 8'b1001_0010;
								
								4'b0110:seg_out <= 8'b1000_0010;
								4'b0111:seg_out <= 8'b1111_1000;
								4'b1000:seg_out <= 8'b1000_0000;
								4'b1001:seg_out <= 8'b1001_0000;
								default;
							endcase					
						end					
					else if(clk_cnt == 10_0000)
						begin
							sel <= 4'b1011;							
							case(point[7:4])
								4'b0000:seg_out <= 8'b1100_0000;
								4'b0001:seg_out <= 8'b1111_1001;
								4'b0010:seg_out <= 8'b1010_0100;
								
								4'b0011:seg_out <= 8'b1011_0000;
								4'b0100:seg_out <= 8'b1001_1001;
								4'b0101:seg_out <= 8'b1001_0010;
								
								4'b0110:seg_out <= 8'b1000_0010;
								4'b0111:seg_out <= 8'b1111_1000;
								4'b1000:seg_out <= 8'b1000_0000;
								4'b1001:seg_out <= 8'b1001_0000;
								default;							
							endcase							
						end					
					else if(clk_cnt == 15_0000)
						begin
							sel <= 4'b1101;
							case(point[11:8])
								4'b0000:seg_out <= 8'b1100_0000;
								4'b0001:seg_out <= 8'b1111_1001;
								4'b0010:seg_out <= 8'b1010_0100;
								
								4'b0011:seg_out <= 8'b1011_0000;
								4'b0100:seg_out <= 8'b1001_1001;
								4'b0101:seg_out <= 8'b1001_0010;
								
								4'b0110:seg_out <= 8'b1000_0010;
								4'b0111:seg_out <= 8'b1111_1000;
								4'b1000:seg_out <= 8'b1000_0000;
								4'b1001:seg_out <= 8'b1001_0000;
								default;					
							endcase
						end					
					else if(clk_cnt == 20_0000)
						begin
						    sel <= 4'b1110;
							case(point[15:12])
								4'b0000:seg_out <= 8'b1100_0000;
								4'b0001:seg_out <= 8'b1111_1001;
								4'b0010:seg_out <= 8'b1010_0100;
								
								4'b0011:seg_out <= 8'b1011_0000;
								4'b0100:seg_out <= 8'b1001_1001;
								4'b0101:seg_out <= 8'b1001_0010;
								
								4'b0110:seg_out <= 8'b1000_0010;
								4'b0111:seg_out <= 8'b1111_1000;
								4'b1000:seg_out <= 8'b1000_0000;
								4'b1001:seg_out <= 8'b1001_0000;
								default;					
							endcase
						end				
				end				
				else
					clk_cnt <= 0;
			end		
	end
	
	reg addcube_state;
	
	always@(posedge clk or negedge rst)
		begin
			if(!rst)
				begin
					point <= 0;
					addcube_state <= 0;	
					addPointActive <= 1;				
				end
			else if (game_status == RESTART) begin
                point <= 0;
                addcube_state <= 0;
				addPointActive <= 1;              
            end
			else begin
				case(addcube_state)				
				    0: begin				
					    if(add_cube) begin
					        if(point[3:0] < 9)
						        point[3:0] <= point[3:0] + 1;
					        else begin
						        point[3:0] <= 0;
							    if(point[7:4] < 9)
							 	    point[7:4] <= point[7:4] + 1;
							    else begin
								    point[7:4] <= 0;
								    if(point[11:8] < 9)
									    point[11:8] <= point[11:8] + 1;
								    else begin
								        point[11:8] <= 0;
									    point[15:12] <= point[15:12] + 1;
								    end
							    end
						    end						
					       addcube_state <= 1;
				        end
				    end				
				    1: begin
				        if(!add_cube)
					        addcube_state <= 0;
				    end				
				endcase

				if(reward_grade == 1)
				begin
					if(addPointActive == 1)
					begin
						addPointActive <= 0;
						if(point[3:0] < 9)
							point[3:0] <= point[3:0] + 1;
						else begin
							point[3:0] <= 0;
							if(point[7:4] < 9)
								point[7:4] <= point[7:4] + 1;
							else begin
								point[7:4] <= 0;
								if(point[11:8] < 9)
									point[11:8] <= point[11:8] + 1;
								else begin
									point[11:8] <= 0;
									point[15:12] <= point[15:12] + 1;
								end
							end
						end
					end
				end
				else
					addPointActive <= 1;	
			end										
	end								
endmodule