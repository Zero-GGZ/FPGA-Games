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
180507		QiiNn		1.0			Initial coding completed (without add to object)
========================================================*/

`timescale 1ns/1ns

module tank_phy
(
	input			clk,
	input 			clk_4Hz,
	//input the relative position of tank
	input	[4:0]	x_rel_pos,
	input	[4:0]	y_rel_pos,
	
	input			tank_state,	//the state of tank
	input			tank_ide,	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	input	[1:0]	tank_dir,	//the direction of tank
	
	//output the VGA data
	output	reg	[11:0]	VGA_data
	output 			VGA_en
);

// direction = upward 
  always@(posedge clk)
  begin
    if (tank_state == 1'b1 && tank_dir == 2'b00)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 3)&&(VGA_xpos < x_rel_pos * 20 + 160 + 3))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos < y_rel_pos * 20 + 40)) ||
      ((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos *20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40)&&(VGA_ypos > y_rel_pos * 20 + 40 + 7))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else VGA_en <= 1'b0;
    end
  end
  
  
  // direction = downward
  always@(posedge clk)
  begin
    if (tank_state == 1'b1 && tank_dir == 2'b01)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos * 20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos < y_rel_pos * 20 + 40)) ||
          ((VGA_xpos > x_rel_pos * 20 + 160 - 3)&&(VGA_xpos < x_rel_pos *20 + 160 + 3))&&((VGA_ypos > y_rel_pos * 20 + 40)&&(VGA_ypos > y_rel_pos * 20 + 40 + 7))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else VGA_en <= 1'b0;
    end
  end
  
  
  //direction = left
  always@(posedge clk)
  begin
    if (tank_state == 1'b1 && tank_dir == 2'b10)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos * 20 + 160 ))&&((VGA_ypos > y_rel_pos * 20 + 40 - 3)&&(VGA_ypos < y_rel_pos * 20 + 40 + 3)) ||
          ((VGA_xpos > x_rel_pos * 20 + 160 )&&(VGA_xpos < x_rel_pos *20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos > y_rel_pos * 20 + 40 + 7))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else VGA_en <= 1'b0;
    end
  end
  
  
  //direction = right
  always@(posedge clk)
  begin
    if (tank_state == 1'b1 && tank_dir == 2'b11)
    begin
      if (((VGA_xpos > x_rel_pos * 20 + 160 - 7)&&(VGA_xpos < x_rel_pos * 20 + 160 ))&&((VGA_ypos > y_rel_pos * 20 + 40 - 7)&&(VGA_ypos < y_rel_pos * 20 + 40 + 7)) ||
          ((VGA_xpos > x_rel_pos * 20 + 160 )&&(VGA_xpos < x_rel_pos *20 + 160 + 7))&&((VGA_ypos > y_rel_pos * 20 + 40 - 3)&&(VGA_ypos > y_rel_pos * 20 + 40 + 3))) 
        begin
          if (tank_ide == 1'b1)  VGA_data <= `BLUE;
          else VGA_data <= `RED;
          VGA_en <= 1'b1; 
        end
      else VGA_en <= 1'b0;
    end
  end
  
endmodule
