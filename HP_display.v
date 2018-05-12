/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				HP_display.v
Date				:				2018-05-11
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------

========================================================*/

module HP_display 
(
	input	clk,
	input	enable,
	input	[10:0]	VGA_xpos,
	input	[10:0]	VGA_ypos,
	output	[11:0]	VGA_data
);


always @(posedge clk)
begin
	if(VGA_xpos > 70 && VGA_xpos <= 570 && VGA_ypos > 70 && VGA_ypos <= 330)
	begin
		addr_gameover_pic <= ( VGA_xpos[10:2] - 70 ) + 125 * VGA_ypos[10:2] ;
		gameover_reg <= gameover_pic ;
	end
	else
		gameover_reg <= 0;
end

`define 	X_START		540	
`define		Y_START		65
`define		SPACING		25
`define		WIDTH		20
always@(posedge clk)
begin
if(enable)
	begin
	case(HP_value)
	1:
		begin 
		if(VGA_xpos > `X_START - `SPACING * 0 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 0 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		end
	2:
		begin 
		if(VGA_xpos > `X_START - `SPACING * 0 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 0 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 1 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 1 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		end
	3:
		begin 
		if(VGA_xpos > `X_START - `SPACING * 0 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 0 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 1 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 1 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 2 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 2 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		end
	4:
		begin 
		if(VGA_xpos > `X_START - `SPACING * 0 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 0 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 1 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 1 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 2 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 2 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 3 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 3 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		end
	5:
		begin 
		if(VGA_xpos > `X_START - `SPACING * 0 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 0 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 1 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 1 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 2 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 2 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 3 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 3 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		if(VGA_xpos > `X_START - `SPACING * 4 && VGA_xpos <= `X_START + `WIDTH - `SPACING * 4 && VGA_ypos > `Y_START && VGA_ypos <= `Y_START + `WIDTH)
			addr_HP_pic <= (VGA_xpos[10:0] - `X_START - `SPACING * 0) + `WIDTH * VGA_ypos[10:0];
		end
	endcase
	end
end


endmodule 