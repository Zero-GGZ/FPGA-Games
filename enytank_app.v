/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				enytank_app.v
Date				:				2018-05-05
Description			:				the application module of enemy's tank 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
180507		QiiNn		0.6			Add enybul_dir interface
========================================================*/

`timescale 1ns/1ns

module enytank_app
(
	input 			clk,
	input 			clk_4Hz,
	input 			tank_en,
	
	input	[4:0] 	mybul_x,
	input 	[4:0]	mybul_y,
	
	input 	[4:0]	mytank_xpos,
	input	[4:0]	mytank_ypos,
	
	output  reg			enybul_state,
	output	reg			tank_state,
	output	reg	[4:0] 	enytank_xpos,
	output	reg	[4:0]	enytank_ypos,
	output	reg	[1:0]	tank_dir_out	
);




endmodule