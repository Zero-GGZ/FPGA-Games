/*
 * @Discription: 游戏控制模块 根据游戏状态产生相应控制信号 
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:21:24
 */

module game_status_control
(
	input clk,				//时钟信号输入
	input rst,				//复位信号输入
	input key1_press,		//四个控制按键信号输入
	input key2_press,
	input key3_press,
	input key4_press,
	
	output reg [1:0]game_status,	//输出四种不同的游戏状态
	input hit_wall,					//表示撞到墙壁
	input hit_body,					//表示撞到自身身体
	output reg die_flash,			//游戏结束并闪烁
	output reg restart				//输出restart(重新开始)信号
);
	//定义四种状态的值
	localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;
	
	reg[31:0]clk_cnt;
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst) begin		//收到复位信号后设置初始状态并归零
			game_status <= START;
			clk_cnt <= 0;
			die_flash <= 1;
			restart <= 0;
		end
		else begin
			case(game_status)	//处理不同的游戏状态
			//1. RESTART: RESTART状态下，输入5个时钟的restart信号，之后进入开始状态
				RESTART:begin           
					if(clk_cnt <= 5) begin
						clk_cnt <= clk_cnt + 1;
						restart <= 1;						
					end
					else begin
						game_status <= START;
						clk_cnt <= 0;
						restart <= 0;
					end
				end
			//2. START: START状态表示“等待游戏开始”，此时一旦有按键按下则游戏启动，进入PLAY状态，否则继续等待，维持在START状态
				START:begin
					if (key1_press | key2_press | key3_press | key4_press)
                        game_status <= PLAY;
					else 
					    game_status <= START;
				end
			//3. PLAY: PLAY状态下只需要检测是否有输入的“撞墙”或“身体碰撞”信号，若有，则进入DIE状态，否则维持在PLAY状态
				PLAY:begin
					if(hit_wall | hit_body)
					   game_status <= DIE;
					else
					   game_status <= PLAY;
				end	
			//4. DIE: DIE状态下先执行贪吃蛇自身的闪烁（通过die_flash信号的01切换实现）再进入RESTART状态
				DIE:begin
					if(clk_cnt <= 200_000_000) begin
						clk_cnt <= clk_cnt + 1'b1;
					   if(clk_cnt == 25_000_000)
					       die_flash <= 0;
					   else if(clk_cnt == 50_000_000)
					       die_flash <= 1'b1;
					   else if(clk_cnt == 75_000_000)
					       die_flash <= 1'b0;
					   else if(clk_cnt == 100_000_000)
					       die_flash <= 1'b1;
					   else if(clk_cnt == 125_000_000)
					       die_flash <= 1'b0;
					   else if(clk_cnt == 150_000_000)
					       die_flash <= 1'b1;
				    end                        //闪烁
					else
						begin
							die_flash <= 1;
							clk_cnt <= 0;
							game_status <= RESTART;
						end
					end
			endcase
		end
	end
endmodule