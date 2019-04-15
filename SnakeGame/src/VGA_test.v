

`timescale 1ns/1ns
module VGA_test
(
	input			clk_vga,			//VGA_clock
	
	//lcd interface
	output			lcd_dclk,		//lcd pixel clock			
	output			lcd_hs,			//lcd horizontal sync 
	output			lcd_vs,			//lcd vertical sync
    output			lcd_de,			//lcd data enable
	output	[3:0]	vgaRed,		//lcd red data
	output	[3:0]	vgaGreen,		//lcd green data
	output	[3:0]	vgaBlue		//lcd blue data
);


//-------------------------------------
//LCD driver timing
wire	[10:0]	lcd_xpos;		//lcd horizontal coordinate
wire	[10:0]	lcd_ypos;		//lcd vertical coordinate
wire	[23:0]	lcd_data;		//lcd data
wire    [11:0]  reduced_data;

assign reduced_data = {lcd_data[23:20],lcd_data[15:12],lcd_data[7:4]};

VGA_driver u_VGA_driver
(
//global clock
    .clk            (clk),
    .rst_n          (1'd1),

//vga interface
    .VGA_en         (),
    .Hsync          (lcd_hs),
    .Vsync          (lcd_vs),
    .vgaRed         (vgaRed),
    .vgaBlue        (vgaBlue),
    .vgaGreen       (vgaGreen),

//user interface
    .VGA_request    (),
    .VGA_xpos       (lcd_xpos),
    .VGA_ypos       (lcd_ypos),
    .VGA_data       (reduced_data)
);

//-------------------------------------
//lcd data simulation
VGA_test_color_output	u_VGA_test_color_output
(
	//global clock
	.clk			(clk_vga),		
	.rst_n			(1'd1), 
	
	.lcd_xpos		(lcd_xpos),	
	.lcd_ypos		(lcd_ypos),
	.lcd_data		(lcd_data)
);


endmodule
