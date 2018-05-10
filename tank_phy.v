/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				tank_phy.v
Date				:				2018-05-05
Description			:				convert the x/y relative coordinate to VGA data 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180505		QiiNn		0.5			Module interface definition
180507		QiiNn		1.0			Initial coding completed (unverified)
180508		QiiNn		1.1			Corrected the reg conflict error(unverified)
180509		QiiNn		1.2			 
========================================================*/
`timescale 1ns/1ns

//----------------------------------------------------------
//Define the colour parameter RGB 4|4|4
`define	RED			12'hF00
`define	GREEN		12'h0F0
`define	BLUE		12'h00F
`define	WHITE		12'hFFF
`define	BLACK		12'h000
`define	YELLOW		12'hFF0
`define	CYAN		12'hF0F
`define	ROYAL		12'h0FF

module tank_phy
(
	input			clk,
	//input the relative position of tank
	input	[4:0]	x_rel_pos,
	input	[4:0]	y_rel_pos,
	input	[10:0]	VGA_xpos,
	input	[10:0]	VGA_ypos,
	
	input			tank_state,	//the state of tank
	input			tank_ide,	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	input	[1:0]	tank_dir,	//the direction of tank
	
	//output the VGA data
	output	reg	[11:0]	VGA_data,
	output 	reg		VGA_en
);


  always@(posedge clk)
  begin
  // direction = upward 
    if (tank_state == 1'b1 && tank_dir == 2'b00)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 3)&&(VGA_xpos < x_rel_pos * 20 + 160 + 3))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos < y_rel_pos * 20 + 40)) ||
      ((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos *20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40)&&(VGA_ypos < y_rel_pos * 20 + 40 + 7))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else
	  begin
	  VGA_data <= 12'h000;
	  VGA_en <= 1'b0;
	  end
	end
  // direction = downward
    if (tank_state == 1'b1 && tank_dir == 2'b01)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos * 20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos < y_rel_pos * 20 + 40)) ||
          ((VGA_xpos > x_rel_pos * 20 + 160 - 3)&&(VGA_xpos < x_rel_pos *20 + 160 + 3))&&((VGA_ypos > y_rel_pos * 20 + 40)&&(VGA_ypos < y_rel_pos * 20 + 40 + 7))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else
	  begin
	  VGA_data <= 12'h000;
	  VGA_en <= 1'b0;
	  end
    end 
  //direction = left
    if (tank_state == 1'b1 && tank_dir == 2'b10)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos * 20 + 160 ))&&((VGA_ypos > y_rel_pos * 20 + 40 - 3)&&(VGA_ypos < y_rel_pos * 20 + 40 + 3)) ||
          ((VGA_xpos > x_rel_pos * 20 + 160 )&&(VGA_xpos < x_rel_pos *20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos < y_rel_pos * 20 + 40 + 7))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else
	  begin
	  VGA_data <= 12'h000;
	  VGA_en <= 1'b0;
	  end
    end 
  //direction = right
    if (tank_state == 1'b1 && tank_dir == 2'b11)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos * 20 + 160 ))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos < y_rel_pos * 20 + 40 + 7)) ||
          ((VGA_xpos > x_rel_pos * 20 + 160 )&&(VGA_xpos < x_rel_pos *20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40 - 3)&&(VGA_ypos < y_rel_pos * 20 + 40 + 3))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else
	  begin
	  VGA_data <= 12'h000;
	  VGA_en <= 1'b0;
	  end
    end
  end
  
endmodule

