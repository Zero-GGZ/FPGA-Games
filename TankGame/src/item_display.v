/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				item_display.v
Date				:				2018-05-22
Description			:				Display the reward countdown timer on the screen

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180522		ctlvie		1.0			Initial Version
180524		ctlvie		1.2			Add enable interface
180525		ctlvie		2.0			Final Version
========================================================*/
`define	RED			12'hF00
`define	GREEN		12'h0F0
`define	BLUE		12'h00F
`define	WHITE		12'hFFF
`define	BLACK		12'h000
`define	YELLOW		12'hFF0
`define	CYAN		12'hF0F
`define	ROYAL		12'h0FF
`timescale 1ns/1ns
module	item_display
(
	input					clk,
	input					set_require,
	input					enable_reward,
	input		[4:0]		random_xpos,
	input		[4:0]		random_ypos,
	input		[2:0]		item_type,
	input		[10:0]		VGA_xpos,
	input		[10:0]		VGA_ypos,
	input					enable_game_classic,
	input					enable_game_infinity,
	output reg	[11:0]		VGA_data
);

reg		[9:0]	addr_addtime;
reg		[9:0]	addr_laser;
reg		[9:0]	addr_faster;
reg		[9:0]	addr_frozen;
reg		[9:0]	addr_protect;

wire			dout_addtime;
wire			dout_faster;
wire			dout_frozen;
wire			dout_laser;
wire			dout_protect;


always@(posedge clk)
begin
	if(set_require == 1 && enable_reward == 1)
	begin
		if( (VGA_xpos > random_xpos * 20 + 80 - 12)
		&&(VGA_xpos <= random_xpos * 20 + 80 + 12)
		&&(VGA_ypos > random_ypos * 20 + 80 - 12)
		&&(VGA_ypos <= random_ypos * 20 + 80 + 12) )
		begin
			addr_addtime <= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			addr_faster	 <= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			addr_frozen  <= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			addr_laser	<= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			addr_protect <= ( VGA_xpos - (random_xpos * 20 + 80 - 12)) + 24 *(VGA_ypos - (random_ypos * 20 + 80 - 12));
			
			case(item_type)
			3'b001 : 	
					begin
						if((dout_protect == 1 && enable_game_classic == 1) || (dout_addtime == 1 && enable_game_infinity == 1))
							VGA_data <= 12'hFFF;
						else
							VGA_data <= 0;
					end
			3'b010 :
					begin
						if(dout_faster == 1)
							VGA_data <= 12'hFFF;
						else
							VGA_data <= 0;
					end
			3'b011 :
					begin
						if(dout_frozen == 1)
							VGA_data <= 12'hFFF;
						else
							VGA_data <= 0;
					end
			3'b100 :
					begin
						if(dout_laser == 1)
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



addtime_pic u_addtime_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_addtime),  // input wire [9 : 0] addra
  .douta(dout_addtime)  // output wire [0 : 0] douta
);

frozen_pic u_frozen_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_frozen),  // input wire [9 : 0] addra
  .douta(dout_frozen)  // output wire [0 : 0] douta
);

faster_pic u_faster_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_faster),  // input wire [9 : 0] addra
  .douta(dout_faster)  // output wire [0 : 0] douta
);

protect_pic u_protect_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_protect),  // input wire [9 : 0] addra
  .douta(dout_protect)  // output wire [0 : 0] douta
);

laser_pic u_laser_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_laser),  // input wire [9 : 0] addra
  .douta(dout_laser)  // output wire [0 : 0] douta
);


endmodule