/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				showtank_control.v
Date				:				2018-05-13
Description			:				the function of show tank

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180515		ctlvie		1.0			Initial version
180525		ctlvie		2.0			Final Version
========================================================*/

`timescale 1ns/1ns

module showtank_control
(	
	input 			clk,
	input 			clk_4Hz,
	input 			enable,
	input	[4:0]	start_x,
	input	[4:0]	start_y,
	input	[1:0]	start_dir,
	input			shell_state_feedback,
	output	reg 	[4:0]	x_rel_pos_out,
	output	reg 	[4:0]	y_rel_pos_out,		
	output	reg	[1:0]		tank_dir_out,
	output  reg				shell_sht
);

reg 	tank_state_reg;
reg		[3:0]	cnt;
//---------------------------------------------------
//initial coordinate generation

reg sample;
initial sample <= 1'b0;
//---------------------------------------------------
//moving
always@(posedge clk_4Hz)
begin
if(enable)
begin
	if(!sample)
		begin
		x_rel_pos_out <= start_x;
		y_rel_pos_out <= start_y;
		sample <= 1'b1;
		end
	//move upward and direction = 00
	if(start_dir == 2'b00)
	begin
		y_rel_pos_out <= y_rel_pos_out - 1'b1;
		tank_dir_out <= 2'b00;
		if (y_rel_pos_out == 0)
			y_rel_pos_out <= 12; 
	end

	//move downward and direction = 01
	if(start_dir == 2'b01)
	begin
		y_rel_pos_out <= y_rel_pos_out + 1'b1;
		tank_dir_out <= 2'b01;
		if (y_rel_pos_out == 12)
			y_rel_pos_out <= 0; 
	end

	//move left and direction = 10
	if(start_dir == 2'b10)
	begin
		x_rel_pos_out <= x_rel_pos_out - 1'b1;
		tank_dir_out <= 2'b10;
		if (x_rel_pos_out == 0)
			x_rel_pos_out <= 24; 
	end

	//move right and direction = 11
	if(start_dir == 2'b11)
	begin
		x_rel_pos_out <= x_rel_pos_out + 1'b1;
		tank_dir_out <= 2'b11;
		if (x_rel_pos_out == 24)
			x_rel_pos_out <= 0; 
	end
end
end

endmodule