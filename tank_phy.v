/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				tank_phy.v
Date				:				2018-05-05
Description			:				convert the x/y relative coordinate to VGA data 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
========================================================*/

`timescale 1ns/1ns

module tank_phy
(
	input			clk,
	input 			clk_4Hz,
	//input the relative position of tank
	input	[4:0]	x_rel_pos,
	input	[4:0]	y_rel_pos,
	
	input			tank_state,	//the state of tank
	input			tank_ide,	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	input	[1:0]	tank_dir,	//the direction of tank
	
	//output the VGA data
	output	reg	[11:0]	VGA_data
);

endmodule
