/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				bullet.v
Date				:				2018-05-05
Description			:				the bullet module 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
180508		QiiNn		1.0			Initial coding complete (unverified)
180509		QiiNn		1.1			Corrected the reg conflict error(unverified)
180510		QiiNn		1.5			Full Version!
180512		QiiNn		1.6			1. Change the coordinate
									2. Add enable interface
========================================================*/

`timescale 1ns/1ns

module bullet
(
	input				clk,		
	input 				clk_8Hz,
	input				enable,
	
	input	[1:0]		bul_dir,	//the direction of bullet
	input				bul_state,	//the state of bullet
		
	//input and output the position of bullet
	input		[4:0]	tank_xpos,
	input		[4:0]	tank_ypos,
	input		[4:0]	x_bul_pos_in,	
	input		[4:0]	y_bul_pos_in,
	output	reg	[4:0]	x_bul_pos_out,
	output	reg	[4:0]	y_bul_pos_out,
	
	//input VGA scan coordinate
	input	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	
	//output the VGA data
	output	reg	[11:0]	VGA_data,
	
	//output the bullet state to each module
	output	reg			bul_state_feedback     
);

//---------------------------------------------------
//sample the tank shooting
reg		[1:0]	bul_dir_reg;
reg		[4:0]	x_bul_pos_init;
reg		[4:0]	y_bul_pos_init;

always@(posedge bul_state)
begin
if(enable)
begin
	bul_dir_reg <= bul_dir;
	x_bul_pos_init <= tank_xpos;
	y_bul_pos_init <= tank_ypos;
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
	if(bul_state == 1'b1)
	begin
		if(sample_flag == 1'b0)
		begin
			x_bul_pos_out <= tank_xpos;//x_bul_pos_init;??????????????????????????????????????????????????
			y_bul_pos_out <= tank_ypos;//y_bul_pos_init;
			sample_flag <= 1'b1;
		end
		if(sample_flag == 1'b1)
		begin
			//boundary detection
			if((x_bul_pos_out == 5'b11111)||(x_bul_pos_out >= 24)||(y_bul_pos_out == 5'b11111)||(y_bul_pos_out >= 12))
			begin
				bul_state_feedback <= 1'b0;	//output 0 if reach the boundaries
				sample_flag <= 1'b0;
			end
			else
			begin
			if(bul_dir_reg == 2'b00)
				begin
				bul_state_feedback <= 1'b1;	
				y_bul_pos_out <= y_bul_pos_out - 1'b1;
				x_bul_pos_out <= x_bul_pos_out;
				end
			if(bul_dir_reg == 2'b01)
				begin
				bul_state_feedback <= 1'b1;
				y_bul_pos_out <= y_bul_pos_out + 1'b1;
				x_bul_pos_out <= x_bul_pos_out;
				end
			if(bul_dir_reg == 2'b10)
				begin
				bul_state_feedback <= 1'b1;
				x_bul_pos_out <= x_bul_pos_out - 1'b1;
				y_bul_pos_out <= y_bul_pos_out;
				end
			if(bul_dir_reg == 2'b11)
				begin
				bul_state_feedback <= 1'b1;
				x_bul_pos_out <= x_bul_pos_out + 1'b1;
				y_bul_pos_out <= y_bul_pos_out;
				end
			end
		end
	end
	else
	begin
		x_bul_pos_out <= 5'b11111;
		y_bul_pos_out <= 5'b11111;
	end
end
end


//---------------------------------------------------
//VGA display
always@(posedge clk)
begin
if(enable)
begin
	if(bul_state == 1'b1)
	begin
		if((VGA_xpos > x_bul_pos_out * 20 + 80 - 3 )
			&&(VGA_xpos < x_bul_pos_out * 20 + 80 + 3 )
			&&(VGA_ypos > y_bul_pos_out * 20 + 80 - 3 )
			&&(VGA_ypos < y_bul_pos_out * 20 + 80 + 3 ))
			VGA_data <= 12'hFFF;
		else
			VGA_data <= 12'h000;
	end
	else
		VGA_data <= 12'h000;
end
end



endmodule