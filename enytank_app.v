/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				enytank_app.v
Date				:				2018-05-05
Description			:				the application module of enemy's tank 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
180508		QiiNn		1.0			Initial coding complete (unverified)
180509		QiiNn		1.1			Corrected the reg conflict error(unverified)
========================================================*/

`timescale 1ns/1ns

module enytank_app
(
	input 			clk,
	input 			clk_4Hz,
	input 			tank_en,
	
	input	[1:0]	tank_num,//888888888888888888888888888		
	
	input	[4:0] 	mybul_x,
	input 	[4:0]	mybul_y,
	
	input 	[4:0]	mytank_xpos,
	input	[4:0]	mytank_ypos,
	
	input 			enybul_state_feedback,  //8888888888888888888
	
	output  reg			enybul_state,
	output	reg			tank_state,
	output	reg	[4:0] 	enytank_xpos,
	output	reg	[4:0]	enytank_ypos,
	output	reg	[1:0]	tank_dir_out	
);

reg 	tank_state_reg;
initial tank_state_reg <= 1'b0;
initial tank_state <= 1'b0;



//---------------------------------------------------
//Calculate the distance between my tank 
//and the enemy tank in each directions 
reg 	[4:0]	left_dis;
reg		[4:0]	right_dis;
reg		[4:0]	up_dis;
reg		[4:0]	down_dis;
reg		[4:0]	horizontal_dis;
reg		[4:0]	vertical_dis;

initial
begin
	left_dis <= 5'b0;
	right_dis <= 5'b0;
	up_dis <= 5'b0;
	down_dis <= 5'b0;
	horizontal_dis <= 5'b0;
	vertical_dis <= 5'b0;
end

always@(posedge clk)
begin
	if (tank_state_reg == 1'b1)
	begin
		left_dis <= enytank_xpos - mytank_xpos;
		right_dis <= mytank_xpos - enytank_xpos;
		up_dis <= mytank_ypos - enytank_ypos;
		down_dis <= enytank_ypos - mytank_ypos;
		if(left_dis >= 0) horizontal_dis <= left_dis;
		else horizontal_dis <= right_dis;
		if(up_dis >= 0) vertical_dis <= up_dis;
		else vertical_dis <= down_dis;
	end
end



//---------------------------------------------------
//generate and move to my tank by steps and check whether it was hit
always@(posedge clk_4Hz)
begin
	//enemy tank's generation and initialization
	if (tank_state_reg == 1'b0  && tank_en == 1'b1)
	begin
		tank_state <= 1'b1;
		tank_state_reg <= 1'b1;
		if(tank_num == 2'b00)
		begin
			enytank_xpos <= 0;
			enytank_ypos <= 0;
		end
		else if (tank_num == 2'b01)
		begin
			enytank_xpos <= 16;
			enytank_ypos <= 0;
		end
		else if (tank_num == 2'b10)
		begin
			enytank_xpos <= 0;
			enytank_ypos <= 20;
		end
		else if (tank_num == 2'b10)
		begin
			enytank_xpos <= 16;
			enytank_ypos <= 20;
		end
	end
	
	//move
	if (tank_state_reg == 1'b1)
	begin
		if(horizontal_dis < vertical_dis)
		begin
			if	((left_dis > 0)&&(enytank_xpos > 0))
			begin
				tank_dir_out <= 2'b10;
				enytank_xpos <= enytank_xpos - 1;
			end
			if	((right_dis > 0)&&(enytank_xpos < 16))
			begin
				tank_dir_out <= 2'b11;
				enytank_xpos <= enytank_xpos + 1;
			end
		end
		else 
		begin
			if	((up_dis > 0)&&(enytank_ypos > 0))
			begin
				tank_dir_out <= 2'b00;
				enytank_ypos <= enytank_ypos - 1;
			end
			if	((down_dis > 0)&&(enytank_ypos < 20))
			begin
				tank_dir_out <= 2'b01;
				enytank_ypos <= enytank_ypos + 1;
			end
		end
	end
	
	//check whether the tank was hit
	if ((tank_state_reg == 1'b1) && (enytank_xpos == mybul_x) && (enytank_ypos == mybul_y))
	begin
		tank_state_reg <= 1'b0;
		tank_state <= 1'b0;		
	end
end

//---------------------------------------------------
//shoot if horizontal distance = 0 or vertical distance = 0
always@(posedge clk_4Hz)
begin
	if(tank_state_reg == 1'b1)
	begin
		if((horizontal_dis == 0)&&(enybul_state_feedback == 1'b0))
		begin
			enybul_state <= 1'b1;
		end
		if((vertical_dis == 0)&&(enybul_state_feedback == 1'b0))
		begin
			enybul_state <= 1'b1;
		end
	end
	if (enybul_state_feedback == 1'b0)
		enybul_state <= 1'b0;
end


endmodule