/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				game_SegAndLed.v
Date				:				2018-05-13
Description			:				the segments and LED controller

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180515		ctlvie		1.0			Initial version
180525		ctlvie		2.0			Final Version
========================================================*/

module game_SegAndLed
(
	input					clk,
	input		[2:0]		mode,
	input		[15:0]		sw,
	input		[15:0]		led_classic,
	input		[15:0]		led_infinity,
	input		[15:0]		seg_classic,
	input		[15:0]		seg_infinity,
	input					enable_game_classic,
	input					enable_game_infinity,
	input		[6:0]		score_classic,
	input		[6:0]		score_infinity,
	output		[3:0]		an,
	output		[6:0]		seg,
	output	reg	[15:0]		led
);

reg		[15:0]	seg_display;
initial
begin		
	seg_display <= 0;
	led <= 0;
end

always@(posedge clk)
begin
	if(enable_game_classic == 0 && enable_game_infinity == 0)
	led <= 0;
	else
		begin
		if (enable_game_classic)
			case(led_classic)
			16:	led <= 16'b1111_1111_1111_1111;
			15:	led <= 16'b1111_1111_1111_1110;
			14:	led <= 16'b1111_1111_1111_1100;
			13:	led <= 16'b1111_1111_1111_1000;
			12:	led <= 16'b1111_1111_1111_0000;
			11:	led <= 16'b1111_1111_1110_0000;
			10:	led <= 16'b1111_1111_1100_0000;
			9:	led <= 16'b1111_1111_1000_0000;
			8:	led <= 16'b1111_1111_0000_0000;
			7:	led <= 16'b1111_1110_0000_0000;
			6:	led <= 16'b1111_1100_0000_0000;
			5:	led <= 16'b1111_1000_0000_0000;
			4:	led <= 16'b1111_0000_0000_0000;
			3:	led <= 16'b1110_0000_0000_0000;
			2:	led <= 16'b1100_0000_0000_0000;
			1:	led <= 16'b1000_0000_0000_0000;
			default : led <= 16'b0000_0000_0000_0000;
			endcase
		else
			case(led_infinity)
			16:	led <= 16'b1111_1111_1111_1111;
			15:	led <= 16'b1111_1111_1111_1110;
			14:	led <= 16'b1111_1111_1111_1100;
			13:	led <= 16'b1111_1111_1111_1000;
			12:	led <= 16'b1111_1111_1111_0000;
			11:	led <= 16'b1111_1111_1110_0000;
			10:	led <= 16'b1111_1111_1100_0000;
			9:	led <= 16'b1111_1111_1000_0000;
			8:	led <= 16'b1111_1111_0000_0000;
			7:	led <= 16'b1111_1110_0000_0000;
			6:	led <= 16'b1111_1100_0000_0000;
			5:	led <= 16'b1111_1000_0000_0000;
			4:	led <= 16'b1111_0000_0000_0000;
			3:	led <= 16'b1110_0000_0000_0000;
			2:	led <= 16'b1100_0000_0000_0000;
			1:	led <= 16'b1000_0000_0000_0000;
			default : led <= 16'b0000_0000_0000_0000;
			endcase
		end
end

always@(posedge clk)
begin
	if (sw[0] == 1)
		begin
		seg_display <= 0;
		end
	else
		begin
		if(seg_classic == 0)
			seg_display <= seg_infinity;
		else
			seg_display <= seg_classic;
		end
end

driver_seg u_driver_seg
(
	.data		(seg_display),
	.clk		(clk),
	.clr		(0),
	.a_to_g		(seg),
	.an			(an),
	.dp			()
 );

endmodule