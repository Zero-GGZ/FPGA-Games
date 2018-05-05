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
	
	output					Hsync,
	output					Vsync,
	output		[3:0]		vgaRed,
	output		[3:0]		vgaBlue,
	output		[3:0]		vgaGreen
);

wire	clk_4Hz;
wire	mytank_en;
wire	bt_w;
wire	bt_a;
wire	bt_d;
wire	bt_s;
wire	bt_st;
wire	[4:0]	bul1_x;
wire	[4:0]	bul1_y;
wire	[4:0]	bul2_x;
wire	[4:0]	bul2_y;
wire	[4:0]	bul3_x;
wire	[4:0]	bul3_y;
wire	[4:0]	bul4_x;
wire	[4:0]	bul4_y;
wire	[4:0]	mytank_xpos;
wire	[4:0]	mytank_ypos;
wire	[1:0]	mytank_dir;
wire			mytank_sht;
wire			mytank_state;

mytank_app u_mytank_app
(
	.clk			(clk),
	.clk_4Hz		(clk_4Hz),
	.tank_en		(mytank_en),	//enable
	
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
	
	//relative position input and output
	.x_rel_pos		(mytank_xpos),
	.y_rel_pos		(mytank_ypos),
	
	.tank_state		(mytank_state),
	
	.tank_dir_out	(mytank_dir),
	.bul_sht		(mytank_sht)
);


wire       mybul_xpos;
wire    	mybul_ypos;

wire	enytank1_en;
wire	enytank1_state;
wire	enytank1_xpos;
wire	enytank1_ypos;
wire	enytank1_dir;

enytank_app u_enytank1_app
(	
	.clk			(clk),
	.clk_4Hz		(clk_4Hz),
	.tank_en		(enytank1_en),
	
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.enybul_state	(bul1_state),
	.tank_state		(enytank1_state),
	.enytank_xpos	(enytank1_xpos),
	.enytank_ypos	(enytank1_ypos),
	.tank_dir_out	(enytank1_dir)
);

wire	enytank2_en;
wire	enytank2_state;
wire	enytank2_xpos;
wire	enytank2_ypos;
wire	enytank2_dir;

enytank_app u_enytank2_app
(	
	.clk			(clk),
	.clk_4Hz		(clk_4Hz),
	.tank_en		(enytank2_en),
	
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.enybul_state	(bul2_state),
	.tank_state		(enytank2_state),
	.enytank_xpos	(enytank2_xpos),
	.enytank_ypos	(enytank2_ypos),
	.tank_dir_out	(enytank2_dir)
);

wire	enytank3_en;
wire	enytank3_state;
wire	enytank3_xpos;
wire	enytank3_ypos;
wire	enytank3_dir;

enytank_app u_enytank3_app
(	
	.clk			(clk),
	.clk_4Hz		(clk_4Hz),
	.tank_en		(enytank3_en),
	
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.enybul_state	(bul3_state),
	.tank_state		(enytank3_state),
	.enytank_xpos	(enytank3_xpos),
	.enytank_ypos	(enytank3_ypos),
	.tank_dir_out	(enytank3_dir)
);

wire	enytank4_en;
wire	enytank4_state;
wire	enytank4_xpos;
wire	enytank4_ypos;
wire	enytank4_dir;

enytank_app u_enytank4_app
(	
	.clk			(clk),
	.clk_4Hz		(clk_4Hz),
	.tank_en		(enytank4_en),
	
	.mybul_x		(mybul_xpos),
	.mybul_y		(mybul_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	
	.enybul_state	(bul4_state),
	.tank_state		(enytank4_state),
	.enytank_xpos	(enytank4_xpos),
	.enytank_ypos	(enytank4_ypos),
	.tank_dir_out	(enytank4_dir)
);

wire	mybul_xpos;
wire	mybul_ypos;
wire	mybul_dir;
wire	mybul_state;

bullet u_mybullet
(
	.clk_8Hz	(clk_8Hz),

	
	.bul_dir	(mybul_dir),	//the direction of bullet
	.bul_state	(mybul_state),	//the state of my bullet
	
	//input and output the position of my bullet
	.x_bul_pos	(mybul_xpos),	
	.y_bul_pos	(mybul_xpos),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data)
);


