/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				shell.v
Date				:				2018-05-05
Description			:				the shell controller and display module 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		ctlvie		0.5			Module interface definition
180508		ctlvie		1.0			Initial coding complete (unverified)
180509		ctlvie		1.1			Corrected the reg conflict error(unverified)
180510		ctlvie		1.5			Full Version!
180512		ctlvie		1.6			1. Change the coordinate
									2. Add enable interface
180525		ctlvie		2.0			Final Version
========================================================*/

`timescale 1ns/1ns

module shell
(
	input				clk,		
	input 				clk_8Hz,
	input				enable,
	
	input				shell_ide,
	input	[1:0]		shell_dir,	//the direction of shell
	input				shell_state,	//the state of shell
		
	//input and output the position of shell
	input		[4:0]	tank_xpos,
	input		[4:0]	tank_ypos,
	output	reg	[4:0]	x_shell_pos_out,
	output	reg	[4:0]	y_shell_pos_out,
	
	//input VGA scan coordinate
	input	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	
	//output the VGA data
	output	reg	[11:0]	VGA_data,
	
	//output the shell state to each module
	output	reg			shell_state_feedback     
);

//---------------------------------------------------
//sample the tank shooting
reg		[1:0]	shell_dir_reg;
reg		[4:0]	x_shell_pos_init;
reg		[4:0]	y_shell_pos_init;

always@(posedge shell_state)
begin
if(enable)
begin
	shell_dir_reg <= shell_dir;
	x_shell_pos_init <= tank_xpos;
	y_shell_pos_init <= tank_ypos;
end
end

//---------------------------------------------------
//move
reg		sample_flag;
initial sample_flag <= 1'b0;

always@(posedge clk_8Hz)
begin
if(enable)
begin
	if(shell_state == 1'b1)
	begin
		if(sample_flag == 1'b0)
		begin
			x_shell_pos_out <= tank_xpos;
			y_shell_pos_out <= tank_ypos;
			sample_flag <= 1'b1;
		end
		if(sample_flag == 1'b1)
		begin
			//boundary detection
			if((x_shell_pos_out == 5'b11111)||(x_shell_pos_out > 24)||(y_shell_pos_out == 5'b11111)||(y_shell_pos_out > 12))
			begin
				shell_state_feedback <= 1'b0;	//output 0 if reach the boundaries
				sample_flag <= 1'b0;
			end
			else
			begin
			if(shell_dir_reg == 2'b00)
				begin
				shell_state_feedback <= 1'b1;	
				y_shell_pos_out <= y_shell_pos_out - 1'b1;
				x_shell_pos_out <= x_shell_pos_out;
				end
			if(shell_dir_reg == 2'b01)
				begin
				shell_state_feedback <= 1'b1;
				y_shell_pos_out <= y_shell_pos_out + 1'b1;
				x_shell_pos_out <= x_shell_pos_out;
				end
			if(shell_dir_reg == 2'b10)
				begin
				shell_state_feedback <= 1'b1;
				x_shell_pos_out <= x_shell_pos_out - 1'b1;
				y_shell_pos_out <= y_shell_pos_out;
				end
			if(shell_dir_reg == 2'b11)
				begin
				shell_state_feedback <= 1'b1;
				x_shell_pos_out <= x_shell_pos_out + 1'b1;
				y_shell_pos_out <= y_shell_pos_out;
				end
			end
		end
	end
	else
	begin
		x_shell_pos_out <= 5'b11111;
		y_shell_pos_out <= 5'b11111;
	end
end
end


//---------------------------------------------------
//VGA display
always@(posedge clk)
begin
if(enable)
begin
	if(shell_state == 1'b1)
	begin
		if((VGA_xpos > x_shell_pos_out * 20 + 80 - 3 )
			&&(VGA_xpos < x_shell_pos_out * 20 + 80 + 3 )
			&&(VGA_ypos > y_shell_pos_out * 20 + 80 - 3 )
			&&(VGA_ypos < y_shell_pos_out * 20 + 80 + 3 ))
			begin
				if(shell_ide)
				VGA_data <= 12'hFFF;
				else
				VGA_data <= 12'hFF0;
			end
		else
			VGA_data <= 12'h000;
	end
	else
		VGA_data <= 12'h000;
end
end



endmodule