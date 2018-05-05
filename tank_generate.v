/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				tank_generate.v
Date				:				2018-05-05
Description			:				the generate module of four enemy's tanks 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
========================================================*/

`timescale 1ns/1ns

module tank_generate
(	
	input	clk,
	input	clk_4Hz,
	
	output	reg 	tank1_en,
	output	reg 	tank2_en,
	output	reg 	tank3_en,
	output	reg  	tank4_en
);

endmodule 