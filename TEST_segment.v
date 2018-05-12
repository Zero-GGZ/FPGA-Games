/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				TEST_segment.v
Date				:				2018-05-11
Description			:				For testing the segment display 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180510		QiiNn		1.0			Finish!
========================================================*/

module TEST_segment 
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
	output					null_pin,
	
	output		[3:0]		an,
	output		[6:0]		seg,
	output					dp
);

	
seg7decimal u_seg7decimal(

	.data		(1234),
	.clk	(clk),
	.clr	(),
    .a_to_g	(seg),
    .an		(an),
    .dp		(dp) 
	 );
endmodule