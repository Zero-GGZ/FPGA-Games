/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				mytank_control.v
Date				:				2018-05-05
Description			:				the controller module of player's tank 
									(Similar to application module)

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		ctlvie		0.5			Module interface definition
180507		ctlvie		1.0			Initial coding completed (unverified) 
180509		ctlvie		1.1			Corrected the reg conflict error(unverified)
180509		ctlvie		1.2			Added initial coordinate generation
180510		ctlvie		1.3			Moving and shoot bugs fixed
180510		ctlvie		1.5			Full Version!
180512		ctlvie		1.6			1. Change the coordinate
									2. Add enable interface
180525		ctlvie		2.0			Final Version
========================================================*/

`timescale 1ns/1ns

module mytank_control
(	
	input clk,
	input clk_4Hz,
	input enable,
	input tank_en,	//enable
	
	// input button direction (w,a,s,d)
	input bt_w,
	input bt_a,
	input bt_s,
	input bt_d,
	input bt_st, // shoot button
	
	//input the position of each shelllet
	input	[4:0]	shell1_x,
	input	[4:0]	shell1_y,
	input	[4:0]	shell2_x,
	input	[4:0]	shell2_y,
	input	[4:0]	shell3_x,
	input	[4:0]	shell3_y,
	input	[4:0]	shell4_x,
	input	[4:0]	shell4_y,
	
	input 			myshell_state_feedback, 
	
	//relative position input and output
	input	[4:0] 	x_rel_pos_in,
	input	[4:0]	y_rel_pos_in,
	output	reg 	[4:0]	x_rel_pos_out,
	output	reg 	[4:0]	y_rel_pos_out,
	
	output	reg		  		 tank_state,
	
	output	reg	[1:0]		tank_dir_out,
	output  reg				shell_sht
		
);

reg 	tank_state_reg;
//---------------------------------------------------
//initial coordinate generation
initial
begin
	x_rel_pos_out <= 7;
	y_rel_pos_out <= 7;
	tank_state_reg <= 1'b1;
end

//---------------------------------------------------
//check whether it was hit
always@(posedge clk)
begin
if(enable)
begin
	if	( ( shell1_x == x_rel_pos_in && shell1_y == y_rel_pos_in) ||
			(shell2_x == x_rel_pos_in && shell2_y == y_rel_pos_in) ||
			(shell3_x == x_rel_pos_in && shell3_y == y_rel_pos_in) ||
			(shell4_x == x_rel_pos_in && shell4_y == y_rel_pos_in) )
			tank_state <= 1'b0;
	else	tank_state <= 1'b1;
end
end 

//---------------------------------------------------
//moving
always@(posedge clk_4Hz)
begin
if(enable)
begin
	//move upward and direction = 00
	if(bt_w == 1'b1)
	begin
		if (y_rel_pos_in > 0 && tank_en == 1'b1)
		begin
			y_rel_pos_out <= y_rel_pos_out - 1'b1;
			tank_dir_out <= 2'b00;
		end
	end

	//move downward and direction = 01
	if(bt_s == 1'b1)
	begin
		if ( y_rel_pos_in < 12 && tank_en == 1'b1)
		begin
			y_rel_pos_out <= y_rel_pos_out + 1'b1;
			tank_dir_out <= 2'b01;
		end
	end

	//move left and direction = 10
	if(bt_a ==1'b1)
	begin
		if (x_rel_pos_in > 0  && tank_en == 1'b1)
		begin
			x_rel_pos_out <= x_rel_pos_out - 1'b1;
			tank_dir_out <= 2'b10;
		end
	end

	//move right and direction = 11
	if(bt_d == 1'b1)
	begin
		if ( x_rel_pos_in < 24 && tank_en == 1'b1)
		begin
			x_rel_pos_out <= x_rel_pos_out + 1'b1;
			tank_dir_out <= 2'b11;
		end
	end
end
end

//---------------------------------------------------
//Shoot

always@(posedge clk)
begin
if(enable)
begin
	if (myshell_state_feedback == 1'b0)
	begin
		if ((tank_en == 1'b1)&&(bt_st == 1'b1))
			shell_sht <= 1'b1;
		else
			shell_sht <= 1'b0;	
	end
	else
	begin
		shell_sht <= 1'b1;
	end
end
end

endmodule
