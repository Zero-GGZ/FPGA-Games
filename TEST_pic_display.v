/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				TEST_pic_display.v
Date				:				2018-05-12
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------

========================================================*/

module TEST_pic_display 
(	
	input 					clk,
	
	input 					bt_w,
	input 					bt_a,
	input 					bt_s,
	input 					bt_d,
	input 					bt_st,
	input		[4:0]		sw,	
	output					Hsync,
	output					Vsync,
	output		[3:0]		vgaRed,
	output		[3:0]		vgaBlue,
	output		[3:0]		vgaGreen,
	output		[3:0]		an,
	output		[6:0]		seg,
	output					dp,
	output		[15:0]		led
);

wire	clk_2Hz;
wire	clk_4Hz;
wire	clk_8Hz;
wire	clk_100M;
wire	clk_VGA;
wire	[10:0]	VGA_xpos;
wire	[10:0]	VGA_ypos;
wire	[11:0]	VGA_data;
reg		[2:0]	VGA_3bit_data;

clk_wiz_0 u_VGA_clock
   (
    // Clock out ports
    .clk_out1	(clk_100M),     // output clk_out1
    .clk_out2	(clk_VGA),     // output clk_out2
   // Clock in ports
    .clk_in1	(clk)
	);	
	
	
clock u_clock
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.clk_8Hz		(clk_8Hz),
	.clk_2Hz		(clk_2Hz)
);

	
game_interface  u_game_interface
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.clk_8Hz		(clk_8Hz),
	.mode			(0),
	.VGA_xpos		(VGA_xpos),
	.VGA_ypos		(VGA_ypos),
	.VGA_data		(VGA_data)
);


/*
always @(posedge clk_100M)
begin
	if(VGA_xpos > 0 && VGA_xpos <= 520 && VGA_ypos > 0 && VGA_ypos <= 240)
	begin
		//addr_gameover_pic <= (VGA_xpos - 60)  + 520 * (VGA_ypos -80) ;
		//gameover_reg <= gameover_pic ;
		addr_gameover_pic <= (VGA_xpos - 60)  + 520 * (VGA_ypos -80) ;
	end
	//else
		//gameover_reg <= 0;
end

reg [16:0] addr_gameover_pic;
gameover_3bit_pi your_instance_name (
  .clka(clk_100M),    // input wire clka
  .addra(addr_gameover_pic),  // input wire [16 : 0] addra
  .douta(VGA_3bit_data)  // output wire [2 : 0] douta
);

assign VGA_data[0] = VGA_3bit_data[0];
assign VGA_data[1] = VGA_3bit_data[0];
assign VGA_data[2] = VGA_3bit_data[0];
assign VGA_data[3] = VGA_3bit_data[0];
assign VGA_data[4] = VGA_3bit_data[1];
assign VGA_data[5] = VGA_3bit_data[1];
assign VGA_data[6] = VGA_3bit_data[1];
assign VGA_data[7] = VGA_3bit_data[1];
assign VGA_data[8] = VGA_3bit_data[2];
assign VGA_data[9] = VGA_3bit_data[3];
assign VGA_data[10] = VGA_3bit_data[2];
assign VGA_data[11] = VGA_3bit_data[2];



*/





VGA_driver		TEST_VGA_driver
(
//global clock
	.clk		(clk_VGA),
	.rst_n		(1'b1),

//vga interface
	.Hsync		(Hsync),
	.Vsync		(Vsync),
	.VGA_en		(),
	.vgaRed		(vgaRed),
	.vgaBlue	(vgaBlue),
	.vgaGreen	(vgaGreen),

//user interface
	.VGA_request(),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	.VGA_data	(VGA_data)
);

endmodule