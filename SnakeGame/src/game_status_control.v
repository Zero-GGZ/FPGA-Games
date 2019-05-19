/*
 * @Discription: ��Ϸ����ģ�� ������Ϸ״̬������Ӧ�����ź� 
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:21:24
 */

module game_status_control
(
	input clk,				//ʱ���ź�����
	input rst,				//��λ�ź�����
	input key1_press,		//�ĸ����ư����ź�����
	input key2_press,
	input key3_press,
	input key4_press,
	
	output reg [1:0]game_status,	//������ֲ�ͬ����Ϸ״̬
	input hit_wall,					//��ʾײ��ǽ��
	input hit_body,					//��ʾײ����������
	output reg die_flash,			//��Ϸ��������˸
	output reg restart				//���restart(���¿�ʼ)�ź�
);
	//��������״̬��ֵ
	localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;
	
	reg[31:0]clk_cnt;
	
	always@(posedge clk or negedge rst)
	begin
		if(!rst) begin		//�յ���λ�źź����ó�ʼ״̬������
			game_status <= START;
			clk_cnt <= 0;
			die_flash <= 1;
			restart <= 0;
		end
		else begin
			case(game_status)	//����ͬ����Ϸ״̬
			//1. RESTART: RESTART״̬�£�����5��ʱ�ӵ�restart�źţ�֮����뿪ʼ״̬
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
			//2. START: START״̬��ʾ���ȴ���Ϸ��ʼ������ʱһ���а�����������Ϸ����������PLAY״̬����������ȴ���ά����START״̬
				START:begin
					if (key1_press | key2_press | key3_press | key4_press)
                        game_status <= PLAY;
					else 
					    game_status <= START;
				end
			//3. PLAY: PLAY״̬��ֻ��Ҫ����Ƿ�������ġ�ײǽ����������ײ���źţ����У������DIE״̬������ά����PLAY״̬
				PLAY:begin
					if(hit_wall | hit_body)
					   game_status <= DIE;
					else
					   game_status <= PLAY;
				end	
			//4. DIE: DIE״̬����ִ��̰�����������˸��ͨ��die_flash�źŵ�01�л�ʵ�֣��ٽ���RESTART״̬
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
				    end                        //��˸
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