/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				VGA_data_selector.v
Date				:				2018-05-08
Description			:				the VGA data signal selector 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180508		ctlvie		1.0			Initial coding completed(unverified)
180508		ctlvie		1.1			Corrected the reg conflict error(unverified)
180509		ctlvie		1.2			Update to \assign\ rather than \if-else\
180525		ctlvie		2.0			Final Version
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
	input 	[11:0]	in11,
	input	[11:0]	in12,
	input	[11:0]	in13,
	input	[11:0]	in14,
	input	[11:0]	in15,
	input	[11:0]	in16,
	input	[11:0]	in17,
	input	[11:0]	in18,
	input	[11:0]	in19,
	input	[11:0]	in20,
//output interfaces	
	output		[11:0]	out
);

assign out[0]	=	in1[0]	|	in2[0]	|	in3[0]	|	in4[0]	|	in5[0]	|	in6[0]	|	in7[0]	|	in8[0]	|	in9[0]	|	in10[0]		|	in11[0]		 | in12[0]	 | in13[0]	| in14[0]	| in15[0]	 | in16[0]	| in17[0]	| in18[0]	| in19[0]	| in20[0]	;
assign out[1]	=	in1[1]	|	in2[1]	|	in3[1]	|	in4[1]	|	in5[1]	|	in6[1]	|	in7[1]	|	in8[1]	|	in9[1]	|	in10[1]		|	in11[1]		 | in12[1]	 | in13[1]	| in14[1]	| in15[1]	 | in16[1]	| in17[1]	| in18[1]	| in19[1]	| in20[1]	;
assign out[2]	=	in1[2]	|	in2[2]	|	in3[2]	|	in4[2]	|	in5[2]	|	in6[2]	|	in7[2]	|	in8[2]	|	in9[2]	|	in10[2]		|	in11[2]		 | in12[2]	 | in13[2]	| in14[2]	| in15[2]	 | in16[2]	| in17[2]	| in18[2]	| in19[2]	| in20[2]	;
assign out[3]	=	in1[3]	|	in2[3]	|	in3[3]	|	in4[3]	|	in5[3]	|	in6[3]	|	in7[3]	|	in8[3]	|	in9[3]	|	in10[3]		|	in11[3]		 | in12[3]	 | in13[3]	| in14[3]	| in15[3]	 | in16[3]	| in17[3]	| in18[3]	| in19[3]	| in20[3]	;
assign out[4]	=	in1[4]	|	in2[4]	|	in3[4]	|	in4[4]	|	in5[4]	|	in6[4]	|	in7[4]	|	in8[4]	|	in9[4]	|	in10[4]		|	in11[4]		 | in12[4]	 | in13[4]	| in14[4]	| in15[4]	 | in16[4]	| in17[4]	| in18[4]	| in19[4]	| in20[4]	;
assign out[5]	=	in1[5]	|	in2[5]	|	in3[5]	|	in4[5]	|	in5[5]	|	in6[5]	|	in7[5]	|	in8[5]	|	in9[5]	|	in10[5]		|	in11[5]		 | in12[5]	 | in13[5]	| in14[5]	| in15[5]	 | in16[5]	| in17[5]	| in18[5]	| in19[5]	| in20[5]	;
assign out[6]	=	in1[6]	|	in2[6]	|	in3[6]	|	in4[6]	|	in5[6]	|	in6[6]	|	in7[6]	|	in8[6]	|	in9[6]	|	in10[6]		|	in11[6]		 | in12[6]	 | in13[6]	| in14[6]	| in15[6]	 | in16[6]	| in17[6]	| in18[6]	| in19[6]	| in20[6]	;
assign out[7]	=	in1[7]	|	in2[7]	|	in3[7]	|	in4[7]	|	in5[7]	|	in6[7]	|	in7[7]	|	in8[7]	|	in9[7]	|	in10[7]		|	in11[7]		 | in12[7]	 | in13[7]	| in14[7]	| in15[7]	 | in16[7]	| in17[7]	| in18[7]	| in19[7]	| in20[7]	;
assign out[8]	=	in1[8]	|	in2[8]	|	in3[8]	|	in4[8]	|	in5[8]	|	in6[8]	|	in7[8]	|	in8[8]	|	in9[8]	|	in10[8]		|	in11[8]		 | in12[8]	 | in13[8]	| in14[8]	| in15[8]	 | in16[8]	| in17[8]	| in18[8]	| in19[8]	| in20[8]	;
assign out[9]	=	in1[9]	|	in2[9]	|	in3[9]	|	in4[9]	|	in5[9]	|	in6[9]	|	in7[9]	|	in8[9]	|	in9[9]	|	in10[9]		|	in11[9]		 | in12[9]	 | in13[9]	| in14[9]	| in15[9]	 | in16[9]	| in17[9]	| in18[9]	| in19[9]	| in20[9]	;
assign out[10]	=	in1[10]	|	in2[10]	|	in3[10]	|	in4[10]	|	in5[10]	|	in6[10]	|	in7[10]	|	in8[10]	|	in9[10]	|	in10[10]	|	in11[10]	 | in12[10]	 | in13[10]	| in14[10]	| in15[10]	 | in16[10]	| in17[10]	| in18[10]	| in19[10]	| in20[10]	;
assign out[11]	=	in1[11]	|	in2[11]	|	in3[11]	|	in4[11]	|	in5[11]	|	in6[11]	|	in7[11]	|	in8[11]	|	in9[11]	|	in10[11]	|	in11[11]	 | in12[11]	 | in13[11]	| in14[11]	| in15[11]	 | in16[11]	| in17[11]	| in18[11]	| in19[11]	| in20[11]	;



endmodule