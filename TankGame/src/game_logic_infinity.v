/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				game_logic_infinity.v
Date				:				2018-05-13
Description			:				the game logic controller in infinity mode

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180513		ctlvie		1.0			Initial version
180523		ctlvie		1.2			Add addtime function
180525		ctlvie		2.0			Final Version
========================================================*/

module game_logic_infinity
(
	input					clk,
	input					btn_return,
	input					btn_stop,
	input					enable_game_infinity,
	input		[6:0]		scorea,
	input		[6:0]		scoreb,
	input		[6:0]		scorec,
	input		[6:0]		scored,
	input					item_addtime,
	input					item_test,
	output	reg [15:0]		seg_infinity,
	output	reg	[15:0]		led_infinity,
	output	reg	[5:0]		timer,
	output	reg				gameover_infinity,
	output	reg	[6:0]		score_infinity
	 
);

reg		[31:0]	cnt;
reg		[6:0]	score;

initial
begin
	gameover_infinity <= 0;
	cnt <= 0;
	timer <= 16;
	seg_infinity <= 0;
	score_infinity <= 0;
end
	
	
reg 	add_flag;
initial add_flag <= 0;
reg		item_flag;
initial	item_flag <= 0;
	
always@(posedge clk)
begin
if(enable_game_infinity)
	begin
	if(timer == 0 || btn_stop == 1)		
		begin
		timer <= 16;
		score_infinity <= score;
		gameover_infinity <= 1;
		end
	else
		begin
		score_infinity <= 0;
		score <= scorea + scoreb + scorec + scored;
		
		if(score == 5 || score == 10 || score == 15 || score == 20 ||
			score == 25 || score == 30 || score == 35 || score == 40 ||
			score == 45 || score == 50 || score == 55 || score == 60 || score == 65)
		begin
			if(add_flag == 0 && timer > 0 && timer < 16)
			begin
			timer <= timer + 1;
			add_flag <= 1;
			end
		end
		else
			add_flag <= 0;		
		
		if(item_addtime == 1 || item_test == 1)
		begin
			if(item_flag == 0 && timer > 0 && timer < 16)
				begin
					if (timer == 15)
						timer <= timer + 1;
					else if(timer == 14)
						timer <= timer + 2;
					else 
						timer <= timer + 3;
					item_flag <= 1;
				end
			else
				begin
				timer <= timer;
				item_flag <= 1;
				end
		end
		else
			item_flag <= 0;
			
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
	if(btn_return)
		begin
		seg_infinity <= 0;
		score <= 0;
		end
	end
end



 
endmodule

