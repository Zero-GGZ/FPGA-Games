/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				mytank_app.v
Date				:				2018-05-05
Description			:				the application module of player's tank 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
180507		QiiNn		1.0			Initial coding completed (unverified) 
180509		QiiNn		1.1			Corrected the reg conflict error(unverified)
========================================================*/

`timescale 1ns/1ns

module mytank_app
(	
	input clk,
	input clk_4Hz,
	input tank_en,	//enable
	
	// input button direction (w,a,s,d)
	input bt_w,
	input bt_a,
	input bt_s,
	input bt_d,
	input bt_st, // shoot button
	
	//input the position of each bullet
	input	[4:0]	bul1_x,
	input	[4:0]	bul1_y,
	input	[4:0]	bul2_x,
	input	[4:0]	bul2_y,
	input	[4:0]	bul3_x,
	input	[4:0]	bul3_y,
	input	[4:0]	bul4_x,
	input	[4:0]	bul4_y,
	
	input 			mybul_state_feedback, //888888888888888888
	
	//relative position input and output
	input	[4:0] 	x_rel_pos_in,
	input	[4:0]	y_rel_pos_in,
	output	reg 	[4:0]	x_rel_pos_out,
	output	reg 	[4:0]	y_rel_pos_out,
	
	output	reg		  		 tank_state,
	
	output	reg	[1:0]		tank_dir_out,
	output  reg				bul_sht
		
);

//---------------------------------------------------
//check whether it was hit
always@(posedge clk)
begin
	if	( ( bul1_x == x_rel_pos_in && bul1_y == y_rel_pos_in) ||
			(bul2_x == x_rel_pos_in && bul2_y == y_rel_pos_in) ||
			(bul3_x == x_rel_pos_in && bul3_y == y_rel_pos_in) ||
			(bul4_x == x_rel_pos_in && bul4_y == y_rel_pos_in) )
			tank_state <= 1'b0;
	else	tank_state <= 1'b1;
end 

//---------------------------------------------------
//moving
always@(posedge clk_4Hz)
begin
	//move upward and direction = 00
	if(bt_w == 1'b1)
	begin
		if (y_rel_pos_in > 0 && y_rel_pos_in < 20 && tank_en == 1'b1)
		begin
			y_rel_pos_out <= y_rel_pos_out + 1'b1;
			tank_dir_out <= 2'b00;
		end
	end

	//move downward and direction = 01
	if(bt_s == 1'b1)
	begin
		if (y_rel_pos_in > 0 && y_rel_pos_in < 20 && tank_en == 1'b1)
		begin
			y_rel_pos_out <= y_rel_pos_out - 1'b1;
			tank_dir_out <= 2'b01;
		end
	end

	//move left and direction = 10
	if(bt_a ==1'b1)
	begin
		if (x_rel_pos_in > 0 && x_rel_pos_in < 16 && tank_en == 1'b1)
		begin
			x_rel_pos_out <= x_rel_pos_out +	1'b1;
			tank_dir_out <= 2'b10;
		end
	end

	//move right and direction = 11
	if(bt_d == 1'b1)
	begin
		if (x_rel_pos_in > 0 && x_rel_pos_in < 16 && tank_en == 1'b1)
		begin
			x_rel_pos_out <= x_rel_pos_out - 1'b1;
			tank_dir_out <= 2'b11;
		end
	end
end

//---------------------------------------------------
//Shoot 
always@(posedge clk)
begin
	if(bt_st == 1'b1)
	begin
		if ((tank_en == 1'b1)&&(mybul_state_feedback == 1'b0))
		bul_sht <= 1'b1;
	end
	if (mybul_state_feedback == 1'b0)
		bul_sht <= 1'b0;
end
		
endmodule
