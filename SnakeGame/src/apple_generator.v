/*
 * @Discription:  苹果生成模块，在蛇吃到苹果后随机生成一个新的苹果坐标
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:20:18
 */


module apple_generator
(
	input clk,			//时钟信号输入
	input rst,			//复位信号输入
	
	input [5:0]head_x,	//输入蛇头的x坐标和y坐标
	input [5:0]head_y,
	output reg [5:0]apple_x, //输出苹果的x坐标和y坐标(0~34, 0~24)
	output reg [4:0]apple_y,

	output reg add_cube	//输出增加身长的信号
);

	reg [31:0]clk_cnt;
	reg [10:0]random_num;  //随机数寄存器
	
	always@(posedge clk)
		//用加法产生随机数（高6位为苹果的x坐标，低5位为y坐标）
		random_num <= random_num + 999; 
	
	always@(posedge clk or negedge rst) begin
		//复位后苹果的默认坐标为(24,10)
		if(!rst) begin
			clk_cnt <= 0;
			apple_x <= 24;
			apple_y <= 10;
			add_cube <= 0;
		end

		else begin
			clk_cnt <= clk_cnt+1;
			if(clk_cnt == 250_000) begin
				clk_cnt <= 0;
				//每250000个clk后检测一次，如果蛇头和苹果坐标相同，则蛇吃到了苹果，身长加一(add_cube置位)，并生成新的苹果坐标，生成时判断随机数是否超出频幕坐标范围
				if(apple_x == head_x && apple_y == head_y) 
				begin
					add_cube <= 1;
					apple_x <= {1'b0, (random_num[9:5] == 0 ? 2 : random_num[9:5])};
					/*
					apple_x <= (random_num[10:5] > 30) ? (random_num[10:5] - 25) : (random_num[10:5] == 0) ? 1 : random_num[10:5];
					*/
					apple_y <= (random_num[4:0] > 24) ? (random_num[4:0] - 10) : (random_num[4:0] == 0) ? 1:random_num[4:0];
				end
				else
					add_cube <= 0;
			end
		end
	end
endmodule