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
	input			gamemode_sim,
	
	
	input			clk,
	input			game_en,
	input	[2:0]	mode,
	input 			mytank_state,
	input	[4:0]	scorea,
	input	[4:0]	scoreb,
	input	[4:0]	scorec,
	input	[4:0]	scored,
	input	[4:0]			sw,	
	output	reg 	[2:0]	HP_value,
	output		[3:0]		an,
	output		[6:0]		seg,
	output	reg	[15:0]		led,
	output					dp,
	output	reg				gameover
);

reg		[15:0]	seg_display;
reg		[4:0]	score;
reg		[2:0]	HP_add;
reg		[3:0]	HP_value_mode0;
initial
begin
	HP_value <= 5;
	score <= 5'b0;
	led <= 16'b0000_0000_0000_0000;
end


always@(negedge game_en or negedge mytank_state)
begin
	HP_value_mode0 <= HP_value_mode0 - 1;
	if(!game_en)
	begin
		HP_value_mode0 <= 5;
	end
end

reg		game_mode;
reg		init_reg;
reg		[31:0]	mode1_cnt;
reg		[4:0]	mode1_timer;
initial	mode1_cnt <= 32'hFFFFFFFF;
initial	mode1_timer	<=	16;
initial HP_value <= 5;
initial	gameover <= 0;

always@(posedge clk)
begin
	if(!sw[4])
		begin
		game_mode <= 1'b0;
		end		
	else	
		game_mode <= 1'b1;
end


always@(posedge clk )
begin
	case(mode)
	0:
		begin
		mode1_cnt <= 0;
		mode1_timer	<=	16;
		score <= 0;
		gameover <= 0;
		HP_value <= 5;
		HP_value_mode0 <= 5;
		end
	1:
		begin
		score <= scorea + scoreb + scorec + scored;
		case(gamemode_sim)
		//case(game_mode)
		0:
			begin
			seg_display <= score;
			HP_value <= HP_value_mode0;
			if (score == 5 | 10 | 15 | 20 | 25 )
				HP_value <= HP_value + 1;
			case(HP_value)
			0:	led <= 16'b0000_0000_0000_0000; 
			1:	led <= 16'b1000_0000_0000_0000;
			2:	led <= 16'b1100_0000_0000_0000;
			3:	led <= 16'b1110_0000_0000_0000;
			4:	led <= 16'b1111_0000_0000_0000;
			5:	led <= 16'b1111_1000_0000_0000;
			6:	led <= 16'b1111_1100_0000_0000;
			default: led <= 16'b0000_0000_0000_0000;
			endcase
			if( HP_value == 0)
			begin
				gameover <= 1;
				seg_display <= 2018;
			end
			else
				gameover <= 0;
			end
		1:
			begin
			mode1_cnt <= mode1_cnt + 10;
			if (score == 5 | 10 | 15 | 20 | 25 )
				mode1_timer <= mode1_timer + 1;
			if(mode1_cnt == 5000)
			begin
				mode1_timer <= mode1_timer - 1;
				mode1_cnt <= 0;
			end
			case(mode1_timer)
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
			0:	begin
				led <= 16'b0000_0000_0000_0000;
				mode1_timer	<=	16;
				gameover <= 1;
				seg_display <= 2018;
				end
			endcase
			end
		endcase
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