/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				game_top.v
Date				:				2018-05-06
Description			:				the top module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180506		ctlvie		0.5			Module interface definition and modules links
180507		ctlvie		0.6			Update some modules' interfaces
180510		ctlvie		0.8			Bugs fixed:
									1. change enemy tanks' speed to clk_2Hz
									2. cancel the VGA enable signal
180510		ctlvie		1.5			Full Version!
180515		ctlvie		1.8			Updated Version!
180525		ctlvie		2.0			Final Version
========================================================*/

`timescale 1ns/1ns

module game_top
(	
	input 					clk,
	
	input 					bt_w,
	input 					bt_a,
	input 					bt_s,
	input 					bt_d,
	input 					bt_st,
	input		[15:0]		sw,	
	input					fpga_rxd,
	output					Hsync,
	output					Vsync,
	output		[3:0]		vgaRed,
	output		[3:0]		vgaBlue,
	output		[3:0]		vgaGreen,
	output		[3:0]		an,
	output		[6:0]		seg,
	output					dp,
	output		[15:0]		led,
	output					fpga_txd,
	output					audio
);

//----------------------------------------
//wires definition
//clocks
wire			clk_2Hz;
wire			clk_4Hz;
wire			clk_8Hz;
wire			clk_100M;
wire			clk_VGA;


wire	[4:0]	shell1_x;
wire	[4:0]	shell1_y;
wire	[4:0]	shell2_x;
wire	[4:0]	shell2_y;
wire	[4:0]	shell3_x;
wire	[4:0]	shell3_y;
wire	[4:0]	shell4_x;
wire	[4:0]	shell4_y;

//wires about my tank
wire			mytank_en;
wire	[4:0]	mytank_xpos;
wire	[4:0]	mytank_ypos;
wire 	[4:0]	mytank_xpos_feedback;// = mytank_xpos;
wire 	[4:0]	mytank_ypos_feedback;// = mytank_ypos;
wire	[1:0]	mytank_dir;
wire			mytank_sht;
wire			mytank_state;
wire			myshell_state_fb;

//wires about enemy tank 1
wire			enemytank1_en;
wire			enemytank1_state;
wire	[4:0]	enemytank1_xpos;
wire	[4:0]	enemytank1_ypos;
wire	[1:0]	enemytank1_dir;
wire			enemyshell1_state_fb;

//wires about enemy tank 2
wire			enemytank2_en;
wire			enemytank2_state;
wire	[4:0]	enemytank2_xpos;
wire	[4:0]	enemytank2_ypos;
wire	[1:0]	enemytank2_dir;
wire			enemyshell2_state_fb;

//wires about enemy tank 3
wire			enemytank3_en;
wire			enemytank3_state;
wire	[4:0]	enemytank3_xpos;
wire	[4:0]	enemytank3_ypos;
wire	[1:0]	enemytank3_dir;
wire			enemyshell3_state_fb;

//wires about enemy tank 4
wire			enemytank4_en;
wire			enemytank4_state;
wire	[4:0]	enemytank4_xpos;
wire	[4:0]	enemytank4_ypos;
wire	[1:0]	enemytank4_dir;
wire			enemyshell4_state_fb;

//wires about shells
wire	[4:0]	myshell_xpos;
wire	[4:0]	myshell_ypos;
wire	[4:0]	myshell_xpos_feedback;
wire	[4:0]	myshell_ypos_feedback;
wire	[11:0]	VGA_data_myshell;	
wire	[4:0]	shell1_x_feedback;
wire	[4:0]	shell1_y_feedback;
wire			shell1_state;
wire	[11:0]	VGA_data_shell1;
wire	[4:0]	shell2_x_feedback;
wire	[4:0]	shell2_y_feedback;
wire			shell2_state;
wire	[11:0]	VGA_data_shell2;
wire	[4:0]	shell3_x_feedback;
wire	[4:0]	shell3_y_feedback;
wire			shell3_state;
wire	[11:0]	VGA_data_shell3;
wire	[4:0]	shell4_x_feedback;
wire	[4:0]	shell4_y_feedback;
wire			shell4_state;
wire	[11:0]	VGA_data_shell4;
wire	[11:0]	VGA_data_mytank;
wire	[11:0]	VGA_data_enemytank1;
wire	[11:0]	VGA_data_enemytank2;
wire	[11:0]	VGA_data_enemytank3;
wire	[11:0]	VGA_data_enemytank4;
wire	[11:0]	VGA_data_info;
wire	[11:0]	VGA_data_reward;
wire	[11:0]	VGA_data_item_laser;
wire 	[10:0]	VGA_xpos;
wire 	[10:0]	VGA_ypos;
wire 	[11:0]	VGA_data;

wire		enable_shell1;
wire		enable_shell2;
wire		enable_shell3;
wire		enable_shell4;
wire		enable_myshell;
wire		enable_mytank_control;
wire		enable_mytank_display;
wire		enable_enemytank1_control;
wire		enable_enemytank1_display;
wire		enable_enemytank2_control;
wire		enable_enemytank2_display;
wire		enable_enemytank3_control;
wire		enable_enemytank3_display;
wire		enable_enemytank4_control;
wire		enable_enemytank4_display;
wire		enable_gamelogic;
wire		enable_reward;
wire		enable_startmusic;	
wire        enable_gamemusic;	
wire		enable_shootmusic;

wire		[4:0]		HP_value;
wire		[5:0]		timer;
wire		[6:0]		score;
wire		[11:0]		VGA_data_interface;
wire		[2:0]		mode;
wire				kill1;
wire				kill2;
wire				kill3;
wire				kill4;
wire				kill;
assign				kill = kill1 | kill2 | kill3 | kill4;

wire	[6:0]		score1;
wire	[6:0]		score2;
wire	[6:0]		score3;
wire	[6:0]		score4;
wire				gameover;


wire				gameover_classic;
wire				gameover_infinity;
wire				enable_game_classic;
wire				enable_game_infinity;
wire	[3:0]		an_classic;
wire	[15:0]		seg_classic;
wire	[15:0]		led_classic;
wire	[3:0]		an_infinity;
wire	[15:0]		seg_infinity;
wire	[15:0]		led_infinity;
wire	[6:0]		score_classic;
wire	[6:0]		score_infinity;

wire				btn_wireless_w;
wire				btn_wireless_s;
wire				btn_wireless_a;
wire				btn_wireless_d;
wire				btn_wireless_st;
wire				btn_wireless_tri;
wire				btn_wireless_sqr;
wire				btn_wireless_cir;
wire				btn_wireless_cro;
wire				btn_w ;
wire				btn_s ;
wire				btn_a ;
wire				btn_d ;
wire				btn_st;
wire				btn_mode_sel;
wire				btn_return;
wire				btn_stop;

wire				item_addtime;
wire				item_faster;
wire				item_frozen;
wire				item_invincible;
wire				item_laser;
wire				start_protect;


assign 			shell1_x 			= 		shell1_x_feedback;
assign 			shell2_x 			= 		shell2_x_feedback;
assign 			shell3_x 			= 		shell3_x_feedback;
assign 			shell4_x 			= 		shell4_x_feedback;
assign 			shell1_y 			= 		shell1_y_feedback;
assign 			shell2_y 			= 		shell2_y_feedback;
assign 			shell3_y 			= 		shell3_y_feedback;
assign 			shell4_y 			= 		shell4_y_feedback;
assign			myshell_xpos 		= 		myshell_xpos_feedback;
assign			myshell_ypos 		= 		myshell_ypos_feedback;
assign			mytank_xpos 	= 		mytank_xpos_feedback;
assign			mytank_ypos 	= 		mytank_ypos_feedback;




clk_wiz_0 u_VGA_clock
   (
    // Clock out ports
    .clk_out1	(clk_100M),     // output clk_out1
    .clk_out2	(clk_VGA),     // output clk_out2
   // Clock in ports
    .clk_in1	(clk)
	);		


	
clock u_clock
(
	.clk			(clk_100M),
	.item_faster	(item_faster),
	.clk_4Hz		(clk_4Hz),
	.clk_8Hz		(clk_8Hz),
	.clk_2Hz		(clk_2Hz)
);


game_mode  u_game_mode
(
	.clk				(clk_100M),	
	.bt_st				(btn_st),
	.btn_mode_sel		(btn_mode_sel),
	.btn_return			(btn_return),
	.gameover_classic	(gameover_classic),
	.gameover_infinity	(gameover_infinity),
	.enable_shell1		(enable_shell1),
	.enable_shell2		(enable_shell2),
	.enable_shell3		(enable_shell3),
	.enable_shell4		(enable_shell4),
	.enable_myshell		(enable_myshell),
	.enable_mytank_control	(enable_mytank_control),
	.enable_mytank_display	(enable_mytank_display),
	.enable_enemytank1_control(enable_enemytank1_control),
	.enable_enemytank1_display(enable_enemytank1_display),
	.enable_enemytank2_control(enable_enemytank2_control),
	.enable_enemytank2_display(enable_enemytank2_display),
	.enable_enemytank3_control(enable_enemytank3_control),
	.enable_enemytank3_display(enable_enemytank3_display),
	.enable_enemytank4_control(enable_enemytank4_control),
	.enable_enemytank4_display(enable_enemytank4_display),
	.enable_game_classic(enable_game_classic),
	.enable_game_infinity(enable_game_infinity),
	.enable_reward		(enable_reward),
	.enable_startmusic	(enable_startmusic),
	.enable_gamemusic	(enable_gamemusic),
	.start_protect		(start_protect),
//	.enable_shootmusic	(enable_shootmusic),
	.mode				(mode)
);   

game_logic_classic u_game_logic_classic
(	
	.clk				(clk_100M),
	.btn_return			(btn_return),
	.btn_stop			(btn_stop),
	.enable_game_classic(enable_game_classic),
	.mytank_state		(mytank_state),
	.scorea				(score1),
	.scoreb				(score2),
	.scorec				(score3),
	.scored				(score4),
	.item_invincible	(item_invincible),
	.HP_value			(HP_value),
	.seg_classic		(seg_classic),
	.led_classic		(led_classic),
	.gameover_classic	(gameover_classic),
	.score_classic		(score_classic)
);

game_logic_infinity u_game_logic_infinity
(
	.clk				(clk_100M),
	.btn_return			(btn_return),
	.btn_stop			(btn_stop),
	.enable_game_infinity(enable_game_infinity),
	.scorea				(score1),
	.scoreb				(score2),
	.scorec				(score3),
	.scored				(score4),
	.item_addtime		(item_addtime),
	.item_test		(sw[4]),
	.timer				(timer),
	.seg_infinity		(seg_infinity),
	.led_infinity		(led_infinity),
	.gameover_infinity	(gameover_infinity),
	.score_infinity		(score_infinity)
);

game_information	u_game_information
(
	.clk					(clk_100M),
	.enable_game_classic	(enable_game_classic),
	.enable_game_infinity	(enable_game_infinity),
	.mode					(mode),
	.HP_print				(HP_value),
	.time_print				(timer),
	.VGA_xpos				(VGA_xpos),
	.VGA_ypos				(VGA_ypos),
	.VGA_data				(VGA_data_info)
);

game_SegAndLed 	u_game_SegAndLed
(
	.clk					(clk_100M),
	.mode					(mode),
	.sw						(sw),
	.led_classic			(led_classic),
	.led_infinity			(led_infinity),
	.seg_classic			(seg_classic),
	.seg_infinity			(seg_infinity),
	.score_classic			(score_classic),
	.score_infinity			(score_infinity),
	.enable_game_classic	(enable_game_classic),
	.enable_game_infinity	(enable_game_infinity),
	.an						(an),
	.seg					(seg),
	.led					(led)
);


game_background  u_game_background
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.clk_8Hz		(clk_8Hz),
	.btn_mode_sel	(btn_mode_sel),
	.mode			(mode),
	.VGA_xpos		(VGA_xpos),
	.VGA_ypos		(VGA_ypos),
	.VGA_data		(VGA_data_interface)
);

item_logic	u_item_logic
(
	.clk					(clk_100M),
	.clk_4Hz				(clk_4Hz),
	.enable_reward			(enable_reward),
	.enable_game_classic	(enable_game_classic),
	.enable_game_infinity	(enable_game_infinity),
	.mytank_xpos			(mytank_xpos), 
	.mytank_ypos			(mytank_ypos),
	.VGA_xpos				(VGA_xpos),
	.VGA_ypos				(VGA_ypos),
	.sw						(sw),
	.start_protect			(start_protect),
	.item_invincible		(item_invincible),
	.item_addtime			(item_addtime),
	.item_faster			(item_faster),
	.item_frozen			(item_frozen),
	.item_laser			(item_laser),
	.VGA_data_reward		(VGA_data_reward)
);


item_laser	u_item_laser
(
	.clk			(clk_100M),
	.enable_reward	(enable_reward),
	.item_laser	(item_laser),
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	.mytank_dir		(mytank_dir),
	.VGA_xpos		(VGA_xpos),
	.VGA_ypos		(VGA_ypos),
	.VGA_data		(VGA_data_item_laser)
);


driver_buttons	u_driver_buttons
(
	.clk				(clk_100M),
	.sw					(sw),
	.bt_w				(bt_w),
	.bt_s				(bt_s),
	.bt_a				(bt_a),
	.bt_d				(bt_d),
	.bt_st				(bt_st),
	.btn_wireless_w		(btn_wireless_w),
	.btn_wireless_s		(btn_wireless_s),
	.btn_wireless_a		(btn_wireless_a),
	.btn_wireless_d		(btn_wireless_d),
	.btn_wireless_st	(btn_wireless_st),
	.btn_wireless_tri	(btn_wireless_tri),
	.btn_wireless_sqr	(btn_wireless_sqr),
	.btn_wireless_cir	(btn_wireless_cir),
	.btn_wireless_cro	(btn_wireless_cro),
	.btn_w				(btn_w),
	.btn_s  			(btn_s),
	.btn_a  			(btn_a),
	.btn_d  			(btn_d),
	.btn_st 			(btn_st),
	.btn_mode_sel		(btn_mode_sel),
	.btn_stop			(btn_stop),
	.btn_return			(btn_return)
);





mytank_control u_mytank_control
(
	.clk			(clk_100M),
	.clk_4Hz		(clk_4Hz),
	.enable			(enable_mytank_control),
	.tank_en		(1'b1),	//enable  
	
	// input button direction (w,a,s,d)
	.bt_w			(btn_w),
	.bt_a			(btn_a),
	.bt_s			(btn_s),
	.bt_d			(btn_d),
	.bt_st			(btn_st), // shoot button
	
	//input the position of each shell
	.shell1_x			(shell1_x),
	.shell1_y			(shell1_y),
	.shell2_x			(shell2_x),
	.shell2_y			(shell2_y),
	.shell3_x			(shell3_x),
	.shell3_y			(shell3_y),
	.shell4_x			(shell4_x),
	.shell4_y			(shell4_y),
	
	.myshell_state_feedback	(myshell_state_fb),
	//relative position input and output
	.x_rel_pos_in		(mytank_xpos),
	.y_rel_pos_in		(mytank_ypos),
	.x_rel_pos_out		(mytank_xpos_feedback),
	.y_rel_pos_out		(mytank_ypos_feedback),
	
	.tank_state		(mytank_state),
	
	.tank_dir_out	(mytank_dir),
	.shell_sht		(mytank_sht)
);


enemytank_control u_enemytank1_control
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enemytank1_control),
	.tank_en		(enemytank1_en),
	
	.tank_num		(2'b00),
	.myshell_x		(myshell_xpos),
	.myshell_y		(myshell_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	.item_frozen	(item_frozen),
	.item_laser	(item_laser),
	.mytank_dir			(mytank_dir),
	
	.kill				(kill1),
	.score				(score1),
	
	.enemyshell_state_feedback	(enemyshell1_state_fb),
	.enemyshell_state	(shell1_state),
	.tank_state		(enemytank1_state),
	.enemytank_xpos	(enemytank1_xpos),
	.enemytank_ypos	(enemytank1_ypos),
	.tank_dir_out	(enemytank1_dir)
);


enemytank_control u_enemytank2_control
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enemytank2_control),
	.tank_en		(enemytank2_en),
	
	.tank_num		(2'b01),
	.myshell_x		(myshell_xpos),
	.myshell_y		(myshell_ypos),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	.item_frozen	(item_frozen),
	.item_laser	(item_laser),
	.mytank_dir			(mytank_dir),
	.kill				(kill2),
	.score				(score2),
	
	.enemyshell_state_feedback	(enemyshell2_state_fb),
	.enemyshell_state	(shell2_state),
	.tank_state		(enemytank2_state),
	.enemytank_xpos	(enemytank2_xpos),
	.enemytank_ypos	(enemytank2_ypos),
	.tank_dir_out	(enemytank2_dir)
);



enemytank_control u_enemytank3_control
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enemytank3_control),
	.tank_en		(enemytank3_en),
	
	.tank_num		(2'b10),
	.myshell_x		(myshell_xpos),
	.myshell_y		(myshell_ypos),
	.item_frozen	(item_frozen),
	.item_laser	(item_laser),
	.mytank_dir			(mytank_dir),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	.kill				(kill3),
	.score				(score3),
	
	.enemyshell_state_feedback	(enemyshell3_state_fb),
	.enemyshell_state	(shell3_state),
	.tank_state		(enemytank3_state),
	.enemytank_xpos	(enemytank3_xpos),
	.enemytank_ypos	(enemytank3_ypos),
	.tank_dir_out	(enemytank3_dir)
);



enemytank_control u_enemytank4_control
(	
	.clk			(clk_100M),
	.clk_4Hz		(clk_2Hz),
	.clk_8Hz		(clk_8Hz),
	.enable			(enable_enemytank4_control),
	.tank_en		(enemytank4_en),
	
	.tank_num		(2'b11),
	.myshell_x		(myshell_xpos),
	.myshell_y		(myshell_ypos),
	.item_frozen	(item_frozen),
	.item_laser	(item_laser),
	.mytank_dir			(mytank_dir),
	
	.mytank_xpos	(mytank_xpos),
	.mytank_ypos	(mytank_ypos),
	.kill				(kill4),
	.score			(score4),
	
	.enemyshell_state_feedback	(enemyshell4_state_fb),
	.enemyshell_state	(shell4_state),
	.tank_state		(enemytank4_state),
	.enemytank_xpos	(enemytank4_xpos),
	.enemytank_ypos	(enemytank4_ypos),
	.tank_dir_out	(enemytank4_dir)
);


shell u_myshell
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_myshell),
	.shell_ide	(1'b0),

	
	.shell_dir	(mytank_dir),	//the direction of shell
	.shell_state	(mytank_sht),	//the state of my shell
	
	.tank_xpos	(mytank_xpos),
	.tank_ypos	(mytank_ypos),
	//input and output the position of my shell
	.x_shell_pos_out	(myshell_xpos_feedback),
	.y_shell_pos_out	(myshell_ypos_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_myshell),
	
	.shell_state_feedback	(myshell_state_fb)
);
	

shell u_shell1
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_shell1),
	.shell_ide	(1'b1),

	
	.shell_dir	(enemytank1_dir),	//the direction of shell
	.shell_state	(shell1_state),	//the state of my shell
	
	.tank_xpos	(enemytank1_xpos),
	.tank_ypos	(enemytank1_ypos),
	//input and output the position of my shell
	.x_shell_pos_out	(shell1_x_feedback),
	.y_shell_pos_out	(shell1_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_shell1),
	
	.shell_state_feedback	(enemyshell1_state_fb)
);



shell u_shell2
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_shell2),
	.shell_ide	(1'b1),

	
	.shell_dir	(enemytank2_dir),	//the direction of shell
	.shell_state	(shell2_state),	//the state of my shell
	
	.tank_xpos	(enemytank2_xpos),
	.tank_ypos	(enemytank2_ypos),
	//input and output the position of my shell
	.x_shell_pos_out	(shell2_x_feedback),
	.y_shell_pos_out	(shell2_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_shell2),
	
	.shell_state_feedback	(enemyshell2_state_fb)
);



shell u_shell3
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_shell3),
	.shell_ide	(1'b1),

	
	.shell_dir	(enemytank3_dir),	//the direction of shell
	.shell_state	(shell3_state),	//the state of my shell
	
	.tank_xpos	(enemytank3_xpos),
	.tank_ypos	(enemytank3_ypos),
	//input and output the position of my shell
	.x_shell_pos_out	(shell3_x_feedback),
	.y_shell_pos_out	(shell3_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_shell3),
	
	.shell_state_feedback	(enemyshell3_state_fb)
);



shell u_shell4
(
	.clk		(clk_100M),
	.clk_8Hz	(clk_8Hz),
	.enable		(enable_shell4),
	.shell_ide	(1'b1),

	
	.shell_dir	(enemytank4_dir),	//the direction of shell
	.shell_state	(shell4_state),	//the state of my shell
	
	.tank_xpos	(enemytank4_xpos),
	.tank_ypos	(enemytank4_ypos),
	//input and output the position of my shell
	.x_shell_pos_out	(shell4_x_feedback),
	.y_shell_pos_out	(shell4_y_feedback),
	
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	//input the VGA data
	.VGA_data	(VGA_data_shell4),
	
	.shell_state_feedback	(enemyshell4_state_fb)
);



tank_display	mytank_display
(
	.clk		(clk_100M),
	.enable		(enable_mytank_display),

	//input the relative position of tank
	.x_rel_pos	(mytank_xpos),
	.y_rel_pos	(mytank_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(mytank_state),	//the state of tank
	.tank_ide	(1'b1),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(mytank_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_mytank)
);



tank_display	enemytank1_display
(
	.clk		(clk_100M),
	.enable		(enable_enemytank1_display),
	//input the relative position of tank
	.x_rel_pos	(enemytank1_xpos),
	.y_rel_pos	(enemytank1_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enemytank1_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enemytank1_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enemytank1)
);



tank_display	enemytank2_display
(
	.clk		(clk_100M),
	.enable		(enable_enemytank2_display),
	//input the relative position of tank
	.x_rel_pos	(enemytank2_xpos),
	.y_rel_pos	(enemytank2_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enemytank2_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enemytank2_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enemytank2)
);



tank_display	enemytank3_display
(
	.clk		(clk_100M),
	.enable		(enable_enemytank3_display),
	//input the relative position of tank
	.x_rel_pos	(enemytank3_xpos),
	.y_rel_pos	(enemytank3_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enemytank3_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enemytank3_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enemytank3)
);



tank_display	enemytank4_display
(
	.clk		(clk_100M),
	.enable		(enable_enemytank4_display),
	//input the relative position of tank
	.x_rel_pos	(enemytank4_xpos),
	.y_rel_pos	(enemytank4_ypos),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(enemytank4_state),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(enemytank4_dir),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_enemytank4)
);


VGA_data_selector u_VGA_data_selector
(
	.clk	(clk_100M),
//input interfaces
	.in1	(VGA_data_shell1),
	.in2	(VGA_data_shell2),
	.in3	(VGA_data_shell3),
	.in4	(VGA_data_shell4),
	.in5	(VGA_data_enemytank1),
	.in6	(VGA_data_enemytank2),
	.in7	(VGA_data_enemytank3),
	.in8	(VGA_data_enemytank4),
	.in9	(VGA_data_myshell),
	.in10	(VGA_data_mytank),
	.in11	(VGA_data_interface),
	.in12	(VGA_data_info),
	.in13	(VGA_data_reward),
	.in14	(VGA_data_item_laser),
	.in15	(0),
	.in16	(0),
	.in17	(0),
	.in18	(0),
	.in19	(0),
	.in20	(0),
//output interfaces	
	.out	(VGA_data)
);

		
				
driver_VGA		u_driver_VGA
(
//global clock
	.clk		(clk_VGA),
	.rst_n		(1'b1),

//vga interface
	.Hsync		(Hsync),
	.Vsync		(Vsync),
	.VGA_en		(),
	.vgaRed		(vgaRed),
	.vgaBlue	(vgaBlue),
	.vgaGreen	(vgaGreen),

//user interface
	.VGA_request(),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	.VGA_data	(VGA_data)
);

tank_generate	u_tank_generate
(	
	.clk_4Hz	(clk_4Hz),
	
	.tank1_state(enemytank1_state),
	.tank2_state(enemytank2_state),
	.tank3_state(enemytank3_state),
	.tank4_state(enemytank4_state),
	
	.tank1_en	(enemytank1_en),
	.tank2_en	(enemytank2_en),
	.tank3_en	(enemytank3_en),
	.tank4_en	(enemytank4_en)
);

endmodule
