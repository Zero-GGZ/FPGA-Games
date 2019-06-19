/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				enemytank_control.v
Date				:				2018-05-05
Description			:				the controller module of enemy's tank 
									(Similar to the application layer)

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		ctlvie		0.5			Module interface definition
180508		ctlvie		1.0			Initial coding complete (unverified)
180509		ctlvie		1.1			Corrected the reg conflict error(unverified)
180510		ctlvie		1.5			Full Version!
180510		ctlvie		1.6			Add the score counter function
180512		ctlvie		1.6			1. Change the coordinate
									2. Add enable interface (need to link it!)
180521		ctlvie		1.8			Fixed the "Cannot hit" bug
180523		ctlvie		1.9			Add freezing fuction
180525		ctlvie		2.0			Final Version
========================================================*/

`timescale 1ns/1ns

module enemytank_control
(
	input 			clk,
	input			enable,			//global enable signal, determined by game mode
	input 			clk_4Hz,
	input 			clk_8Hz,
	input 			tank_en,		//resurrection enable signal
	
	input	[1:0]	tank_num,	
	
	input	[4:0] 	myshell_x,
	input 	[4:0]	myshell_y,
	
	input 	[4:0]	mytank_xpos,
	input	[4:0]	mytank_ypos,
	input	[1:0]	mytank_dir,
	
	input 			enemyshell_state_feedback,
	
	input			item_frozen,
	input			item_laser,
	output	reg			kill,
	output  reg			enemyshell_state,
	output	reg			tank_state,		//坦克状态信号，送生成模块，经tank_en复活
	output	reg	[4:0] 	enemytank_xpos,
	output	reg	[4:0]	enemytank_ypos,
	output 	reg	[6:0]	score,
	output	reg	[1:0]	tank_dir_out	
);


initial tank_state <= 1'b0;
reg 	btn_sht;

reg		shell_flying;

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
	score <= 1'b0;
end

/*
always@(posedge enable)
begin
	eql <= 1'b0;
	rel_dir <= 	3'b0;
	h_dis 	<=	5'b0;
	v_dis 	<=	5'b0;
	score <= 1'b0;
end
*/
always@(posedge clk)
begin
	if (enable)
	begin
	if (enemytank_xpos == mytank_xpos && enemytank_ypos == mytank_ypos)
	begin
		eql <= 1'b1;
		h_dis <= 1'b0;
		v_dis <= 1'b0;
	end
	else 
	begin
		eql <= 1'b0;
		rel_dir[2] <= 1'b0;
		if  (enemytank_xpos < mytank_xpos)
			begin
			rel_dir[0] <= 1'b0;
			h_dis <= mytank_xpos - enemytank_xpos;
			end
		else if	(enemytank_xpos > mytank_xpos)
			begin
			h_dis <= enemytank_xpos - mytank_xpos;
			rel_dir[0] <= 1'b1;
			end
		else 
			begin
			h_dis <= 1'b0;
			if (enemytank_ypos > mytank_ypos)
				begin
				rel_dir <= 3'b110;
				end
			else
				begin
				rel_dir <= 3'b111;
				end
			end
			
		if	(enemytank_ypos > mytank_ypos)
			begin
			v_dis <= enemytank_ypos - mytank_ypos;
			rel_dir[1]	<= 1'b0;
			end
		else if (enemytank_ypos < mytank_ypos)
			begin
			v_dis <= mytank_ypos - enemytank_ypos;
			rel_dir[1]	<= 1'b1;
			end
		else
			begin
			v_dis <= 1'b0;
			if (enemytank_xpos > mytank_xpos)
				rel_dir <= 3'b101;
			else
				rel_dir <= 3'b100;
			end
	end
	end
end

reg		flag;
reg		restart; 	
reg		restart_fb;
reg		laser_flag;

initial flag 		<= 0;
initial restart 	<= 1;
initial restart_fb 	<= 0;
reg			kill_flag;
reg	[63:0]	cnt_kill ;
initial		cnt_kill <= 0;
initial		kill_flag <= 0;

always@(posedge clk)
begin
if(enable)
begin
	if (tank_state == 1'b0  && tank_en == 1'b1)
	begin
		restart <= 1;
		if (restart_fb == 1)
		begin
			tank_state <= 1'b1;
			flag <= 0;
			restart <= 0;
		end
		else
			tank_state <= 1'b0;
	end
	if ((tank_state == 1'b1) && (((enemytank_xpos == mytank_xpos) && (enemytank_ypos == mytank_ypos))
									||((enemytank_xpos == myshell_x) && (enemytank_ypos == myshell_y ))) 
								 && flag == 0)
	begin
		tank_state <= 1'b0;	
		if	((enemytank_xpos == 0 && enemytank_ypos == 0) 
				||(enemytank_xpos == 24 && enemytank_ypos == 0) 
				||(enemytank_xpos == 0 && enemytank_ypos == 12) 
				||(enemytank_xpos == 24 && enemytank_ypos == 12) )
			score <= score;
		else
			begin
			score <= score + 1'b1;
			kill_flag <= 1;
			end
		flag <= 1;
	end
	
	if(kill_flag)
		begin
		kill <= 1;
		cnt_kill <= cnt_kill + 1;
		if(cnt_kill >= 5000000)
		kill_flag <= 0;
		end
	else
		begin
		cnt_kill <= 0;
		kill <= 0;
		end
	
	
	if(tank_state == 1 && item_laser == 1 )
	begin
		if(eql)
			tank_state <= 1'b0;
		else
			begin
			if(h_dis == 0 && v_dis != 0 && laser_flag ==0)
				begin
				if(mytank_ypos <= enemytank_ypos && mytank_dir == 2'b01)
					begin
					tank_state <= 1'b0;
					if	((enemytank_xpos == 0 && enemytank_ypos == 0) 
						||(enemytank_xpos == 24 && enemytank_ypos == 0) 
						||(enemytank_xpos == 0 && enemytank_ypos == 12) 
						||(enemytank_xpos == 24 && enemytank_ypos == 12) )
						score <= score;
					else
						begin
						score <= score + 1'b1;
						kill_flag <= 1;
						end
					laser_flag <= 1;
					end
				else if(mytank_ypos >= enemytank_ypos && mytank_dir == 2'b00)
					begin
					tank_state <= 1'b0;
					if	((enemytank_xpos == 0 && enemytank_ypos == 0) 
						||(enemytank_xpos == 24 && enemytank_ypos == 0) 
						||(enemytank_xpos == 0 && enemytank_ypos == 12) 
						||(enemytank_xpos == 24 && enemytank_ypos == 12) )
						score <= score;
					else
						begin
						score <= score + 1'b1;
						kill_flag <= 1;
						end
					laser_flag <= 1;
					end
				else
					begin
					tank_state <= 1'b1;
					laser_flag <= 0;
					end
				end
			else if(h_dis != 0 && v_dis == 0)
				begin
				if(mytank_xpos <= enemytank_xpos && mytank_dir == 2'b11)
					begin
					tank_state <= 1'b0;
					if	((enemytank_xpos == 0 && enemytank_ypos == 0) 
						||(enemytank_xpos == 24 && enemytank_ypos == 0) 
						||(enemytank_xpos == 0 && enemytank_ypos == 12) 
						||(enemytank_xpos == 24 && enemytank_ypos == 12) )
						score <= score;
					else
						begin
						score <= score + 1'b1;
						kill_flag <= 1;
						end
					laser_flag <= 1;
					end
				else if(mytank_xpos >= enemytank_xpos && mytank_dir == 2'b10)
					begin
					tank_state <= 1'b0;
					if	((enemytank_xpos == 0 && enemytank_ypos == 0) 
						||(enemytank_xpos == 24 && enemytank_ypos == 0) 
						||(enemytank_xpos == 0 && enemytank_ypos == 12) 
						||(enemytank_xpos == 24 && enemytank_ypos == 12) )
						score <= score;
					else
						begin
						score <= score + 1'b1;
						kill_flag <= 1;
						end
					laser_flag <= 1;
					end
				else
					begin
					tank_state <= 1'b1;
					laser_flag <= 0;
					end
				end
			else
				begin
				tank_state <= 1'b1;
				laser_flag <= 0;
				end
			end
	end	

	
end
else
	score <= 0;
end






//---------------------------------------------------
//generate and move to my tank by steps and check whether it was hit
always@(posedge clk_4Hz)
begin
if(enable)
begin
	//enemy tank's generation and initialization
	if (restart == 1)
	begin
		if(tank_num == 2'b00)
		begin
			enemytank_xpos <= 0;
			enemytank_ypos <= 0;
		end
		else if (tank_num == 2'b01)
		begin
			enemytank_xpos <= 24;
			enemytank_ypos <= 0;
		end
		else if (tank_num == 2'b10)
		begin
			enemytank_xpos <= 0;
			enemytank_ypos <= 12;
		end
		else if (tank_num == 2'b11)
		begin
			enemytank_xpos <= 24;
			enemytank_ypos <= 12;
		end
		restart_fb <= 1;
	end
	else
		restart_fb <= 0;
	//move
	if (tank_state == 1 && item_frozen == 0 )
	begin
		if (eql)
			tank_dir_out <= tank_dir_out;
		else
			begin
			if ( h_dis == 0 && v_dis != 0)
				begin
				btn_sht <= 1'b1;
				if(rel_dir[0] == 0 && enemytank_ypos > 0)	//up
					begin
					tank_dir_out <= 2'b00;
					enemytank_ypos <= enemytank_ypos - 1;
					end
				else if (rel_dir[0] == 1 && enemytank_ypos < 20) //down
					begin
					tank_dir_out <= 2'b01;
					enemytank_ypos <= enemytank_ypos + 1;
					end
				else 
					enemytank_ypos <= enemytank_ypos;
				end
			else if (h_dis != 0 && v_dis == 0)
				begin
				btn_sht <= 1'b1;
				if(rel_dir[0] == 1 && enemytank_xpos > 0) //left
					begin
					tank_dir_out <= 2'b10;
					enemytank_xpos <= enemytank_xpos - 1;
					end
				else if(rel_dir[0] == 0 && enemytank_xpos < 16) //right
					begin
					tank_dir_out <= 2'b11;
					enemytank_xpos <= enemytank_xpos + 1;
					end
				else
					enemytank_xpos <= enemytank_xpos;
				end
			else
				begin
				btn_sht <= 1'b0;
				if (h_dis < v_dis)
					begin
					if(rel_dir[0] ==  1 && enemytank_xpos > 0) //left
						begin
						tank_dir_out <= 2'b10;
						enemytank_xpos <= enemytank_xpos - 1;
						end
					else if (rel_dir[0] ==  0 && enemytank_xpos < 16)	//right
						begin
						tank_dir_out <= 2'b11;
						enemytank_xpos <= enemytank_xpos + 1;
						end
					else
						enemytank_xpos <= enemytank_xpos;
					end
				else
					begin
					if(rel_dir[1] == 0 && enemytank_ypos > 0) //up
						begin
						tank_dir_out <= 2'b00;
						enemytank_ypos <= enemytank_ypos - 1;
						end
					else if(rel_dir[1] == 1 && enemytank_ypos < 20)	//down
						begin
						tank_dir_out <= 2'b01;
						enemytank_ypos <= enemytank_ypos + 1;
						end
					else
						enemytank_ypos <= enemytank_ypos;
					end
					end
				end
			end
end

end

//---------------------------------------------------
//shoot if horizontal distance = 0 or vertical distance = 0
always@(posedge clk)
begin
if(enable)
begin
	if (enemyshell_state_feedback == 1'b0)
	begin
		if ((tank_state == 1'b1) && (btn_sht == 1'b1))
			enemyshell_state <= 1'b1;
		else
			enemyshell_state <= 1'b0;	
	end
	else
	begin
		enemyshell_state <= 1'b1;
	end
end
end

endmodule