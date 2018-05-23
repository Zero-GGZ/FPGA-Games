/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				TEST_reward_laser_display.v
Date				:				2018-05-23
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180523		QiiNn		1.0			Initial Version
========================================================*/

module  TEST_reward_system
(	
	input 					clk,
	
	input 					bt_w,
	input 					bt_a,
	input 					bt_s,
	input 					bt_d,
	input 					bt_st,
	input		[15:0]		sw,	
	input					fpga_rxd,
	output					Hsync,
	output					Vsync,
	output		[3:0]		vgaRed,
	output		[3:0]		vgaBlue,
	output		[3:0]		vgaGreen,
	output		[3:0]		an,
	output		[6:0]		seg,
	output					dp,
	output		[15:0]		led,
	output					fpga_txd
);

wire	clk_100M;
wire	clk_4Hz;
wire	clk_VGA;

wire	[4:0]	mytank_xpos;
wire	[4:0]	mytank_ypos;
wire	[4:0]	mytank_xpos_feedback;
wire	[4:0]	mytank_ypos_feedback;
wire	[1:0]	mytank_dir;
wire	[10:0]	VGA_xpos;
wire	[10:0]	VGA_ypos;
wire	[11:0]	VGA_data_reward;
wire	[11:0]	VGA_data_mytank;
wire	[11:0]	VGA_data;

assign VGA_data = VGA_data_mytank | VGA_data_reward;
assign mytank_xpos = mytank_xpos_feedback;
assign mytank_ypos = mytank_ypos_feedback;

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
	.reward_faster	(1'b0),
	.reward_test	(1'b0),
	.clk_4Hz		(clk_4Hz),
	.clk_8Hz		(),
	.clk_2Hz		()
);

reward_logic	u_reward_logic
(
	.clk					(clk_100M),
	.clk_4Hz				(clk_4Hz),
	.enable_reward			(1'b1),
	.enable_game_classic	(1'b1),
	.enable_game_infinity	(1'b0),
	.mytank_xpos			(mytank_xpos), 
	.mytank_ypos			(mytank_ypos),
	.VGA_xpos				(VGA_xpos),
	.VGA_ypos				(VGA_ypos),
	.reward_invincible		(),
	.reward_addtime			(),
	.reward_faster			(),
	.reward_frozen			(),
	.reward_laser			(),
	.VGA_data_reward		(VGA_data_reward),
	
	//test interface
	.random_out				(),
	.set_finish_test		(),
	.set_require_test		()
);


mytank_app u_mytank_app
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.enable			(1'b1),
	.tank_en		(1'b1),	//enable  
	
	// input button direction (w,a,s,d)
	.bt_w			(bt_w),
	.bt_a			(bt_a),
	.bt_s			(bt_s),
	.bt_d			(bt_d),
	.bt_st			(bt_st), // shoot button
	
	//input the position of each bullet
	.bul1_x			(1'b0),
	.bul1_y			(1'b0),
	.bul2_x			(1'b0),
	.bul2_y			(1'b0),
	.bul3_x			(1'b0),
	.bul3_y			(1'b0),
	.bul4_x			(1'b0),
	.bul4_y			(1'b0),
	
	.mybul_state_feedback	(),
	//relative position input and output
	.x_rel_pos_in		(mytank_xpos),
	.y_rel_pos_in		(mytank_ypos),
	.x_rel_pos_out		(mytank_xpos_feedback),
	.y_rel_pos_out		(mytank_ypos_feedback),
	
	.tank_state		(),
	
	.tank_dir_out	(mytank_dir),
	.bul_sht		()
);

tank_phy	mytank_phy
(
	.clk		(clk_100M),
	.enable		(1'b1),

	//input the relative position of tank
	.x_rel_pos	(mytank_xpos),
	.y_rel_pos	(mytank_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(1'b1),	//the state of tank
	.tank_ide	(1'b1),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(mytank_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_mytank)
);

VGA_driver		u_VGA_driver
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
