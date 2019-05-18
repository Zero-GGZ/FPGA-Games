/*
 * @Discription:  ƻ������ģ�飬���߳Ե�ƻ�����������һ���µ�ƻ������
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-18 10:25:14
 */


module apple_generator
(
	input clk,			//ʱ���ź�����
	input rst,			//��λ�ź�����
	
	input [5:0]head_x,	//������ͷ��x�����y����
	input [5:0]head_y,
	
	output reg [5:0]apple_x, //���ƻ����x�����y����(0~38, 0~28)
	output reg [4:0]apple_y,

	output reg add_cube	//������������ź�
);

	reg [31:0]clk_cnt;
	reg [10:0]random_num;  //������Ĵ���
	
	always@(posedge clk)
		//�üӷ��������������6λΪƻ����x���꣬��5λΪy���꣩
		random_num <= random_num + 999; 
	
	always@(posedge clk or negedge rst) begin
		//��λ��ƻ����Ĭ������Ϊ(24,10)
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
				//ÿ250000��clk����һ�Σ������ͷ��ƻ��������ͬ�����߳Ե���ƻ��������һ(add_cube��λ)���������µ�ƻ�����꣬����ʱ�ж�������Ƿ񳬳�ƵĻ���귶Χ
				if(apple_x == head_x && apple_y == head_y) 
				begin
					add_cube <= 1;
					apple_x <= (random_num[10:5] > 38) ? (random_num[10:5] - 25) : (random_num[10:5] == 0) ? 1 : random_num[10:5];
					apple_y <= (random_num[4:0] > 28) ? (random_num[4:0] - 3) : (random_num[4:0] == 0) ? 1:random_num[4:0];
				end
				else
					add_cube <= 0;
			end
		end
	end
endmodule