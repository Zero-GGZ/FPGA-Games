/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				VGA_enable.v
Date				:				2018-05-07
Description			:				the VGA enable signal selector 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180507		QiiNn		1.0			Initial coding completed(unverified)
========================================================*/

module VGA_enable
(
	input		clk,
//input interfaces
	input 		in1,
	input		in2,
	input		in3,
	input		in4,
	input		in5,
	input		in6,
	input		in7,
	input		in8,
	input		in9,
	input		in10,
//output interfaces	
	output		out
);

/*
always@(posedge clk)
begin
	if ((in1 == 1'b1) || (in2 == 1'b1) || (in3 == 1'b1) || (in4 == 1'b1) ||
		(in5 == 1'b1) || (in6 == 1'b1) || (in7 == 1'b1) || (in8 == 1'b1) ||
		(in9 == 1'b1) || (in10 == 1'b1))
		out <= 1'b1;
	else
		out <= 1'b0;
end
*/

assign out = in1 | in2 | in3 | in4 | in5 | in6 | in7 | in8 | in8 | in10; 

endmodule
