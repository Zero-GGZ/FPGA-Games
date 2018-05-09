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
========================================================*/

`timescale 1ns/1ns

module bullet
(
	input				clk,		//888888888888888888888888888888
	input 				clk_8Hz,
	
	input	[1:0]		bul_dir,	//the direction of bullet
	input				bul_state,	//the state of bullet
		
	//input and output the position of bullet
	input		[4:0]	tank_xpos,//8888888888888888888888888888888888888888
	input		[4:0]	tank_ypos,//888888888888888888888888888888888888888
	input		[4:0]	x_bul_pos_in,	
	input		[4:0]	y_bul_pos_in,
	output	reg	[4:0]	x_bul_pos_out,
	output	reg	[4:0]	y_bul_pos_out,
	
	//input VGA scan coordinate
	input	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	
	//output the VGA data
	output	reg	[11:0]	VGA_data,
	output	reg			VGA_en,
	
	//output the bullet state to each module
	output	reg			bul_state_feedback     //8888888888888888888888888888
);

//---------------------------------------------------
//sample the tank shooting
reg		[1:0]	bul_dir_reg;
reg		[4:0]	x_bul_pos_init;
reg		[4:0]	y_bul_pos_init;

always@(posedge bul_state)
begin
	bul_dir_reg <= bul_dir;
	x_bul_pos_init <= tank_xpos;
	y_bul_pos_init <= tank_ypos;
end

//---------------------------------------------------
//move
reg		sample_flag;
initial sample_flag <= 1'b0;

always@(posedge clk_8Hz)
begin
	if(bul_state == 1'b1)
	begin
		if(sample_flag == 1'b0)
		begin
			x_bul_pos_out <= x_bul_pos_init;
			y_bul_pos_out <= y_bul_pos_init;
			sample_flag <= 1'b1;
		end
		else
		begin
			if(bul_dir_reg == 2'b00)
				y_bul_pos_out <= y_bul_pos_out - 1'b1;
			if(bul_dir_reg == 2'b01)
				y_bul_pos_out <= y_bul_pos_out + 1'b1;
			if(bul_dir_reg == 2'b10)
				x_bul_pos_out <= x_bul_pos_out - 1'b1;
			if(bul_dir_reg == 2'b11)
				x_bul_pos_out <= x_bul_pos_out + 1'b1;
		end
		//boundary detection
		if((x_bul_pos_in <= 0)||(x_bul_pos_in >= 16)||(y_bul_pos_in <= 0)||(y_bul_pos_in >= 20))
		begin
			bul_state_feedback <= 1'b0;
			sample_flag <= 1'b0;
		end
	end
end


//---------------------------------------------------
//VGA display
always@(posedge clk)
begin
	if(bul_state == 1'b1)
	begin
		if((VGA_xpos > x_bul_pos_in * 20 + 160 - 3 )
			&&(VGA_xpos > x_bul_pos_in * 20 + 160 + 3 )
			&&(VGA_ypos > y_bul_pos_in * 20 + 40 - 3 )
			&&(VGA_ypos > y_bul_pos_in * 20 + 40 + 3 ))
		begin
			VGA_en <= 1'b1;
			VGA_data <= 12'hFFF;
		end
		else
			VGA_en <= 1'b0;
	end
	else
		VGA_en <= 1'b0;
end



endmodule