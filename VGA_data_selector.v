/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				VGA_data_selector.v
Date				:				2018-05-08
Description			:				the VGA data signal selector 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180508		QiiNn		1.0			Initial coding completed(unverified)
180508		QiiNn		1.1			Corrected the reg conflict error(unverified)
========================================================*/

module VGA_data_selector
(
	input		clk,
//input interfaces
	input 	[11:0]	in1,
	input	[11:0]	in2,
	input	[11:0]	in3,
	input	[11:0]	in4,
	input	[11:0]	in5,
	input	[11:0]	in6,
	input	[11:0]	in7,
	input	[11:0]	in8,
	input	[11:0]	in9,
	input	[11:0]	in10,
//output interfaces	
	output	reg	[11:0]	out
);

always@(posedge clk)
begin
	if ((in1[0] == 1'b1) || (in2[0] == 1'b1) || (in3[0] == 1'b1) || (in4[0] == 1'b1) ||
		(in5[0] == 1'b1) || (in6[0] == 1'b1) || (in7[0] == 1'b1) || (in8[0] == 1'b1) ||
		(in9[0] == 1'b1) || (in10[0] == 1'b1))
		out[0] <= 1'b1;
	else
		out[0] <= 1'b0;

	if ((in1[1] == 1'b1) || (in2[1] == 1'b1) || (in3[1] == 1'b1) || (in4[1] == 1'b1) ||
		(in5[1] == 1'b1) || (in6[1] == 1'b1) || (in7[1] == 1'b1) || (in8[1] == 1'b1) ||
		(in9[1] == 1'b1) || (in10[1] == 1'b1))
		out[1] <= 1'b1;
	else
		out[1] <= 1'b0;

	if ((in1[2] == 1'b1) || (in2[2] == 1'b1) || (in3[2] == 1'b1) || (in4[2] == 1'b1) ||
		(in5[2] == 1'b1) || (in6[2] == 1'b1) || (in7[2] == 1'b1) || (in8[2] == 1'b1) ||
		(in9[2] == 1'b1) || (in10[2] == 1'b1))
		out[2] <= 1'b1;
	else
		out[2] <= 1'b0;

	if ((in1[3] == 1'b1) || (in2[3] == 1'b1) || (in3[3] == 1'b1) || (in4[3] == 1'b1) ||
		(in5[3] == 1'b1) || (in6[3] == 1'b1) || (in7[3] == 1'b1) || (in8[3] == 1'b1) ||
		(in9[3] == 1'b1) || (in10[3] == 1'b1))
		out[3] <= 1'b1;
	else
		out[3] <= 1'b0;

	if ((in1[4] == 1'b1) || (in2[4] == 1'b1) || (in3[4] == 1'b1) || (in4[4] == 1'b1) ||
		(in5[4] == 1'b1) || (in6[4] == 1'b1) || (in7[4] == 1'b1) || (in8[4] == 1'b1) ||
		(in9[4] == 1'b1) || (in10[4] == 1'b1))
		out[4] <= 1'b1;
	else
		out[4] <= 1'b0;

	if ((in1[5] == 1'b1) || (in2[5] == 1'b1) || (in3[5] == 1'b1) || (in4[5] == 1'b1) ||
		(in5[5] == 1'b1) || (in6[5] == 1'b1) || (in7[5] == 1'b1) || (in8[5] == 1'b1) ||
		(in9[5] == 1'b1) || (in10[5] == 1'b1))
		out[5] <= 1'b1;
	else
		out[5] <= 1'b0;

	if ((in1[6] == 1'b1) || (in2[6] == 1'b1) || (in3[6] == 1'b1) || (in4[6] == 1'b1) ||
		(in5[6] == 1'b1) || (in6[6] == 1'b1) || (in7[6] == 1'b1) || (in8[6] == 1'b1) ||
		(in9[6] == 1'b1) || (in10[6] == 1'b1))
		out[6] <= 1'b1;
	else
		out[6] <= 1'b0;

	if ((in1[7] == 1'b1) || (in2[7] == 1'b1) || (in3[7] == 1'b1) || (in4[7] == 1'b1) ||
		(in5[7] == 1'b1) || (in6[7] == 1'b1) || (in7[7] == 1'b1) || (in8[7] == 1'b1) ||
		(in9[7] == 1'b1) || (in10[7] == 1'b1))
		out[7] <= 1'b1;
	else
		out[7] <= 1'b0;

	if ((in1[8] == 1'b1) || (in2[8] == 1'b1) || (in3[8] == 1'b1) || (in4[8] == 1'b1) ||
		(in5[8] == 1'b1) || (in6[8] == 1'b1) || (in7[8] == 1'b1) || (in8[8] == 1'b1) ||
		(in9[8] == 1'b1) || (in10[8] == 1'b1))
		out[8] <= 1'b1;
	else
		out[8] <= 1'b0;

	if ((in1[9] == 1'b1) || (in2[9] == 1'b1) || (in3[9] == 1'b1) || (in4[9] == 1'b1) ||
		(in5[9] == 1'b1) || (in6[9] == 1'b1) || (in7[9] == 1'b1) || (in8[9] == 1'b1) ||
		(in9[9] == 1'b1) || (in10[9] == 1'b1))
		out[9] <= 1'b1;
	else
		out[9] <= 1'b0;

	if ((in1[10] == 1'b1) || (in2[10] == 1'b1) || (in3[10] == 1'b1) || (in4[10] == 1'b1) ||
		(in5[10] == 1'b1) || (in6[10] == 1'b1) || (in7[10] == 1'b1) || (in8[10] == 1'b1) ||
		(in9[10] == 1'b1) || (in10[10] == 1'b1))
		out[10] <= 1'b1;
	else

	if ((in1[11] == 1'b1) || (in2[11] == 1'b1) || (in3[11] == 1'b1) || (in4[11] == 1'b1) ||
		(in5[11] == 1'b1) || (in6[11] == 1'b1) || (in7[11] == 1'b1) || (in8[11] == 1'b1) ||
		(in9[11] == 1'b1) || (in10[11] == 1'b1))
		out[11] <= 1'b1;
	else
		out[11] <= 1'b0;
end

endmodule