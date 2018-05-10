/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				TEST_multi.v
Date				:				2018-05-09
Description			:				test multiple tanks display 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180509		QiiNn		1.0			Initial test
									Finish!
========================================================*/

module TEST_multi
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

wire					clk_100M;
wire					clk_VGA;
wire		[11:0]		VGA_data;
wire		[11:0]		VGA_data_1;
wire		[11:0]		VGA_data_2;
wire		[11:0]		VGA_data_3;
wire		[11:0]		VGA_data_4;
wire		[10:0]		VGA_xpos;
wire		[10:0]		VGA_ypos;

clk_wiz_0 u_test_VGA_clock
   (
    // Clock out ports
    .clk_out1	(clk_100M),     // output clk_out1
    .clk_out2	(clk_VGA),     // output clk_out2
   // Clock in ports
    .clk_in1	(clk)
	);	
	
tank_phy	u1_tank_phy
(
	.clk		(clk_100M),
	//input the relative position of tank
	.x_rel_pos	(0),
	.y_rel_pos	(0),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(1'b1),	//the state of tank
	.tank_ide	(1'b1),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(2'b00),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_1),
	.VGA_en		()
);

tank_phy	u2_tank_phy
(
	.clk		(clk_100M),
	//input the relative position of tank
	.x_rel_pos	(20),
	.y_rel_pos	(16),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(1'b1),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(2'b01),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_2),
	.VGA_en		()
);

tank_phy	u3_tank_phy
(
	.clk		(clk_100M),
	//input the relative position of tank
	.x_rel_pos	(10),
	.y_rel_pos	(10),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(1'b1),	//the state of tank
	.tank_ide	(1'b1),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(2'b10),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_3),
	.VGA_en		()
);

tank_phy	u4_tank_phy
(
	.clk		(clk_100M),
	//input the relative position of tank
	.x_rel_pos	(16),
	.y_rel_pos	(20),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(1'b1),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(2'b11),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_4),
	.VGA_en		()
);

VGA_data_selector u_VGA_data_selector
(
	.clk	(clk_100M),
//input interfaces
	.in1	(VGA_data_1),
	.in2	(VGA_data_2),
	.in3	(VGA_data_3),
	.in4	(VGA_data_4),
	.in5	(1'b0),
	.in6	(1'b0),
	.in7	(1'b0),
	.in8	(1'b0),
	.in9	(1'b0),
	.in10	(1'b0),
//output interfaces	
	.out	(VGA_data)
);


VGA_driver		u_test_VGA_driver
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
