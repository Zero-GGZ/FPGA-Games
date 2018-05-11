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
180510		QiiNn		1.5			Full Version!
========================================================*/

`timescale 1ns/1ns

module enytank_app
(
	input 			clk,
	input 			clk_4Hz,
	input 			clk_8Hz,
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
reg 	btn_sht;

reg		bul_flying;

//---------------------------------------------------
//Calculate the distance between my tank 
//and the enemy tank in each directions 

reg				eql;		//if 
reg		[2:0]	rel_dir;	//relative direction (1:000,2:001,3:011,4:010,x+:100,x-:101,y+:110;y-:111;
reg		[4:0]	h_dis;	//horizontal distance
reg		[4:0]	v_dis;	//vertical distance

initial
begin
	eql <= 1'b0;
	rel_dir <= 	3'b0;
	h_dis 	<=	5'b0;
	v_dis 	<=	5'b0;
end

always@(posedge clk)
begin
	if (enytank_xpos == mytank_xpos && enytank_ypos == mytank_ypos)
	begin
		eql <= 1'b1;
		h_dis <= 1'b0;
		v_dis <= 1'b0;
	end
	else 
	begin
		eql <= 1'b0;
		rel_dir[2] <= 1'b0;
		if  (enytank_xpos < mytank_xpos)
			begin
			rel_dir[0] <= 1'b0;
			h_dis <= mytank_xpos - enytank_xpos;
			end
		else if	(enytank_xpos > mytank_xpos)
			begin
			h_dis <= enytank_xpos - mytank_xpos;
			rel_dir[0] <= 1'b1;
			end
		else 
			begin
			h_dis <= 1'b0;
			if (enytank_ypos > mytank_ypos)
				begin
				rel_dir <= 3'b110;
				end
			else
				begin
				rel_dir <= 3'b111;
				end
			end
			
		if	(enytank_ypos > mytank_ypos)
			begin
			v_dis <= enytank_ypos - mytank_ypos;
			rel_dir[1]	<= 1'b0;
			end
		else if (enytank_ypos < mytank_ypos)
			begin
			v_dis <= mytank_ypos - enytank_ypos;
			rel_dir[1]	<= 1'b1;
			end
		else
			begin
			v_dis <= 1'b0;
			if (enytank_xpos > mytank_xpos)
				rel_dir <= 3'b101;
			else
				rel_dir <= 3'b100;
			end
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
		else if (tank_num == 2'b11)
		begin
			enytank_xpos <= 16;
			enytank_ypos <= 20;
		end
	end
	
	//move
	if (tank_state_reg == 1'b1)
	begin
		if (eql)
			tank_dir_out <= tank_dir_out;
		else
			begin
			if ( h_dis == 0 && v_dis != 0)
				begin
				btn_sht <= 1'b1;
				if(rel_dir[0] == 0 && enytank_ypos > 0)	//up
					begin
					tank_dir_out <= 2'b00;
					enytank_ypos <= enytank_ypos - 1;
					end
				else if (rel_dir[0] == 1 && enytank_ypos < 20) //down
					begin
					tank_dir_out <= 2'b01;
					enytank_ypos <= enytank_ypos + 1;
					end
				else 
					enytank_ypos <= enytank_ypos;
				end
			else if (h_dis != 0 && v_dis == 0)
				begin
				btn_sht <= 1'b1;
				if(rel_dir[0] == 1 && enytank_xpos > 0) //left
					begin
					tank_dir_out <= 2'b10;
					enytank_xpos <= enytank_xpos - 1;
					end
				else if(rel_dir[0] == 0 && enytank_xpos < 16) //right
					begin
					tank_dir_out <= 2'b11;
					enytank_xpos <= enytank_xpos + 1;
					end
				else
					enytank_xpos <= enytank_xpos;
				end
			else
				begin
				btn_sht <= 1'b0;
				if (h_dis < v_dis)
					begin
					if(rel_dir[0] ==  1 && enytank_xpos > 0) //left
						begin
						tank_dir_out <= 2'b10;
						enytank_xpos <= enytank_xpos - 1;
						end
					else if (rel_dir[0] ==  0 && enytank_xpos < 16)	//right
						begin
						tank_dir_out <= 2'b11;
						enytank_xpos <= enytank_xpos + 1;
						end
					else
						enytank_xpos <= enytank_xpos;
					end
				else
					begin
					if(rel_dir[1] == 0 && enytank_ypos > 0) //up
						begin
						tank_dir_out <= 2'b00;
						enytank_ypos <= enytank_ypos - 1;
						end
					else if(rel_dir[1] == 1 && enytank_ypos < 20)	//down
						begin
						tank_dir_out <= 2'b01;
						enytank_ypos <= enytank_ypos + 1;
						end
					else
						enytank_ypos <= enytank_ypos;
					end
					end
				end
			end
//	check whether the tank was hit
	if ((tank_state_reg == 1'b1) && (((enytank_xpos == mytank_xpos) && (enytank_ypos == mytank_ypos))
									||((enytank_xpos == mybul_x) && (enytank_ypos == mybul_y + 1))
									||((enytank_xpos == mybul_x) && (enytank_ypos == mybul_y - 1))
									||((enytank_xpos == mybul_x + 1) && (enytank_ypos == mybul_y))
									||((enytank_xpos == mybul_x - 1) && (enytank_ypos == mybul_y))
									||((enytank_xpos == mybul_x) && (enytank_ypos == mybul_y))
									))
	begin
		tank_state_reg <= 1'b0;
		tank_state <= 1'b0;		
	end
end

//---------------------------------------------------
//shoot if horizontal distance = 0 or vertical distance = 0
always@(posedge clk)
begin
	if (enybul_state_feedback == 1'b0)
	begin
		if ((tank_state_reg == 1'b1) && (btn_sht == 1'b1))
			enybul_state <= 1'b1;
		else
			enybul_state <= 1'b0;	
	end
	else
	begin
		enybul_state <= 1'b1;
	end
end

endmodule