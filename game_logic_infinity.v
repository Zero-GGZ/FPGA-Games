/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				game_logic_infinity.v
Date				:				2018-05-13
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180513		QiiNn		1.0			Initial version
========================================================*/

module game_logic_infinity
(
	input					clk,
	input					enable_game_infinity,
	input		[4:0]		scorea,
	input		[4:0]		scoreb,
	input		[4:0]		scorec,
	input		[4:0]		scored,
	output	reg [15:0]		seg_infinity,
	output	reg	[15:0]		led_infinity,
	output	reg				gameover_infinity
	 
);

reg		[31:0]	cnt;
reg		[10:0]	timer;
reg		[4:0]	score;

initial
begin
	gameover_infinity <= 0;
	cnt <= 0;
	timer <= 16;
	seg_infinity <= 0;
end
	
always@(posedge clk)
begin
if(enable_game_infinity)
	begin
	score <= scorea + scoreb + scorec + scored;
	seg_infinity <= score;
	cnt <= cnt + 1;
	if(cnt == 500000000)
		begin
		timer <= timer - 1;
		cnt <= 0;
		end
	case(timer)
	16:	led_infinity <= 16'b1111_1111_1111_1111;
	15:	led_infinity <= 16'b1111_1111_1111_1110;
	14:	led_infinity <= 16'b1111_1111_1111_1100;
	13:	led_infinity <= 16'b1111_1111_1111_1000;
	12:	led_infinity <= 16'b1111_1111_1111_0000;
	11:	led_infinity <= 16'b1111_1111_1110_0000;
	10:	led_infinity <= 16'b1111_1111_1100_0000;
	9:	led_infinity <= 16'b1111_1111_1000_0000;
	8:	led_infinity <= 16'b1111_1111_0000_0000;
	7:	led_infinity <= 16'b1111_1110_0000_0000;
	6:	led_infinity <= 16'b1111_1100_0000_0000;
	5:	led_infinity <= 16'b1111_1000_0000_0000;
	4:	led_infinity <= 16'b1111_0000_0000_0000;
	3:	led_infinity <= 16'b1110_0000_0000_0000;
	2:	led_infinity <= 16'b1100_0000_0000_0000;
	1:	led_infinity <= 16'b1000_0000_0000_0000;
	0:	begin
		led_infinity <= 16'b0000_0000_0000_0000;
		timer	<=	16;
		gameover_infinity <= 1;
		end
	endcase
	end
else
	begin
	gameover_infinity <= 0;
	cnt <= 0;
	timer <= 16;
	seg_infinity <= 0;
	end
end



 
endmodule

