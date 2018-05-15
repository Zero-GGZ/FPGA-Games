/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				game_logic_classic.v
Date				:				2018-05-13
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180513		QiiNn		1.0			Initial version
========================================================*/
module game_logic_classic
(	
	input					clk,
	input	[4:0]			sw,
	input					enable_game_classic,
	input 					mytank_state,
	input	[4:0]			scorea,
	input	[4:0]			scoreb,
	input	[4:0]			scorec,
	input	[4:0]			scored,
	output	reg	[4:0]		HP_value,
	output	reg [15:0]		seg_classic,
	output	reg	[15:0]		led_classic,
	output	reg				gameover_classic,
	output	reg	[5:0]		score_classic
);


reg	[5:0]	score;
reg	[2:0]	HP_add;

initial
begin
	HP_add <= 0;
	seg_classic <= 0;
	led_classic <= 16'b0;
	score <= 0;
	gameover_classic <= 0;
	score_classic <= 0;
end

always@(negedge enable_game_classic or negedge mytank_state)
begin
	HP_value <= HP_value - 1;
	if(enable_game_classic == 1'b0)
	begin
	HP_value <= 8;
	end
end


always@(posedge clk)
begin
	if(!enable_game_classic)
	begin
		gameover_classic <= 0;
		seg_classic <= score;
		if(sw[0])
			begin
			score <= 0;
			seg_classic <= 0;
			end
	end
	else
	begin
	score_classic <= 0;
	score <= scorea + scoreb + scorec + scored;
	seg_classic <= score;
	led_classic <= HP_value;
	if(HP_value == 0)
	begin
		gameover_classic <= 1;
		score_classic <= score;
	end
	end
end

endmodule