/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				game_information.v
Date				:				2018-05-11
Description			:				To print information of mode and your HP_value or time on the screen

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180515		QiiNn		1.0			Initial Version
========================================================*/



module	game_information
(
	input				clk,
	input				enable_game_classic,
	input				enable_game_infinity,
	input				enable_information,
	input	[2:0]		mode,
	input	[4:0]		HP_print,
	input	[4:0]		time_print,
	input				clk_VGA,
	input	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	output	reg	[11:0]	VGA_data
)

`define	RED			12'hF00
`define	GREEN		12'h0F0
`define	BLUE		12'h00F
`define	WHITE		12'hFFF
`define	BLACK		12'h000
`define	YELLOW		12'hFF0
`define	CYAN		12'hF0F
`define	ROYAL		12'h0FF

always@(posedge clk)
begin
	if(enable_game_classic || enable_game_infinity )
	begin
		if	( (VGA_xpos == 120 && VGA_ypos >= 52 && VGA_ypos <= 68) 
			||(VGA_xpos == 300 && VGA_ypos >= 52 && VGA_ypos <= 68)	
			||(VGA_ypos == 52 && VGA_xpos >= 120 && VGA_xpos <= 300)
			||(VGA_ypos == 68 && VGA_xpos >= 120 && VGA_xpos <= 300) )
			VGA_data <= `RED;
		if(enable_game_classic)
		begin
			if (VGA_ypos >= 52 && VGA_ypos <= 68 && VGA_xpos >= 120 + HP_print * 20 && VGA_xpos <= 300)
			begin
				if (VGA_xpos == 140 || VGA_xpos == 160 || VGA_xpos == 180 || VGA_xpos == 200
					|| VGA_xpos == 220 || VGA_xpos == 240 || VGA_xpos == 260 || VGA_xpos == 280 )
					VGA_data <= `BLACK;
				else
					VGA_data <= `RED;
			end
		end
		else
		begin
			if (VGA_ypos >= 52 && VGA_ypos <= 68 && VGA_xpos >= 120 + time_print * 10 && VGA_xpos <= 300)
			begin
				if (VGA_xpos == 130 || VGA_xpos == 140 || VGA_xpos == 150 || VGA_xpos == 160
					|| VGA_xpos == 170 || VGA_xpos == 180 || VGA_xpos == 190 || VGA_xpos == 200
					|| VGA_xpos == 210 || VGA_xpos == 220 || VGA_xpos == 230 || VGA_xpos == 240
					|| VGA_xpos == 250 || VGA_xpos == 260 || VGA_xpos == 270 || VGA_xpos == 280 || VGA_xpos == 290)
					VGA_data <= `BLACK;
				else
					VGA_data <= `RED;
			end
		end
	end
end

endmodule
