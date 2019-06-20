/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				game_background.v
Date				:				2018-05-11
Description			:				the game major playing interface

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180512		ctlvie		1.0			Initial Version
180514		ctlvie		1.1			Change the size of background picture (16bit -> 8bit)
180524		ctlvie		1.2			Add cursor display
180525		ctlvie		2.0			Final Version
========================================================*/

module game_background 
(
	input					clk,
	input					clk_4Hz,
	input					clk_8Hz,
	input					btn_mode_sel,
	input	[2:0]			mode,
	input 	[10:0]			VGA_xpos,
	input	[10:0]			VGA_ypos,
	output	reg	[11:0]		VGA_data
);

reg			startshow_enable ;

reg 	[16:0] 	addr_background_pic;
wire	[7:0]	background_pic;
reg 	[16:0] 	addr_gameover_pic;
reg		[16:0]	addr_start_pic;
wire	[2:0]	start_pic;	
reg		[2:0]	start_reg;
wire	[2:0]	gameover_pic;
reg 	[2:0]	gameover_reg;
wire	[11:0]	VGA_data_show;
reg		[11:0]	VGA_data_cursor;

always @(posedge clk)
begin
	if (mode!=0)
		startshow_enable <= 1'b0;
	else
		startshow_enable <= 1'b1;
	if(VGA_xpos > 0 && VGA_xpos <= 640 && VGA_ypos > 0 && VGA_ypos <= 480)
		addr_background_pic <= VGA_xpos[10:1] + 320 * VGA_ypos[10:1];
end

interface_pic 	u_interface_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_background_pic),  // input wire [16 : 0] addra
  .douta(background_pic)  // output wire [7 : 0] douta
);


//game over picture

always @(posedge clk)
begin
	if(VGA_xpos > 130 && VGA_xpos <= 510 && VGA_ypos > 120 && VGA_ypos <= 300)
	begin
		addr_gameover_pic <= (VGA_xpos - 130)  + 380 * (VGA_ypos - 120) ;
		gameover_reg <= gameover_pic ;
	end
	else
		gameover_reg <= 0;
end

gameove_pic u_gameover_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_gameover_pic),  // input wire [16 : 0] addra
  .douta(gameover_pic)  // output wire [2 : 0] douta
);


always @(posedge clk)
begin
	if(VGA_xpos > 95 && VGA_xpos <= 545 && VGA_ypos > 90 && VGA_ypos <= 290)
	begin
		addr_start_pic <= (VGA_xpos - 95)  + 450 * (VGA_ypos - 90) ;
		start_reg <= start_pic ;
	end
	else
		start_reg <= 0;
end

//-----------------------------------------------------------------------
// cursor display
// x:  95 + (134 ~ 138) = 229 ~ 233
// y1: 90 + (143 ~ 147) = 233 ~ 237
// y2: 90 + (162 ~ 166) = 252 ~ 256

always@(posedge clk)
begin
	if(btn_mode_sel)
	begin
		if(VGA_xpos >= 229 && VGA_xpos <= 233 && VGA_ypos >= 233 && VGA_ypos <= 237)
			VGA_data_cursor <= 12'hFF0;
		else
			VGA_data_cursor <= 12'h0;
	end
	else
	begin
		if(VGA_xpos >= 229 && VGA_xpos <= 233 && VGA_ypos >= 252 && VGA_ypos <= 256)
			VGA_data_cursor <= 12'hFF0;
		else
			VGA_data_cursor <= 12'h0;
	end

end




start_pic u_start_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_start_pic),  // input wire [16 : 0] addra
  .douta(start_pic)  // output wire [2 : 0] douta
);


game_startshow u_game_startshow
(
	.clk(clk),
	.clk_4Hz(clk_4Hz),
	.clk_8Hz(clk_8Hz),
	.enable(startshow_enable),
	.mode(mode),
	.VGA_xpos(VGA_xpos),
	.VGA_ypos(VGA_ypos),
	.VGA_data(VGA_data_show)
);


