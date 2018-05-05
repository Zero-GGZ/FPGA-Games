/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				mytank_app.v
Date				:				2018-05-05
Description			:				the application module of player's tank 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
========================================================*/

`timescale 1ns/1ns

module mytank_app
(	
	input clk,
	input clk_4Hz,
	input tank_en,	//enable
	
	// input button direction (w,a,s,d)
	input bt_w,
	input bt_a,
	input bt_s,
	input bt_d,
	input bt_st, // shoot button
	
	//input the position of each bullet
	input	[4:0]	bul1_x,
	input	[4:0]	bul1_y,
	input	[4:0]	bul2_x,
	input	[4:0]	bul2_y,
	input	[4:0]	bul3_x,
	input	[4:0]	bul3_y,
	input	[4:0]	bul4_x,
	input	[4:0]	bul4_y,
	
	//relative position input and output
	inout	[4:0] 	x_rel_pos,
	inout	[4:0]	y_rel_pos,
	
	output	reg		   tank_state,
	
	output	reg	[1:0]	tank_dir_out,
	output  reg			bul_sht
		
);

endmodule