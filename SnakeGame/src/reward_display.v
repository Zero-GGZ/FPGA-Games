/*
 * @Discription:  奖励标志显示模块
 * @Author: Qin Boyu
 * @Date: 2019-05-14 00:45:44
 * @LastEditTime: 2019-05-18 10:02:19
 */

`define	RED			12'hF00
`define	GREEN		12'h0F0
`define	BLUE		12'h00F
`define	WHITE		12'hFFF
`define	BLACK		12'h000
`define	YELLOW		12'hFF0
`define	CYAN		12'hF0F
`define	ROYAL		12'h0FF
`timescale 1ns/1ns
module	reward_display
(
	input					clk,
	input					set_require,
	input					enable_reward,
	input		[5:0]		random_xpos,
	input		[5:0]		random_ypos,
	input		[1:0]		reward_type,
	input		[10:0]		VGA_xpos,
	input		[10:0]		VGA_ypos,
	output reg	[11:0]		VGA_data
);

reg		[9:0]	addr_protected;
reg		[9:0]	addr_grade;
reg		[9:0]	addr_slowly;

wire			dout_protected;
wire			dout_grade;
wire			dout_slowly;



always@(posedge clk)
begin
	if(set_require == 1 && enable_reward == 1)
	begin
		if( (VGA_xpos > random_xpos * 20 + 80 - 12)
		&&(VGA_xpos <= random_xpos * 20 + 80 + 12)
		&&(VGA_ypos > random_ypos * 20 + 80 - 12)
		&&(VGA_ypos <= random_ypos * 20 + 80 + 12) )
		begin
			addr_protected <= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			addr_grade	 <= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			addr_slowly  <= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			
			case(reward_type)
			2'b01 : 	
					begin
						if(dout_protected == 1)
							VGA_data <= 12'hFFF;
						else
							VGA_data <= 0;
					end
			2'b10 :
					begin
						if(dout_grade == 1)
							VGA_data <= 12'hFFF;
						else
							VGA_data <= 0;
					end
			2'b11 :
					begin
						if(dout_slowly == 1)
							VGA_data <= 12'hFFF;
						else
							VGA_data <= 0;
					end
			endcase
		end
		else
			begin
			VGA_data <= 0;
			end
	end
	else
		begin
		VGA_data <= 0;
		end
end



pic_protected u_pic_protected (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_protected),  // input wire [9 : 0] addra
  .douta(dout_protected)  // output wire [0 : 0] douta
);

pic_slowly u_pic_slowly (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_slowly),  // input wire [9 : 0] addra
  .douta(dout_slowly)  // output wire [0 : 0] douta
);

pic_grade u_pic_grade (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_grade),  // input wire [9 : 0] addra
  .douta(dout_grade)  // output wire [0 : 0] douta
);

endmodule
