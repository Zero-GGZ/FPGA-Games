/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				game_logic.v
Date				:				2018-05-11
Description			:				the logical module of game

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180512		QiiNn		1.0			Initial version
========================================================*/
module game_logic
(
	input			clk,
	input			game_en,
	input 			mytank_state,
	input	[4:0]	scorea,
	input	[4:0]	scoreb,
	input	[4:0]	scorec,
	input	[4:0]	scored,
	input	[4:0]			sw,	
	output	reg 	[2:0]	HP_value,
	output		[3:0]		an,
	output		[7:0]		seg,
	output	reg	[15:0]		led,
	output					dp
);

reg [15:0]	seg_display;
reg	[4:0]	score;
reg	[2:0]	HP_add;
initial
begin
	HP_value <= 5;
	score <= 5'b0;
	led[15] <= 0;
	led[14] <= 0;
	led[13] <= 0;
	led[12] <= 0;
	led[11] <= 0;
end

always@(negedge game_en or negedge mytank_state)
begin
	HP_value <= HP_value - 1;
	if(game_en == 1'b0)
	begin
	HP_value <= 5;
	end
end

/*
always@(enytank1_state)
begin
score1 <= score1  + 1'b1;
end

always@(enytank2_state )
begin
score2 <= score2 + 1'b1;
led[14] <= 1;
end

always@(enytank3_state )
begin
score3 <= score3 + 1'b1;
led[14] <= 1;
end

always@(enytank4_state )
begin
score4 <= score4 + 1'b1;
led[13] <= 1 ;
end
*/

always@(posedge clk)
begin
	score <= scorea + scoreb + scorec + scored;
	if (score == 10 | 20 | 30) 
		HP_add <= 1;
	else 
		HP_add <= 0;
	seg_display <= score;
	case(HP_value)
	0:
		begin
		led[15] <= 0;
		led[14] <= 0;
		led[13] <= 0;
		led[12] <= 0;
		led[11] <= 0;
		end
	1:
		begin
		led[15] <= 1;
		led[14] <= 0;
		led[13] <= 0;
		led[12] <= 0;
		led[11] <= 0;
		end
	2:
		begin
		led[15] <= 1;
		led[14] <= 1;
		led[13] <= 0;
		led[12] <= 0;
		led[11] <= 0;
		end
	3:
		begin
		led[15] <= 1;
		led[14] <= 1;
		led[13] <= 1;
		led[12] <= 0;
		led[11] <= 0;
		end
	4:
		begin
		led[15] <= 1;
		led[14] <= 1;
		led[13] <= 1;
		led[12] <= 1;
		led[11] <= 0;
		end
	5:
		begin
		led[15] <= 1;
		led[14] <= 1;
		led[13] <= 1;
		led[12] <= 1;
		led[11] <= 1;
		end
	endcase 
end

seg7decimal u_seg7decimal(

	.data		(seg_display),
    .clk	(clk),
    .clr	(),
    .a_to_g	(seg),
    .an		(an),
    .dp		(dp)
	 );

endmodule