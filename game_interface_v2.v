/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				game_interface_v2.v
Date				:				2018-05-11
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------
========================================================*/

module game_interface_v2 
(
	input				clk,
	input	[2:0]		mode,
	input 	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	output	reg	[11:0]		VGA_data
);

reg [16 : 0] 	addr_background_pic;
wire[16 : 0]	background_pic;
reg [14 : 0] 	addr_gameover_pic;
wire[16 : 0]	gameover_pic;
reg [16:0]		gameover_reg;


always @(posedge clk)
begin
	if(VGA_xpos > 0 && VGA_xpos <= 640 && VGA_ypos > 0 && VGA_ypos <= 480)
		addr_background_pic <= VGA_xpos[10:1] + 320 * VGA_ypos[10:1];
end


interface_pic u_interface_pic(
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_background_pic),  // input wire [16 : 0] addra
  .douta(background_pic)  // output wire [15 : 0] douta
);

always @(posedge clk)
begin
	if(VGA_xpos > 70 && VGA_xpos <= 570 && VGA_ypos > 70 && VGA_ypos <= 330)
	begin
		addr_gameover_pic <= ( VGA_xpos - 70) / 4  + 125 * ( VGA_ypos - 70)/4 - 2  ;
		gameover_reg <= gameover_pic ;
	end
	else
		gameover_reg <= 0;
end

gameover_pic u_gameover_pic (
  .clka(clk),    // input wire clka
  .addra(addr_gameover_pic),  // input wire [12 : 0] addra
  .douta(gameover_pic)  // output wire [15 : 0] douta
);



always@(posedge clk)
case	(mode)
	0 :
		begin
			VGA_data[0] 	= 	background_pic[1]	;
			VGA_data[1] 	=	background_pic[2]	;
			VGA_data[2] 	=	background_pic[3]	;
			VGA_data[3] 	=	background_pic[4]	;
			VGA_data[4] 	= 	background_pic[7]	;
			VGA_data[5] 	= 	background_pic[8]	;
			VGA_data[6] 	= 	background_pic[9]	;
			VGA_data[7] 	= 	background_pic[10]	;
			VGA_data[8] 	= 	background_pic[12]	;
			VGA_data[9] 	= 	background_pic[13]	;
			VGA_data[10] 	= 	background_pic[14]	;
			VGA_data[11] 	= 	background_pic[15]	;
		end
	1:
		begin
			VGA_data[0] 	= 	background_pic[1]	;
			VGA_data[1] 	=	background_pic[2]	;
			VGA_data[2] 	=	background_pic[3]	;
			VGA_data[3] 	=	background_pic[4]	;
			VGA_data[4] 	= 	background_pic[7]	;
			VGA_data[5] 	= 	background_pic[8]	;
			VGA_data[6] 	= 	background_pic[9]	;
			VGA_data[7] 	= 	background_pic[10]	;
			VGA_data[8] 	= 	background_pic[12]	;
			VGA_data[9] 	= 	background_pic[13]	;
			VGA_data[10] 	= 	background_pic[14]	;
			VGA_data[11] 	= 	background_pic[15]	;
		end
	2:
		begin
			VGA_data[0] 	= 	background_pic[1] 	| gameover_reg[1];
			VGA_data[1] 	=	background_pic[2]	| gameover_reg[2];
			VGA_data[2] 	=	background_pic[3]	| gameover_reg[3];
			VGA_data[3] 	=	background_pic[4]	| gameover_reg[4];
			VGA_data[4] 	= 	background_pic[7]	| gameover_reg[7];
			VGA_data[5] 	= 	background_pic[8]	| gameover_reg[8];
			VGA_data[6] 	= 	background_pic[9]	| gameover_reg[9];
			VGA_data[7] 	= 	background_pic[10]	| gameover_reg[10];
			VGA_data[8] 	= 	background_pic[12]	| gameover_reg[12];
			VGA_data[9] 	= 	background_pic[13]	| gameover_reg[13];
			VGA_data[10] 	= 	background_pic[14]	| gameover_reg[14];
			VGA_data[11] 	= 	background_pic[15]	| gameover_reg[15];		
		end

endcase
endmodule