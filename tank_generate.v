/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				tank_generate.v
Date				:				2018-05-05
Description			:				the generate module of four enemy's tanks 
Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		ctlvie		0.5			Module interface definition
180507		ctlvie		0.6			Add tank_state interfaces
180508		ctlvie		1.0			Initial coding completed(unverified)
180508		ctlvie		1.1			Corrected the reg conflict error(unverified)
180510		ctlvie		1.5			Full Version!
180525		ctlvie		2.0			Final Version
========================================================*/

`timescale 1ns/1ns

module tank_generate
(	
	input			clk_4Hz,
	input			tank1_state,
	input			tank2_state,
	input			tank3_state,
	input			tank4_state,
	
	
	output	reg 	tank1_en,
	output	reg 	tank2_en,
	output	reg 	tank3_en,
	output	reg  	tank4_en
);

reg 	[3:0] 		cnt_reg_1;
reg		[3:0]		cnt_reg_2;
reg 	[3:0]		cnt_reg_3;
reg 	[3:0]		cnt_reg_4;
reg 	[5:0]		cnt_game_start;
reg					game_start_flag;


initial
begin
	game_start_flag 	<= 	1'b0;
	cnt_reg_1 			<= 	4'b0;
	cnt_reg_2 			<= 	4'b0;
	cnt_reg_3 			<= 	4'b0;
	cnt_reg_4 			<= 	4'b0;
	cnt_game_start 		<= 	6'b0;
end

always@(posedge clk_4Hz)
begin
	if (game_start_flag == 1'b0)
		begin
			cnt_game_start <= cnt_game_start + 1'b1;
		if (cnt_game_start >= 4)
			begin
			tank1_en <= 1'b1;
			end
		if (cnt_game_start >= 16)
			begin
			tank2_en <= 1'b1;
			tank1_en <= 1'b0;
			end
		if (cnt_game_start >= 28)
			begin
			tank3_en <= 1'b1;
			tank2_en <= 1'b0;
			end
		if (cnt_game_start >= 40)
			begin
			tank4_en <= 1'b1;
			tank3_en <= 1'b0;
			end
		if	(cnt_game_start >= 52)
			begin
			tank4_en <= 1'b0;
			game_start_flag	 <= 1'b1;
			cnt_game_start 	 <= 6'b0;
			end
		end
	else
		begin
		if (tank1_state == 0)
			cnt_reg_1 <= cnt_reg_1 + 1'b1;
		if (tank2_state == 0)
			cnt_reg_2 <= cnt_reg_2 + 1'b1;
		if (tank3_state == 0)
			cnt_reg_3 <= cnt_reg_3 + 1'b1;
		if (tank4_state == 0)
			cnt_reg_4 <= cnt_reg_4 + 1'b1;

		if (cnt_reg_1 >= 12 && cnt_reg_1 <= 15)
		begin
			cnt_reg_1 <= cnt_reg_1 + 1'b1;
			tank1_en <= 1'b1;
		end
		if (cnt_reg_2 >= 12 && cnt_reg_2 <= 15)
		begin
			cnt_reg_2 <= cnt_reg_2 + 1'b1;
			tank2_en <= 1'b1;
		end
		if (cnt_reg_3 >= 12 && cnt_reg_3 <= 15)
		begin
			cnt_reg_3 <= cnt_reg_3 + 1'b1;
			tank3_en <= 1'b1;
		end
		if (cnt_reg_4 >= 12 && cnt_reg_4 <= 15)
		begin
			cnt_reg_4 <= cnt_reg_4 + 1'b1;
			tank4_en <= 1'b1;
		end
		if (cnt_reg_1 == 16)
		begin	
			tank1_en <= 0;
			cnt_reg_1 <= 1'b0;
		end
		if (cnt_reg_2 == 16)
		begin	
			tank2_en <= 0;
			cnt_reg_2 <= 1'b0;
		end
		if (cnt_reg_3 == 16)
		begin	
			tank3_en <= 0;
			cnt_reg_3 <= 1'b0;
		end
		if (cnt_reg_4 == 16)
		begin	
			tank4_en <= 0;
			cnt_reg_4 <= 1'b0;
		end
		end
end

endmodule 