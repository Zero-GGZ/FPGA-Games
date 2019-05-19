/*
 * @Discription:  VGA控制模块 整合时钟并生成坐标和相关显示
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:22:18
 */
`timescale 1ns / 1ps

module vga_control(
	input clk,
    input rst,

    input [1:0]snake,
    input [5:0]apple_x,
    input [4:0]apple_y,
    input [11:0]    VGA_reward,
    input [1:0] game_status,
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


    vga_display VGA
(
		.clk(clk_n),
		.rst(rst),
		.hsync(hsync),
		.vsync(vsync),
		.snake(snake),
        .color_out(color_out),
		.x_pos(x_pos),
		.y_pos(y_pos),
        .game_status(game_status),
		.apple_x(apple_x),
		.apple_y(apple_y),
        .VGA_reward(VGA_reward)
	);
endmodule
