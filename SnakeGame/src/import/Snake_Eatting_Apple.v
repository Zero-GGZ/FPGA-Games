//ƻ����������ģ��
module Snake_Eatting_Apple
(
	input clk,
	input rst,
	
	input [5:0]head_x,
	input [5:0]head_y,
	
	output reg [5:0]apple_x,
	output reg [4:0]apple_y,

	output reg add_cube
);

	reg [31:0]clk_cnt;
	reg [10:0]random_num;
	
	always@(posedge clk)
		random_num <= random_num + 999;  //�üӷ����������  
		//�������5λΪʳ��X���� ��5λΪƻ��Y����
	
	always@(posedge clk or negedge rst) begin
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
				if(apple_x == head_x && apple_y == head_y) begin
					add_cube <= 1;
					apple_x <= (random_num[10:5] > 38) ? (random_num[10:5] - 25) : (random_num[10:5] == 0) ? 1 : random_num[10:5];
					apple_y <= (random_num[4:0] > 28) ? (random_num[4:0] - 3) : (random_num[4:0] == 0) ? 1:random_num[4:0];
				end   //�ж�������Ƿ񳬳�ƵĻ���귶Χ �������ת��Ϊ�¸�ƻ����X Y����
				else
					add_cube <= 0;
			end
		end
	end
endmodule