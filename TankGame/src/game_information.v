/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				game_information.v
Date				:				2018-05-11
Description			:				To print information of mode and your HP_value or time on the screen

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180515		ctlvie		1.0			Initial Version
180525		ctlvie		2.0			Final Version
========================================================*/



module	game_information
(
	input				clk,
	input				enable_game_classic,
	input				enable_game_infinity,
	input	[2:0]		mode,
	input	[4:0]		HP_print,
	input	[5:0]		time_print,
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

reg		[11:0]	addr_info_classic;
reg		[11:0]	addr_info_infinity;
wire	[0:0]	dout_info_classic;
wire	[0:0]	dout_info_infinity;
reg		[11:0]	VGA_data_1;
reg		[11:0]	VGA_data_2;

always @(posedge clk)
begin
	if(enable_game_classic)
	begin
		if(VGA_xpos > 130 && VGA_xpos <= 310 && VGA_ypos > 50 && VGA_ypos <= 70)
		begin
			addr_info_classic <= (VGA_xpos - 130)  + 180 * (VGA_ypos - 50) ;
			if(dout_info_classic)
				VGA_data_1 <= 12'hFFF;
			else
				VGA_data_1 <= 0;
		end
			else
				VGA_data_1 <= 0;
	end
	else if (enable_game_infinity)
	begin
		if(VGA_xpos > 130 && VGA_xpos <= 310 && VGA_ypos > 50 && VGA_ypos <= 70)
		begin
			addr_info_infinity <= (VGA_xpos - 130)  + 180 * (VGA_ypos - 50) ;
			if(dout_info_infinity)
				VGA_data_1 <= 12'hFFF;
			else
				VGA_data_1 <= 0;
		end
		else
				VGA_data_1 <= 0;
	end
	else
		VGA_data_1 <= 0;
end

info_classic_pic u_info_classic_pic(
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_info_classic),  // input wire [11 : 0] addra
  .douta(dout_info_classic)  // output wire [0 : 0] douta
);

info_infinity_pic u_info_infinity_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_info_infinity),  // input wire [11 : 0] addra
  .douta(dout_info_infinity)  // output wire [0 : 0] douta
);


always@(posedge clk)
begin
	if(enable_game_classic || enable_game_infinity )
	begin
		if	( (VGA_xpos == 320 && VGA_ypos >= 55 && VGA_ypos <= 65) 
			||(VGA_xpos == 500 && VGA_ypos >= 55 && VGA_ypos <= 65)	
			||(VGA_ypos == 55 && VGA_xpos >= 320 && VGA_xpos <= 500)
			||(VGA_ypos == 65 && VGA_xpos >= 320 && VGA_xpos <= 500) )
			VGA_data_2 <= `RED;
		else
			VGA_data_2 <= `BLACK;
		if(enable_game_classic)
		begin
			if (VGA_ypos >= 55 && VGA_ypos <= 65 && VGA_xpos >= 320 && (VGA_xpos <= 320 + HP_print * 20))
			begin
				if (VGA_xpos == 340 || VGA_xpos == 360 || VGA_xpos == 380 || VGA_xpos == 400
					|| VGA_xpos == 420 || VGA_xpos == 440 || VGA_xpos == 460 || VGA_xpos == 480 )
					VGA_data_2 <= `BLACK;
				else
					VGA_data_2 <= `RED;
			end
			else
				VGA_data_2 <= `BLACK;
		end
		else
		begin
			if (VGA_ypos >= 55 && VGA_ypos <= 65 && VGA_xpos >= 320 && (VGA_xpos <= 320 + time_print * 10))
			begin
				if (VGA_xpos == 330 || VGA_xpos == 340 || VGA_xpos == 350 || VGA_xpos == 360
					|| VGA_xpos == 370 || VGA_xpos == 380 || VGA_xpos == 390 || VGA_xpos == 400
					|| VGA_xpos == 410 || VGA_xpos == 420 || VGA_xpos == 430 || VGA_xpos == 440
					|| VGA_xpos == 450 || VGA_xpos == 460 || VGA_xpos == 470 || VGA_xpos == 480 || VGA_xpos == 490)
					VGA_data_2 <= `BLACK;
				else
					VGA_data_2 <= `RED;
			end
			else
				VGA_data_2 <= `BLACK;
		end
	end
	else
		VGA_data_2 <= `BLACK;
end

always@(posedge clk)
	VGA_data <= VGA_data_1 | VGA_data_2;

endmodule