wire	bul1_dir;
wire	bul1_state;

bullet u_bul1
(
	.clk_8Hz	(clk_8Hz),

	
	.bul_dir	(bul1_dir),	//the direction of bullet
	.bul_state	(bul1_state),	//the state of my bullet
	
	//input and output the position of my bullet
	.x_bul_pos	(bul1_x),	
	.y_bul_pos	(bul1_y),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data)
);

wire	bul2_dir;
wire	bul2_state;

bullet u_bul2
(
	.clk_8Hz	(clk_8Hz),

	
	.bul_dir	(bul2_dir),	//the direction of bullet
	.bul_state	(bul2_state),	//the state of my bullet
	
	//input and output the position of my bullet
	.x_bul_pos	(bul2_x),	
	.y_bul_pos	(bul2_y),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data)
);

wire	bul3_dir;
wire	bul3_state;

bullet u_bul3
(
	.clk_8Hz	(clk_8Hz),

	
	.bul_dir	(bul3_dir),	//the direction of bullet
	.bul_state	(bul3_state),	//the state of my bullet
	
	//input and output the position of my bullet
	.x_bul_pos	(bul3_x),	
	.y_bul_pos	(bul3_y),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data)
);

wire	bul4_dir;
wire	bul4_state;

bullet u_bul4
(
	.clk_8Hz	(clk_8Hz),

	
	.bul_dir	(bul4_dir),	//the direction of bullet
	.bul_state	(bul4_state),	//the state of my bullet
	
	//input and output the position of my bullet
	.x_bul_pos	(bul4_x),	
	.y_bul_pos	(bul4_y),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data)
);

tank_phy	mytank_phy
(
	.clk		(clk),
	.clk_4Hz	(clk_4Hz),
	//input the relative position of tank
	.x_rel_pos	(mytank_xpos),
	.y_rel_pos	(mytank_ypos),
	
	.tank_state	(mytank_state),	//the state of tank
	.tank_ide	(1'b1),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(mytank_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data)
);

tank_phy	enytank1_phy
(
	.clk		(clk),
	.clk_4Hz	(clk_4Hz),
	//input the relative position of tank
	.x_rel_pos	(enytank1_xpos),
	.y_rel_pos	(enytank1_ypos),
	
	.tank_state	(enytank1_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank1_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data)
);

tank_phy	enytank2_phy
(
	.clk		(clk),
	.clk_4Hz	(clk_4Hz),
	//input the relative position of tank
	.x_rel_pos	(enytank2_xpos),
	.y_rel_pos	(enytank2_ypos),
	
	.tank_state	(enytank2_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank2_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data)
);

tank_phy	enytank3_phy
(
	.clk		(clk),
	.clk_4Hz	(clk_4Hz),
	//input the relative position of tank
	.x_rel_pos	(enytank3_xpos),
	.y_rel_pos	(enytank3_ypos),
	
	.tank_state	(enytank3_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank3_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data)
);

tank_phy	enytank4_phy
(
	.clk		(clk),
	.clk_4Hz	(clk_4Hz),
	//input the relative position of tank
	.x_rel_pos	(enytank4_xpos),
	.y_rel_pos	(enytank4_ypos),
	
	.tank_state	(enytank4_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enytank4_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data)
);


wire [10:0]		VGA_xpos;
wire [10:0]		VGA_ypos;
wire [11:0]		VGA_data;

VGA_driver		u_VGA_driver
(
//global clock
	.clk		(clk),
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
	.clk		(clk),
	.clk_4Hz	(clk_4Hz),
	
	.tank1_en	(enytank1_en),
	.tank2_en	(enytank2_en),
	.tank3_en	(enytank3_en),
	.tank4_en	(enytank4_en)
);

endmodule






