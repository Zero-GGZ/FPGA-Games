/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				game_top.v
Date				:				2018-05-06
Description			:				the top module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180506		QiiNn		0.5			Module interface definition and modules links
180507		QiiNn		0.6			Update some modules' interfaces
180510		QiiNn		0.8			Bugs fixed:
									1. change enemy tanks' speed to clk_2Hz
									2. cancel the VGA enable signal
180510		QiiNn		1.5			Full Version!
========================================================*/

`timescale 1ns/1ns

module game_top
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

//----------------------------------------
//wires definition

//clocks
wire			clk_2Hz;
wire			clk_4Hz;
wire			clk_8Hz;
wire			clk_100M;
wire			clk_VGA;


wire	[4:0]	bul1_x;
wire	[4:0]	bul1_y;
wire	[4:0]	bul2_x;
wire	[4:0]	bul2_y;
wire	[4:0]	bul3_x;
wire	[4:0]	bul3_y;
wire	[4:0]	bul4_x;
wire	[4:0]	bul4_y;

//wires about my tank
wire			mytank_en;
wire	[4:0]	mytank_xpos;
wire	[4:0]	mytank_ypos;
wire 	[4:0]	mytank_xpos_feedback;// = mytank_xpos;
wire 	[4:0]	mytank_ypos_feedback;// = mytank_ypos;
wire	[1:0]	mytank_dir;
wire			mytank_sht;
wire			mytank_state;
wire			mybul_state_fb;

//wires about enemy tank 1
wire			enytank1_en;
wire			enytank1_state;
wire	[4:0]	enytank1_xpos;
wire	[4:0]	enytank1_ypos;
wire	[1:0]	enytank1_dir;
wire			enybul1_state_fb;

//wires about enemy tank 2
wire			enytank2_en;
wire			enytank2_state;
wire	[4:0]	enytank2_xpos;
wire	[4:0]	enytank2_ypos;
wire	[1:0]	enytank2_dir;
wire			enybul2_state_fb;

//wires about enemy tank 3
wire			enytank3_en;
wire			enytank3_state;
wire	[4:0]	enytank3_xpos;
wire	[4:0]	enytank3_ypos;
wire	[1:0]	enytank3_dir;
wire			enybul3_state_fb;

//wires about enemy tank 4
wire			enytank4_en;
wire			enytank4_state;
wire	[4:0]	enytank4_xpos;
wire	[4:0]	enytank4_ypos;
wire	[1:0]	enytank4_dir;
wire			enybul4_state_fb;

//wires about bullets
wire	[4:0]	mybul_xpos;
wire	[4:0]	mybul_ypos;
wire	[4:0]	mybul_xpos_feedback;
wire	[4:0]	mybul_ypos_feedback;
wire	[11:0]	VGA_data_mybul;	
wire	[4:0]	bul1_x_feedback;
wire	[4:0]	bul1_y_feedback;
wire			bul1_state;
wire	[11:0]	VGA_data_bul1;
wire	[4:0]	bul2_x_feedback;
wire	[4:0]	bul2_y_feedback;
wire			bul2_state;
wire	[11:0]	VGA_data_bul2;
wire	[4:0]	bul3_x_feedback;
wire	[4:0]	bul3_y_feedback;
wire			bul3_state;
wire	[11:0]	VGA_data_bul3;
wire	[4:0]	bul4_x_feedback;
wire	[4:0]	bul4_y_feedback;
wire			bul4_state;
wire	[11:0]	VGA_data_bul4;
wire	[11:0]	VGA_data_mytank;
wire	[11:0]	VGA_data_enytank1;
wire	[11:0]	VGA_data_enytank2;
wire	[11:0]	VGA_data_enytank3;
wire	[11:0]	VGA_data_enytank4;
wire 	[10:0]	VGA_xpos;
wire 	[10:0]	VGA_ypos;
wire 	[11:0]	VGA_data;

wire		enable_bul1;
wire		enable_bul2;
wire		enable_bul3;
wire		enable_bul4;
wire		enable_mybul;
wire		enable_mytank_app;
wire		enable_mytank_phy;
wire		enable_enytank1_app;
wire		enable_enytank1_phy;
wire		enable_enytank2_app;
wire		enable_enytank2_phy;
wire		enable_enytank3_app;
wire		enable_enytank3_phy;
wire		enable_enytank4_app;
wire		enable_enytank4_phy;
wire		enable_gamelogic;

wire		[2:0]		HP_value;
wire		[4:0]		score;
wire		[11:0]		VGA_data_interface;
wire		[2:0]		mode;

assign 			bul1_x 			= 		bul1_x_feedback;
assign 			bul2_x 			= 		bul2_x_feedback;
assign 			bul3_x 			= 		bul3_x_feedback;
assign 			bul4_x 			= 		bul4_x_feedback;
assign 			bul1_y 			= 		bul1_y_feedback;
assign 			bul2_y 			= 		bul2_y_feedback;
assign 			bul3_y 			= 		bul3_y_feedback;
assign 			bul4_y 			= 		bul4_y_feedback;
assign			mybul_xpos 		= 		mybul_xpos_feedback;
assign			mybul_ypos 		= 		mybul_ypos_feedback;
assign			mytank_xpos 	= 		mytank_xpos_feedback;
assign			mytank_ypos 	= 		mytank_ypos_feedback;



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

wire	[4:0]	score1;
wire	[4:0]	score2;
wire	[4:0]	score3;
wire	[4:0]	score4;
wire			gameover;

game_logic u_game_logic
(	
	.gamemode_sim		(1'b0),
	.clk				(clk_100M),
	.game_en			(1'b1),
	.mode				(mode),
	.mytank_state		(mytank_state),
	.scorea				(score1),
	.scoreb				(score2),
	.scorec				(score3),
	.scored				(score4),
	.sw					(sw),		
	.HP_value			(HP_value),
	.an					(an),
	.seg				(seg),
	.dp					(dp),
	.led				(led),
	.gameover		(gameover)
);


game_interface  u_game_interface
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.clk_8Hz		(clk_8Hz),
	.mode			(mode),
	.VGA_xpos		(VGA_xpos),
	.VGA_ypos		(VGA_ypos),
	.VGA_data		(VGA_data_interface)
);

game_mode   u_game_mode
(
	.clk			(clk_100M),
	.sw				(sw),	
	.bt_st			(bt_st),
	.gameover		(gameover),
	.HP_value		(HP_value),
	.enable_bul1	(enable_bul1),
	.enable_bul2	(enable_bul2),
	.enable_bul3	(enable_bul3),
	.enable_bul4	(enable_bul4),
	.enable_mybul	(enable_mybul),
	.enable_mytank_app	(enable_mytank_app),
	.enable_mytank_phy	(enable_mytank_phy),
	.enable_enytank1_app(enable_enytank1_app),
	.enable_enytank1_phy(enable_enytank1_phy),
	.enable_enytank2_app(enable_enytank2_app),
	.enable_enytank2_phy(enable_enytank2_phy),
	.enable_enytank3_app(enable_enytank3_app),
	.enable_enytank3_phy(enable_enytank3_phy),
	.enable_enytank4_app(enable_enytank4_app),
	.enable_enytank4_phy(enable_enytank4_phy),
	.enable_gamelogic	(enable_gamelogic),
	.mode				(mode)
);  



mytank_app u_mytank_app
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.enable			(enable_mytank_app),
	.tank_en		(1'b1),	//enable  
	
	// input button direction (w,a,s,d)
	.bt_w			(bt_w),
	.bt_a			(bt_a),
	.bt_s			(bt_s),
	.bt_d			(bt_d),
	.bt_st			(bt_st), // shoot button
	
	//input the position of each bullet
	.bul1_x			(bul1_x),
	.bul1_y			(bul1_y),
	.bul2_x			(bul2_x),
	.bul2_y			(bul2_y),
	.bul3_x			(bul3_x),
	.bul3_y			(bul3_y),
	.bul4_x			(bul4_x),
	.bul4_y			(bul4_y),
	
	.mybul_state_feedback	(mybul_state_fb),
	//relative position input and output
	.x_rel_pos_in		(mytank_xpos),
	.y_rel_pos_in		(mytank_ypos),
	.x_rel_pos_out		(mytank_xpos_feedback),
	.y_rel_pos_out		(mytank_ypos_feedback),
	
	.tank_state		(mytank_state),
	
	.tank_dir_out	(mytank_dir),
	.bul_sht		(mytank_sht)
);


enytank_app u_enytank1_app
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enytank1_app),
	.tank_en		(enytank1_en),
	
	.tank_num		(2'b00),
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.score				(score1),
	
	.enybul_state_feedback	(enybul1_state_fb),
	.enybul_state	(bul1_state),
	.tank_state		(enytank1_state),
	.enytank_xpos	(enytank1_xpos),
	.enytank_ypos	(enytank1_ypos),
	.tank_dir_out	(enytank1_dir)
);


enytank_app u_enytank2_app
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enytank2_app),
	.tank_en		(enytank2_en),
	
	.tank_num		(2'b01),
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.score				(score2),
	
	.enybul_state_feedback	(enybul2_state_fb),
	.enybul_state	(bul2_state),
	.tank_state		(enytank2_state),
	.enytank_xpos	(enytank2_xpos),
	.enytank_ypos	(enytank2_ypos),
	.tank_dir_out	(enytank2_dir)
);



enytank_app u_enytank3_app
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enytank3_app),
	.tank_en		(enytank3_en),
	
	.tank_num		(2'b10),
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.score				(score3),
	
	.enybul_state_feedback	(enybul3_state_fb),
	.enybul_state	(bul3_state),
	.tank_state		(enytank3_state),
	.enytank_xpos	(enytank3_xpos),
	.enytank_ypos	(enytank3_ypos),
	.tank_dir_out	(enytank3_dir)
);



enytank_app u_enytank4_app
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enytank4_app),
	.tank_en		(enytank4_en),
	
	.tank_num		(2'b11),
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.score			(score4),
	
	.enybul_state_feedback	(enybul4_state_fb),
	.enybul_state	(bul4_state),
	.tank_state		(enytank4_state),
	.enytank_xpos	(enytank4_xpos),
	.enytank_ypos	(enytank4_ypos),
	.tank_dir_out	(enytank4_dir)
);


bullet u_mybullet
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_mybul),

	
	.bul_dir	(mytank_dir),	//the direction of bullet
	.bul_state	(mytank_sht),	//the state of my bullet
	
	.tank_xpos	(mytank_xpos),
	.tank_ypos	(mytank_ypos),
	//input and output the position of my bullet
	.x_bul_pos_in	(),	
	.y_bul_pos_in	(),
	.x_bul_pos_out	(mybul_xpos_feedback),
	.y_bul_pos_out	(mybul_ypos_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_mybul),
	
	.bul_state_feedback	(mybul_state_fb)
);
	

bullet u_bul1
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_bul1),

	
	.bul_dir	(enytank1_dir),	//the direction of bullet
	.bul_state	(bul1_state),	//the state of my bullet
	
	.tank_xpos	(enytank1_xpos),
	.tank_ypos	(enytank1_ypos),
	//input and output the position of my bullet
	.x_bul_pos_in	(),	
	.y_bul_pos_in	(),
	.x_bul_pos_out	(bul1_x_feedback),
	.y_bul_pos_out	(bul1_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_bul1),
	
	.bul_state_feedback	(enybul1_state_fb)
);



bullet u_bul2
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_bul2),

	
	.bul_dir	(enytank2_dir),	//the direction of bullet
	.bul_state	(bul2_state),	//the state of my bullet
	
	.tank_xpos	(enytank2_xpos),
	.tank_ypos	(enytank2_ypos),
	//input and output the position of my bullet
	.x_bul_pos_in	(),	
	.y_bul_pos_in	(),
	.x_bul_pos_out	(bul2_x_feedback),
	.y_bul_pos_out	(bul2_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_bul2),
	
	.bul_state_feedback	(enybul2_state_fb)
);



bullet u_bul3
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_bul3),

	
	.bul_dir	(enytank3_dir),	//the direction of bullet
	.bul_state	(bul3_state),	//the state of my bullet
	
	.tank_xpos	(enytank3_xpos),
	.tank_ypos	(enytank3_ypos),
	//input and output the position of my bullet
	.x_bul_pos_in	(),	
	.y_bul_pos_in	(),
	.x_bul_pos_out	(bul3_x_feedback),
	.y_bul_pos_out	(bul3_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_bul3),
	
	.bul_state_feedback	(enybul3_state_fb)
);



bullet u_bul4
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_bul4),

	
	.bul_dir	(enytank4_dir),	//the direction of bullet
	.bul_state	(bul4_state),	//the state of my bullet
	
	.tank_xpos	(enytank4_xpos),
	.tank_ypos	(enytank4_ypos),
	//input and output the position of my bullet
	.x_bul_pos_in	(),	
	.y_bul_pos_in	(),
	.x_bul_pos_out	(bul4_x_feedback),
	.y_bul_pos_out	(bul4_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_bul4),
	
	.bul_state_feedback	(enybul4_state_fb)
);



tank_phy	mytank_phy
(
	.clk		(clk_100M),
	.enable		(enable_mytank_phy),

	//input the relative position of tank
	.x_rel_pos	(mytank_xpos),
	.y_rel_pos	(mytank_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(mytank_state),	//the state of tank
	.tank_ide	(1'b1),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(mytank_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_mytank)
);



tank_phy	enytank1_phy
(
	.clk		(clk_100M),
	.enable		(enable_enytank1_phy),
	//input the relative position of tank
	.x_rel_pos	(enytank1_xpos),
	.y_rel_pos	(enytank1_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enytank1_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank1_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enytank1)
);



tank_phy	enytank2_phy
(
	.clk		(clk_100M),
	.enable		(enable_enytank2_phy),
	//input the relative position of tank
	.x_rel_pos	(enytank2_xpos),
	.y_rel_pos	(enytank2_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enytank2_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank2_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enytank2)
);



tank_phy	enytank3_phy
(
	.clk		(clk_100M),
	.enable		(enable_enytank3_phy),
	//input the relative position of tank
	.x_rel_pos	(enytank3_xpos),
	.y_rel_pos	(enytank3_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enytank3_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank3_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enytank3)
);



tank_phy	enytank4_phy
(
	.clk		(clk_100M),
	.enable		(enable_enytank4_phy),
	//input the relative position of tank
	.x_rel_pos	(enytank4_xpos),
	.y_rel_pos	(enytank4_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enytank4_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank4_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enytank4)
);


VGA_data_selector u_VGA_data_selector
(
	.clk	(clk_100M),
//input interfaces
	.in1	(VGA_data_bul1),
	.in2	(VGA_data_bul2),
	.in3	(VGA_data_bul3),
	.in4	(VGA_data_bul4),
	.in5	(VGA_data_enytank1),
	.in6	(VGA_data_enytank2),
	.in7	(VGA_data_enytank3),
	.in8	(VGA_data_enytank4),
	.in9	(VGA_data_mybul),
	.in10	(VGA_data_mytank),
	.in11	(VGA_data_interface),
	.in12	(0),
	.in13	(0),
	.in14	(0),
	.in15	(0),
	.in16	(0),
	.in17	(0),
	.in18	(0),
	.in19	(0),
	.in20	(0),
//output interfaces	
	.out	(VGA_data)
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

tank_generate	u_tank_generate
(	
	.clk_4Hz	(clk_4Hz),
	
	.tank1_state(enytank1_state),
	.tank2_state(enytank2_state),
	.tank3_state(enytank3_state),
	.tank4_state(enytank4_state),
	
	.tank1_en	(enytank1_en),
	.tank2_en	(enytank2_en),
	.tank3_en	(enytank3_en),
	.tank4_en	(enytank4_en)
);

endmodule






