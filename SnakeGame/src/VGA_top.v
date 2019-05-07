`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/01/23 23:55:53
// Design Name: 
// Module Name: VGA_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA_top(
	input clk,
    input rst,

    input [1:0]snake,
    input [5:0]apple_x,
    input [4:0]apple_y,
    output [9:0]x_pos,
    output [9:0]y_pos,    
    output hsync,
    output vsync,
    output [11:0] color_out
    );
    
    wire clk_n;
    
    clk_unit myclk(
        .clk(clk),
        .rst(rst),
        .clk_n(clk_n)
    );


    VGA_Control VGA
(
		.clk(clk_n),
		.rst(rst),
		.hsync(hsync),
		.vsync(vsync),
		.snake(snake),
        .color_out(color_out),
		.x_pos(x_pos),
		.y_pos(y_pos),
		.apple_x(apple_x),
		.apple_y(apple_y)
	);
endmodule
