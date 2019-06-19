/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				item_logic.v
Date				:				2018-05-22
Description			:				The logical module of the reward mechanism

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180522		ctlvie		1.0			Initial Version
180524		ctlvie		1.2			Add enable interface
180525		ctlvie		2.0			Final Version
========================================================*/
`timescale 1ns/1ns

module item_logic
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
	input				start_protect,
	output	reg 		item_invincible,
	output	reg 		item_addtime,
	output	reg 		item_faster,
	output	reg 		item_frozen,
	output	reg 		item_laser,
	output	 [11:0]		VGA_data_reward
);


wire	[2:0]		item_type;
wire	[4:0] 		random_xpos;
wire	[4:0]		random_ypos;
reg		[9:0]		cnt;
wire				set_require;
reg					set_finish;
wire	[11:0]		VGA_data_icon;
wire	[11:0]		VGA_data_information;
	
assign				VGA_data_reward = VGA_data_icon | VGA_data_information;


always@(posedge clk_4Hz)
begin
if(enable_reward)
begin

	if(	(set_require == 1'b1 &&(random_xpos == mytank_xpos)&& (random_ypos == mytank_ypos)) 
		|| sw[5] == 1 || sw[4] == 1 || sw[3] == 1 || sw[2] == 1 || sw[1] == 1 || start_protect == 1)
		begin
		if(sw[5] == 1 || sw[4] == 1 || sw[3] == 1 || sw[2] == 1 || sw[1] == 1 || start_protect == 1)
			begin
			if (sw[5] == 1 || start_protect == 1)
				item_invincible <= 1'b1;
			else if(sw[3])
				item_faster <= 1'b1;
			else if(sw[2])
				item_frozen <= 1'b1;
			else if(sw[1])
				item_laser <= 1'b1;
			else
				begin
				item_invincible	<= 1'b0;
				item_addtime		<= 1'b0;
				item_faster		<= 1'b0;
				item_frozen		<= 1'b0;
				item_laser		<= 1'b0;
				end
			end
		else
			begin
			case(item_type)
			1 : 
				begin
				if(enable_game_classic)
					item_invincible <= 1'b1;
				if(enable_game_infinity)
					item_addtime <= 1'b1;
				end
			2 :	item_faster <= 1'b1;
			3 :	item_frozen <= 1'b1;		
			4 :	item_laser <= 1'b1;
			default :
			begin
				item_invincible	<= 1'b0;
				item_addtime		<= 1'b0;
				item_faster		<= 1'b0;
				item_frozen		<= 1'b0;
				item_laser		<= 1'b0;
			end
			endcase
			set_finish <= 1'b1;
			end
		end
	else
		set_finish <= 1'b0;
	
		
	
	if(item_invincible)
	begin
		cnt <= cnt + 1;
		if (cnt >= 30)
			begin
			item_invincible <= 1'b0;
			cnt <= 0;
			end
	end
	
	if(item_faster)
	begin
		cnt <= cnt + 1;
		if (cnt >= 30)
			begin
			item_faster <= 1'b0;
			cnt <= 0;
			end
	end
	
	if(item_frozen)
	begin
		cnt <= cnt + 1;
		if (cnt >= 30)
			begin
			item_frozen <= 1'b0;
			cnt <= 0;
			end
	end
	
	if(item_laser)
	begin
		cnt <= cnt + 1;
		if (cnt >= 30)
			begin
			item_laser <= 1'b0;
			cnt <= 0;
			end
	end
end
end

item_random_generator		u_item_random_generator
(
	.clk				(clk), 
	.clk_4Hz			(clk_4Hz),
	.set_finish			(set_finish),
	.set_require		(set_require),
	.enable				(enable_reward),
	.dout				(random_out),
	.item_type		(item_type),	
	.random_xpos		(random_xpos),
	.random_ypos		(random_ypos)
);

item_display		u_item_display
(
	.clk				(clk),
	.set_require		(set_require),
	.enable_reward		(enable_reward),
	.enable_game_classic(enable_game_classic),
	.enable_game_infinity(enable_game_infinity),
	.random_xpos		(random_xpos),
	.random_ypos		(random_ypos),
	.item_type		(item_type),
	.VGA_xpos			(VGA_xpos),
	.VGA_ypos			(VGA_ypos),
	.VGA_data			(VGA_data_icon)
);

item_information	u_item_information
(
	.clk				(clk),
	.item_cnt			(cnt),
	.enable_reward		(enable_reward),
	.item_invincible	(item_invincible),
	.item_frozen		(item_frozen),
	.item_faster		(item_faster),
	.item_laser		(item_laser),
	.VGA_xpos			(VGA_xpos),
	.VGA_ypos			(VGA_ypos),
	.VGA_data			(VGA_data_information)
);


endmodule