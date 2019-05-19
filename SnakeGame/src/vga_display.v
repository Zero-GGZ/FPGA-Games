/*
 * @Discription:  VGAÏÔÊ¾Ä£¿é
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:22:25
 */

module vga_display
(
	input clk,
	input rst,
	
	input [1:0]snake,
	input [5:0]apple_x,
	input [4:0]apple_y,
	input   	[11:0]	VGA_reward,
	input [1:0] game_status,
	output reg[9:0]x_pos,
	output reg[9:0]y_pos,	
	output reg hsync,
	output reg vsync,
	output reg [11:0] color_out
);

	reg [19:0]clk_cnt;
	reg [9:0]line_cnt;
	reg clk_25M;

	wire [11:0]   VGA_data_interface;
	
	localparam NONE = 2'b00;
	localparam HEAD = 2'b01;
	localparam BODY = 2'b10;
	localparam WALL = 2'b11;
	
	localparam HEAD_COLOR = 12'b0000_1111_0000;
	localparam BODY_COLOR = 12'b0000_1111_1111;
	
	
	reg [3:0]lox;
	reg [3:0]loy;
		
	always@(posedge clk or negedge rst) begin
		if(rst) begin
			clk_cnt <= 0;
			line_cnt <= 0;
			hsync <= 1;
			vsync <= 1;
		end
		else begin
		    x_pos <= clk_cnt - 144;
			y_pos <= line_cnt - 33;	
			if(clk_cnt == 0) begin
			    hsync <= 0;
				clk_cnt <= clk_cnt + 1;
            end
			else if(clk_cnt == 96) begin
				hsync <= 1;
				clk_cnt <= clk_cnt + 1;
            end
			else if(clk_cnt == 799) begin
				clk_cnt <= 0;
				line_cnt <= line_cnt + 1;
			end
			else clk_cnt <= clk_cnt + 1;
			if(line_cnt == 0) begin
				vsync <= 0;
            end
			else if(line_cnt == 2) begin
				vsync <= 1;
			end
			else if(line_cnt == 521) begin
				line_cnt <= 0;
				vsync <= 0;
			end
			
			if(x_pos >= 0 && x_pos < 640 && y_pos >= 0 && y_pos < 480) 
			begin
				color_out[ 0] = VGA_data_interface[ 0] | VGA_reward[ 0];
				color_out[ 1] = VGA_data_interface[ 1] | VGA_reward[ 1];
				color_out[ 2] = VGA_data_interface[ 2] | VGA_reward[ 2];
				color_out[ 3] = VGA_data_interface[ 3] | VGA_reward[ 3];
				color_out[ 4] = VGA_data_interface[ 4] | VGA_reward[ 4];
				color_out[ 5] = VGA_data_interface[ 5] | VGA_reward[ 5];
				color_out[ 6] = VGA_data_interface[ 6] | VGA_reward[ 6];
				color_out[ 7] = VGA_data_interface[ 7] | VGA_reward[ 7];
				color_out[ 8] = VGA_data_interface[ 8] | VGA_reward[ 8];
				color_out[ 9] = VGA_data_interface[ 9] | VGA_reward[ 9];
				color_out[10] = VGA_data_interface[10] | VGA_reward[10];
				color_out[11] = VGA_data_interface[11] | VGA_reward[11];

			end
		    else
			    color_out = 12'b0000_0000_0000;
		end
    end

	interface_display u_interface_display
	(
		.clk	(clk),
		.x_pos	(x_pos),
		.y_pos	(y_pos),
		.apple_x(apple_x),
		.apple_y(apple_y),
		.game_status(game_status),
		.snake	(snake),
		.VGA_data_interface(VGA_data_interface)
	);


	
endmodule