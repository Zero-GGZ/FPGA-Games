/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				TEST_operation.v
Date				:				2018-05-09
Description			:				Test of my tank's operation 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180509		QiiNn		1.0			Initial coding complete
180510		QiiNn		1.1			Finished the test of my tank's operation
========================================================*/

module TEST_operation
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
	output		[3:0]		vgaGreen,
	
	output					null_pin
);
//---------------------------------------------
//-------public definition-----------------
//----------------------------------------
//wires definition
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
wire	[4:0]	mybul_xpos_feedback;// = mybul_xpos;
wire	[4:0]	mybul_ypos_feedback;// = mybul_ypos;
wire			VGA_en_mybul;
wire	[11:0]	VGA_data_mybul;	
wire	[4:0]	bul1_x_feedback;// = bul1_x;
wire	[4:0]	bul1_y_feedback;// = bul1_y;
wire			bul1_state;
wire			VGA_en_bul1;
wire	[11:0]	VGA_data_bul1;
wire	[4:0]	bul2_x_feedback;// = bul2_x;
wire	[4:0]	bul2_y_feedback;// = bul2_y;
wire			bul2_state;
wire			VGA_en_bul2;
wire	[11:0]	VGA_data_bul2;
wire	[4:0]	bul3_x_feedback;// = bul3_x;
wire	[4:0]	bul3_y_feedback;// = bul3_y;
wire			bul3_state;
wire			VGA_en_bul3;
wire	[11:0]	VGA_data_bul3;
wire	[4:0]	bul4_x_feedback;// = bul4_x;
wire	[4:0]	bul4_y_feedback;// = bul4_y;
wire			bul4_state;

wire				clk_4Hz;
wire				clk_8Hz;
wire 				clk_100M;
wire				clk_VGA;
wire	[11:0]		VGA_data;
wire	[11:0]		VGA_data_1;
wire	[11:0]		VGA_data_2;
wire	[11:0]		VGA_data_3;
wire	[11:0]		VGA_data_4;
wire 	[10:0]		VGA_xpos;
wire	[10:0]		VGA_ypos;

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



clock 		u_clock
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.clk_8Hz		(clk_8Hz)
);


clk_wiz_0 	u_test_VGA_clock
   (
    // Clock out ports
    .clk_out1	(clk_100M),     // output clk_out1
    .clk_out2	(clk_VGA),     // output clk_out2
   // Clock in ports
    .clk_in1	(clk)
	);	
	
mytank_app  u_mytank_app
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.tank_en		(1'b1),	//enable  
	
	// input button direction (w,a,s,d)
	.bt_w			(bt_w),
	.bt_a			(bt_a),
	.bt_s			(bt_s),
	.bt_d			(bt_d),
	.bt_st			(bt_st), // shoot button
	
	//input the position of each bullet
	.bul1_x			(3),
	.bul1_y			(3),
	.bul2_x			(3),
	.bul2_y			(3),
	.bul3_x			(3),
	.bul3_y			(3),
	.bul4_x			(3),
	.bul4_y			(3),
	
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

wire [11:0]		VGA_data_mytank;
wire [11:0]		VGA_data_mybul;

tank_phy	mytank_phy
(
	.clk		(clk_100M),
	//input the relative position of tank
	.x_rel_pos	(mytank_xpos),
	.y_rel_pos	(mytank_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(mytank_state),	//the state of tank {initialization???????????}
	.tank_ide	(1'b1),			//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(mytank_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_mytank),
	.VGA_en		()
);


bullet u_mybullet
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),

	
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
	.VGA_en		(),
	
	.bul_state_feedback	(mybul_state_fb)
);

VGA_data_selector u_VGA_data_selector
(
	.clk	(clk_100M),
//input interfaces
	.in1	(0),
	.in2	(0),
	.in3	(0),
	.in4	(0),
	.in5	(0),
	.in6	(0),
	.in7	(0),
	.in8	(0),
	.in9	(VGA_data_mybul),
	.in10	(VGA_data_mytank),
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


	
	
	
endmodule