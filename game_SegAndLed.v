/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				game_SegAndLed.v
Date				:				2018-05-13
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------
========================================================*/

module game_SegAndLed
(
	input					clk,
	input		[15:0]		led_classic,
	input		[15:0]		led_infinity,
	input		[15:0]		seg_classic,
	input		[15:0]		seg_infinity,
	input					enable_game_classic,
	input					enable_game_infinity,
	output		[3:0]		an,
	output		[6:0]		seg,
	output		[15:0]		led
);

assign	led = led_classic | led_infinity;
reg		[15:0]	seg_display;
initial		seg_display <= 0;

always@(posedge clk)
begin
	if(enable_game_classic == 0 && enable_game_infinity == 0)
	seg_display <= 0;
	else
		begin
		if (enable_game_classic)
			seg_display <= seg_classic;
		else
			seg_display <= seg_infinity;
		end
end

seg7decimal u_seg7decimal
(
	.data		(seg_display),
	.clk		(clk),
	.clr		(),
	.a_to_g		(seg),
	.an			(an),
	.dp			()
 );

endmodule