always@(posedge clk)
case	(mode)
	0 :
		begin
			VGA_data[0] 	= 	background_pic[4]	|	VGA_data_show[0]	|	start_reg[0]	|	VGA_data_cursor[0];
			VGA_data[1] 	=	background_pic[5]	|	VGA_data_show[1]	|	start_reg[0]	|	VGA_data_cursor[1];
			VGA_data[2] 	=	background_pic[5]	|	VGA_data_show[2]	|	start_reg[0]	|	VGA_data_cursor[2];
			VGA_data[3] 	=	background_pic[6]	|	VGA_data_show[3]	|	start_reg[0]	|	VGA_data_cursor[3];
			VGA_data[4] 	= 	background_pic[7]	|	VGA_data_show[4]	|	start_reg[1]	|	VGA_data_cursor[4];
			VGA_data[5] 	= 	background_pic[0]	|	VGA_data_show[5]	|	start_reg[1]	|	VGA_data_cursor[5];
			VGA_data[6] 	= 	background_pic[0]	|	VGA_data_show[6]	|	start_reg[1]	|	VGA_data_cursor[6];
			VGA_data[7] 	= 	background_pic[1]	|	VGA_data_show[7]	|	start_reg[1]	|	VGA_data_cursor[7];
			VGA_data[8] 	= 	background_pic[1]	|	VGA_data_show[8]	|	start_reg[2]	|	VGA_data_cursor[8];
			VGA_data[9] 	= 	background_pic[2]	|	VGA_data_show[9]	|	start_reg[2]	|	VGA_data_cursor[9];
			VGA_data[10] 	= 	background_pic[2]	|	VGA_data_show[10]	|	start_reg[2]	|	VGA_data_cursor[10];
			VGA_data[11] 	= 	background_pic[3]	|	VGA_data_show[11]	|	start_reg[2]	|	VGA_data_cursor[11];
		end
	1:
		begin
			VGA_data[0] 	= 	background_pic[4]	;
			VGA_data[1] 	=	background_pic[5]	;
			VGA_data[2] 	=	background_pic[5]	;
			VGA_data[3] 	=	background_pic[6]	;
			VGA_data[4] 	= 	background_pic[7]	;
			VGA_data[5] 	= 	background_pic[0]	;
			VGA_data[6] 	= 	background_pic[0]	;
			VGA_data[7] 	= 	background_pic[1]	;
			VGA_data[8] 	= 	background_pic[1]	;
			VGA_data[9] 	= 	background_pic[2]	;
			VGA_data[10] 	= 	background_pic[2]	;
			VGA_data[11] 	= 	background_pic[3]	;
		end
	2:
		begin
			VGA_data[0] 	= 	background_pic[4]	;
			VGA_data[1] 	=	background_pic[5]	;
			VGA_data[2] 	=	background_pic[5]	;
			VGA_data[3] 	=	background_pic[6]	;
			VGA_data[4] 	= 	background_pic[7]	;
			VGA_data[5] 	= 	background_pic[0]	;
			VGA_data[6] 	= 	background_pic[0]	;
			VGA_data[7] 	= 	background_pic[1]	;
			VGA_data[8] 	= 	background_pic[1]	;
			VGA_data[9] 	= 	background_pic[2]	;
			VGA_data[10] 	= 	background_pic[2]	;
			VGA_data[11] 	= 	background_pic[3]	;		
		end
	3:
		begin
			VGA_data[0] 	= 	background_pic[4]	| gameover_reg[0];
			VGA_data[1] 	=	background_pic[5]	| gameover_reg[0];
			VGA_data[2] 	=	background_pic[5]	| gameover_reg[0];
			VGA_data[3] 	=	background_pic[6]	| gameover_reg[0];
			VGA_data[4] 	= 	background_pic[7]	| gameover_reg[1];
			VGA_data[5] 	= 	background_pic[0]	| gameover_reg[1];
			VGA_data[6] 	= 	background_pic[0]	| gameover_reg[1];
			VGA_data[7] 	= 	background_pic[1]	| gameover_reg[1];
			VGA_data[8] 	= 	background_pic[1]	| gameover_reg[2];
			VGA_data[9] 	= 	background_pic[2]	| gameover_reg[2];
			VGA_data[10] 	= 	background_pic[2]	| gameover_reg[2];
			VGA_data[11] 	= 	background_pic[3]	| gameover_reg[2];		
		end

endcase
endmodule