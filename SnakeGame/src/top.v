/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				top.v
Date				:				2019-04-14
Description			:				the top module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180506		ctlvie		0.1         VGA test
========================================================*/

`timescale 1ns/1ns

module top
(	
	input 					clk,
	input 					bt_w,
	input 					bt_a,
	input 					bt_s,
	input 					bt_d,
	input 					bt_st,
	input		[15:0]		sw,	
	output					Hsync,
	output					Vsync,
	output		[3:0]		vgaRed,
	output		[3:0]		vgaBlue,
	output		[3:0]		vgaGreen,
	output		[3:0]		an,
	output		[6:0]		seg,
	output					dp,
	output		[15:0]		led
);

wire clk_vga;
clk_wiz_0 u_system_clock
  (
  // Clock out ports  
  .clk_out1(),          //100MHz
  .clk_out2(clk_vga),  //25MHz for VGA
  // Status and control signals               
  .locked(),
 // Clock in ports
  .clk_in1(clk)
  );


VGA_test u_VGA_test
(
	.clk_vga        (clk_vga),			//VGA_clock
	
	//lcd interface
	.lcd_dclk       (),		//lcd pixel clock			
	.lcd_hs         (Hsync),			//lcd horizontal sync 
	.lcd_vs         (Vsync),			//lcd vertical sync
    .lcd_de         (),			//lcd data enable
    .vgaRed         (vgaRed),
    .vgaBlue        (vgaBlue),
    .vgaGreen       (vgaGreen)
);

endmodule