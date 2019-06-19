/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				item_information.v
Date				:				2018-05-23
Description			:				To print information of reward timer

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180523		ctlvie		1.0			Initial Version
180524		ctlvie		1.2			Add enable interface
180525		ctlvie		2.0			Final Version
========================================================*/

module item_information
(
	input 				clk,
	input	[9:0]		item_cnt,
	input				enable_reward,
	input				item_invincible,
	input				item_frozen,
	input				item_faster,
	input				item_laser,
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
	
	
wire			dout_addtime;
wire			dout_faster;
wire			dout_frozen;
wire			dout_laser;
wire			dout_protect;
reg		[9:0]	addr_addtime;
reg		[9:0]	addr_laser;
reg		[9:0]	addr_faster;
reg		[9:0]	addr_frozen;
reg		[9:0]	addr_protect;	
	

always@(posedge clk)
begin
if(enable_reward)
begin
	if(item_laser == 1 || item_faster == 1 
		|| item_frozen == 1 || item_invincible == 1)		
	begin
		if(VGA_ypos >= 55 && VGA_ypos <= 65 
			&& VGA_xpos >= 520 && VGA_xpos <= (520 + (30 - item_cnt) * 2))
			VGA_data <= `BLUE;
		else
			VGA_data <= `BLACK;
	end
	else
		VGA_data <= 0;
		
	if((VGA_xpos > 490)&&(VGA_xpos <= 514)&&(VGA_ypos > 48)&&(VGA_ypos < 72))
		begin
		addr_frozen <= (VGA_xpos - 490 ) + 24 * (VGA_ypos - 48);
		addr_faster <= (VGA_xpos - 490 ) + 24 * (VGA_ypos - 48);
		addr_laser <= (VGA_xpos - 490 ) + 24 * (VGA_ypos - 48);
		addr_protect <= (VGA_xpos - 490 ) + 24 * (VGA_ypos - 48);
		
		if (item_laser == 1'b1 && dout_laser == 1'b1)
			VGA_data <= 12'hFF0;
		else if (item_faster == 1'b1 && dout_faster == 1'b1)
			VGA_data <= 12'hFF0;
		else if (item_frozen == 1'b1 && dout_frozen == 1'b1)
			VGA_data <= 12'hFF0;
		else if (item_invincible == 1'b1 && dout_protect == 1'b1)
			VGA_data <= 12'hFF0;
		else
			VGA_data <= 0;
		
		end
end
else
	VGA_data <= 0;
end


frozen_pic info_frozen_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_frozen),  // input wire [9 : 0] addra
  .douta(dout_frozen)  // output wire [0 : 0] douta
);

faster_pic info_faster_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_faster),  // input wire [9 : 0] addra
  .douta(dout_faster)  // output wire [0 : 0] douta
);

protect_pic info_protect_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_protect),  // input wire [9 : 0] addra
  .douta(dout_protect)  // output wire [0 : 0] douta
);

laser_pic info_laser_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_laser),  // input wire [9 : 0] addra
  .douta(dout_laser)  // output wire [0 : 0] douta
);



endmodule