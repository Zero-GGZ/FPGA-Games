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
	input		[4:0]		sw,
	input					enable_game_infinity,
	input		[4:0]		scorea,
	input		[4:0]		scoreb,
	input		[4:0]		scorec,
	input		[4:0]		scored,
	output	reg [15:0]		seg_infinity,
	output	reg	[15:0]		led_infinity,
	output	reg	[5:0]		timer,
	output	reg				gameover_infinity,
	output	reg	[5:0]		score_infinity
	 
);

reg		[31:0]	cnt;
reg		[5:0]	score;

initial
begin
	gameover_infinity <= 0;
	cnt <= 0;
	timer <= 16;
	seg_infinity <= 0;
	score_infinity <= 0;
end
	
always@(posedge clk)
begin
if(enable_game_infinity)
	begin
	if(timer == 0)		
		begin
		timer <= 16;
		score_infinity <= score;
		gameover_infinity <= 1;
		end
	else
		begin
		score_infinity <= 0;
		score <= scorea + scoreb + scorec + scored;
		seg_infinity <= score;
		cnt <= cnt + 1;
		if(cnt == 500000000)
			begin
			timer <= timer - 1;
			cnt <= 0;
			end
		led_infinity <= timer;
		end
	end
else
	begin
	seg_infinity <= score;
	gameover_infinity <= 0;
	cnt <= 0;
	timer <= 16;
	if(sw[0])
		begin
		seg_infinity <= 0;
		score <= 0;
		end
//	seg_infinity <= 0;
	end
end



 
endmodule

