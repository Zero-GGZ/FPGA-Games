/*
 * @Discription:  奖励信息的显示模块
 * @Author: Qin Boyu
 * @Date: 2019-05-14 00:59:57
 * @LastEditTime: 2019-05-19 10:21:42
 */

module reward_information
(
	input 				clk,
	input	[9:0]		reward_cnt,
	input				enable_reward,
	input				reward_protected,
	input				reward_grade,
	input				reward_slowly,
	input	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	output	reg	[11:0]	VGA_data
);

`define	RED			12'hF00
`define	GREEN		12'h0F0
`define	BLUE		12'h00F
`define	WHITE		12'hFFF
`define	BLACK		12'h000
`define	YELLOW		12'hFF0
`define	CYAN		12'hF0F
`define	ROYAL		12'h0FF
	
	

wire			dout_grade;
wire			dout_protected;
wire			dout_slowly;

reg		[9:0]	addr_slowly;
reg		[9:0]	addr_grade;
reg		[9:0]	addr_protected;

	

always@(posedge clk)
begin
if(enable_reward)
begin
	if(reward_slowly == 1 || reward_grade == 1 
		|| reward_protected == 1)		
	begin
		if(VGA_ypos >= 55 && VGA_ypos <= 65 
			&& VGA_xpos >= 520 && VGA_xpos <= (520 + (30 - reward_cnt) * 2))
			VGA_data <= `BLUE;
		else
			VGA_data <= `BLACK;
	end
	else
		VGA_data <= 0;
		
	if((VGA_xpos > 490)&&(VGA_xpos <= 514)&&(VGA_ypos > 48)&&(VGA_ypos < 72))
		begin
		addr_protected <= (VGA_xpos - 490 ) + 24 * (VGA_ypos - 48);
		addr_grade <= (VGA_xpos - 490 ) + 24 * (VGA_ypos - 48);
		addr_slowly <= (VGA_xpos - 490 ) + 24 * (VGA_ypos - 48);

		
		if (reward_slowly == 1'b1 && dout_slowly == 1'b1)
			VGA_data <= 12'hFF0;
		else if (reward_grade == 1'b1 && dout_grade == 1'b1)
			VGA_data <= 12'hFF0;
		else if (reward_protected == 1'b1 && dout_protected == 1'b1)
			VGA_data <= 12'hFF0;
		else
			VGA_data <= 0;
		
		end
end
else
	VGA_data <= 0;
end

pic_protected info_pic_protected (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_protected),  // input wire [9 : 0] addra
  .douta(dout_protected)  // output wire [0 : 0] douta
);

pic_slowly info_pic_slowly (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_slowly),  // input wire [9 : 0] addra
  .douta(dout_slowly)  // output wire [0 : 0] douta
);

pic_grade info_pic_grade (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_grade),  // input wire [9 : 0] addra
  .douta(dout_grade)  // output wire [0 : 0] douta
);


endmodule