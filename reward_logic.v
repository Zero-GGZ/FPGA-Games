/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				reward_logic.v
Date				:				2018-05-22
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180522		QiiNn		1.0			Initial Version
180524		QiiNn		1.2			Add enable interface
========================================================*/
`timescale 1ns/1ns

module reward_logic
(
	input				clk,
	input				clk_4Hz,
	input				enable_reward,
	input				enable_game_classic,
	input				enable_game_infinity,
	input 	[4:0]		mytank_xpos, 
	input 	[4:0]		mytank_ypos,
	input	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	input	[15:0]		sw,
	output				random_out,
	output	reg 		reward_invincible,
	output	reg 		reward_addtime,
	output	reg 		reward_faster,
	output	reg 		reward_frozen,
	output	reg 		reward_laser,
	output	 [11:0]		VGA_data_reward,

	output				set_finish_test,
	output				set_require_test
);

assign	set_finish_test = set_finish;
assign	set_require_test = set_require;

wire	[2:0]	reward_type;
wire	[4:0] 		random_xpos;
wire	[4:0]		random_ypos;
reg	[9:0]		cnt;
wire			set_require;
reg				set_finish;
wire	[11:0]	VGA_data_icon;
wire	[11:0]	VGA_data_information;

assign			VGA_data_reward = VGA_data_icon | VGA_data_information;


always@(posedge clk_4Hz)
begin
if(enable_reward)
begin
	if(random_xpos != 0 && random_ypos != 0)
	begin
			if(set_require == 1'b1 &&(random_xpos == mytank_xpos)&& (random_ypos == mytank_ypos))
				begin
				case(reward_type)
				1 : 
					begin
					if(enable_game_classic)
						reward_invincible <= 1'b1;
					if(enable_game_infinity)
						reward_addtime <= 1'b1;
					end
				2 :	reward_faster <= 1'b1;
				3 :	reward_frozen <= 1'b1;		
				4 :	reward_laser <= 1'b1;
				default :
				begin
					reward_invincible	<= 1'b0;
					reward_addtime		<= 1'b0;
					reward_faster		<= 1'b0;
					reward_frozen		<= 1'b0;
					reward_laser		<= 1'b0;
				end
				endcase
				set_finish <= 1'b1;
				end
			else
				set_finish <= 1'b0;
			
	end
	else
		set_finish <= 1'b0;
	
		
	
	if(reward_invincible)
	begin
		cnt <= cnt + 1;
		if (cnt >= 20)
			begin
			reward_invincible <= 1'b0;
			cnt <= 0;
			end
	end
	
	if(reward_faster)
	begin
		cnt <= cnt + 1;
		if (cnt >= 20)
			begin
			reward_faster <= 1'b0;
			cnt <= 0;
			end
	end
	
	if(reward_frozen)
	begin
		cnt <= cnt + 1;
		if (cnt >= 20)
			begin
			reward_frozen <= 1'b0;
			cnt <= 0;
			end
	end
	
	if(reward_laser)
	begin
		cnt <= cnt + 1;
		if (cnt >= 20)
			begin
			reward_laser <= 1'b0;
			cnt <= 0;
			end
	end
end
end

reward_random_generator		u_reward_random_generator
(
	.clk				(clk), 
	.clk_4Hz			(clk_4Hz),
	.set_finish			(set_finish),
	.set_require		(set_require),
	.enable				(enable_reward),
	.dout				(random_out),
	.reward_type		(reward_type),	
	.random_xpos		(random_xpos),
	.random_ypos		(random_ypos)
);

reward_display		u_reward_display
(
	.clk				(clk),
	.set_require		(set_require),
	.enable_reward		(enable_reward),
	.enable_game_classic(enable_game_classic),
	.enable_game_infinity(enable_game_infinity),
	.random_xpos		(random_xpos),
	.random_ypos		(random_ypos),
	.reward_type		(reward_type),
	.VGA_xpos			(VGA_xpos),
	.VGA_ypos			(VGA_ypos),
	.VGA_data			(VGA_data_icon),
	
	// test interface
	.display_test				()
);

reward_information	u_reward_information
(
	.clk				(clk),
	.reward_cnt			(cnt),
	.enable_reward		(enable_reward),
	.reward_invincible	(reward_invincible),
	.reward_frozen		(reward_frozen),
	.reward_faster		(reward_faster),
	.reward_laser		(reward_laser),
	.VGA_xpos			(VGA_xpos),
	.VGA_ypos			(VGA_ypos),
	.VGA_data			(VGA_data_information)
);


endmodule