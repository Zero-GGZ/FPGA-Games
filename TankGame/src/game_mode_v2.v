/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				game_mode_v2.v
Date				:				2018-05-13
Description			:				the game mode switches module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180515		ctlvie		1.0			Initial version
180523		ctlvie		1.2			Add reward function enable interface
180525		ctlvie		2.0			Final Version
========================================================*/

module  game_mode_v2
(
	input 				clk,
	input				bt_st,
	input				btn_mode_sel,
	input				btn_return,
	input				gameover_classic,
	input				gameover_infinity,
	output		reg		enable_bul1,
	output		reg		enable_bul2,
	output		reg		enable_bul3,
	output		reg		enable_bul4,
	output		reg		enable_mybul,
	output		reg		enable_mytank_app,
	output		reg		enable_mytank_phy,
	output		reg		enable_enytank1_app,
	output		reg		enable_enytank1_phy,
	output		reg		enable_enytank2_app,
	output		reg		enable_enytank2_phy,
	output		reg		enable_enytank3_app,
	output		reg		enable_enytank3_phy,
	output		reg		enable_enytank4_app,
	output		reg		enable_enytank4_phy,
	output		reg		enable_game_classic,
	output		reg		enable_game_infinity,
	output		reg		enable_reward,
	output		reg		enable_startmusic,
	output		reg		enable_gamemusic,
	output		reg		start_protect,
//	output		reg		enable_shootmusic,
	output 		reg		[2:0] mode
);              
                
initial 	mode <= 0;
reg			[63:0]	start_protect_cnt;
reg			start_protect_flag;
initial		start_protect_cnt <= 0;
initial		start_protect_flag <= 0;

always@(posedge clk )
begin
case (mode)
0:
begin
	enable_bul1			<= 1'b0;
	enable_bul2 		<= 1'b0;
	enable_bul3 		<= 1'b0;
	enable_bul4 		<= 1'b0;
	enable_mybul		<= 1'b0;
	enable_mytank_app	<= 1'b0;
	enable_mytank_phy	<= 1'b0;
	enable_enytank1_app <= 1'b0;
	enable_enytank1_phy <= 1'b0;
	enable_enytank2_app <= 1'b0;
	enable_enytank2_phy <= 1'b0;
	enable_enytank3_app <= 1'b0;
	enable_enytank3_phy <= 1'b0;
	enable_enytank4_app <= 1'b0;
	enable_enytank4_phy <= 1'b0;
	enable_game_classic	<= 1'b0;
	enable_game_infinity<= 1'b0;
	enable_reward		<= 1'b0;
	enable_startmusic	<= 1'b1;
	enable_gamemusic	<= 1'b0;
	start_protect_flag 	<= 1'b0;
	start_protect		<= 1'b0;
	//enable_shootmusic	<= 1'b0;
	if(bt_st == 1)
	begin
		if(btn_mode_sel)
			mode <= 1;
		else
			mode <= 2;
	end
	else
		mode <= 0;
end
1:
begin
	enable_bul1			<= 1'b1;
	enable_bul2 		<= 1'b1;
	enable_bul3 		<= 1'b1;
	enable_bul4 		<= 1'b1;
	enable_mybul		<= 1'b1;
	enable_mytank_app	<= 1'b1;
	enable_mytank_phy	<= 1'b1;
	enable_enytank1_app <= 1'b1;
	enable_enytank1_phy <= 1'b1;
	enable_enytank2_app <= 1'b1;
	enable_enytank2_phy <= 1'b1;
	enable_enytank3_app <= 1'b1;
	enable_enytank3_phy <= 1'b1;
	enable_enytank4_app <= 1'b1;
	enable_enytank4_phy <= 1'b1;
	enable_game_classic	<= 1'b1;
	enable_game_infinity<= 1'b0;
	enable_reward		<= 1'b1;
	enable_startmusic	<= 1'b0;
	enable_gamemusic	<= 1'b0;
	if(start_protect_flag == 0)
	begin
		start_protect_cnt <= start_protect_cnt + 1;
		start_protect <= 1;
		if(start_protect_cnt >= 300000000)
		begin
		start_protect_flag <= 1'b1;
		start_protect <= 0;
		start_protect_cnt <= 0;
		end
	end
	
//	enable_shootmusic	<= 1'b1;
	if( gameover_classic == 1)
		mode <= 3;
	else
		mode <= 1;
end
2:
begin
	enable_bul1			<= 1'b1;
	enable_bul2 		<= 1'b1;
	enable_bul3 		<= 1'b1;
	enable_bul4 		<= 1'b1;
	enable_mybul		<= 1'b1;
	enable_mytank_app	<= 1'b1;
	enable_mytank_phy	<= 1'b1;
	enable_enytank1_app <= 1'b1;
	enable_enytank1_phy <= 1'b1;
	enable_enytank2_app <= 1'b1;
	enable_enytank2_phy <= 1'b1;
	enable_enytank3_app <= 1'b1;
	enable_enytank3_phy <= 1'b1;
	enable_enytank4_app <= 1'b1;
	enable_enytank4_phy <= 1'b1;
	enable_game_classic	<= 1'b0;
	enable_game_infinity<= 1'b1;
	enable_reward		<= 1'b1;
	enable_startmusic	<= 1'b0;
	enable_gamemusic	<= 1'b0;
	start_protect_flag 	<= 1'b0;
	start_protect		<= 1'b0;
	//enable_shootmusic	<= 1'b1;
	if( gameover_infinity == 1)
		mode <= 3;
	else
		mode <= 2;
end
3:
begin
	enable_bul1			<= 1'b0;
	enable_bul2 		<= 1'b0;
	enable_bul3 		<= 1'b0;
	enable_bul4 		<= 1'b0;
	enable_mybul		<= 1'b0;
	enable_mytank_app	<= 1'b0;
	enable_mytank_phy	<= 1'b0;
	enable_enytank1_app <= 1'b0;
	enable_enytank1_phy <= 1'b0;
	enable_enytank2_app <= 1'b0;
	enable_enytank2_phy <= 1'b0;
	enable_enytank3_app <= 1'b0;
	enable_enytank3_phy <= 1'b0;
	enable_enytank4_app <= 1'b0;
	enable_enytank4_phy <= 1'b0;
	enable_game_classic	<= 1'b0;
	enable_game_infinity<= 1'b0;
	enable_reward		<= 1'b0;
	enable_startmusic	<= 1'b0;
	enable_gamemusic	<= 1'b1;
	start_protect_flag 	<= 1'b0;
	start_protect		<= 1'b0;
	//enable_shootmusic	<= 1'b0;
	if(btn_return)
		mode <= 0;
	else
		mode <= 3;
end
endcase
end

endmodule