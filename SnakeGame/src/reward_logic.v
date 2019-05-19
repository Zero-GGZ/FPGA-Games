/*
 * @Discription:  奖励机制的逻辑控制模块
 * @Author: Qin Boyu
 * @Date: 2019-05-14 00:21:08
 * @LastEditTime: 2019-05-19 10:21:47
 */

 module reward_logic
 (
     input              clk,
     input              clk_4Hz,
     input      [1:0]   game_status,
     input      [5:0]   head_x,
     input      [5:0]   head_y,
     input      [10:0]  VGA_xpos,
     input      [10:0]  VGA_ypos,
     input      [14:0]  sw,
     output reg         speedRecover,
     output reg         reward_protected,
     output reg         reward_grade,
     output reg         reward_slowly,
     output [11:0]  VGA_data_reward
 );


wire	[1:0]		reward_type;
wire	[5:0] 		random_xpos;
wire	[5:0]		random_ypos;
reg		[9:0]		cnt;
wire				set_require;
reg					set_finish;
reg                enable_reward;

wire	[11:0]		VGA_data_icon;
wire	[11:0]		VGA_data_information;
	
assign VGA_data_reward = VGA_data_icon | VGA_data_information;

reg [31:0] clk_cnt;

always@(posedge clk)
begin
    if(game_status == 2'b10)
    begin
        enable_reward <= 1'b1;
        if  ((set_require == 1'b1 &&(random_xpos == head_x)&& (random_ypos == head_y))|| sw[2] == 1 || sw[1] == 1 || sw[0] == 1) 
        begin
            if(sw[2] == 1 || sw[1] == 1 || sw[0] == 1)
            begin
                case(sw[2:0])
                3'b001 :    reward_protected <= 1'b1;
                3'b010 :	reward_slowly <= 1'b1;
                3'b100 :	reward_grade <= 1'b1;		
                default :
                begin
                    reward_protected <= 1'b0;
                    reward_grade <= 1'b0;
                    reward_slowly <= 1'b0;	
                end
                endcase
            end
            else
            begin
                case(reward_type)
                    1 : reward_protected <= 1'b1;
                    2 :	reward_slowly <= 1'b1;
                    3 :	reward_grade <= 1'b1;		
                    default :
                    begin
                        reward_protected <= 1'b0;
                        reward_grade <= 1'b0;
                        reward_slowly <= 1'b0;	
                    end
                endcase
                    set_finish <= 1'b1;
            end
        end
        else
            set_finish <= 1'b0;
        
        clk_cnt <= clk_cnt + 1;
        if(clk_cnt >= 20000000)
        begin
            clk_cnt <= 0;
                if(reward_protected)
                begin
                    cnt <= cnt + 1;
                    if (cnt >= 30)
                        begin
                        reward_protected <= 1'b0;
                        cnt <= 0;
                        end
                end
                
                if(reward_slowly)
                begin
                    cnt <= cnt + 1;
                    if (cnt >= 30)
                        begin
                        speedRecover <= 1'b1;
                        reward_slowly <= 1'b0;
                            if(cnt >= 40)
                            begin
                                speedRecover <= 1'b0;
                                cnt <= 0;
                            end
                        end
                end
                
                if(reward_grade)
                begin
                    cnt <= cnt + 5;
                    if (cnt >= 30)
                        begin
                        reward_grade <= 1'b0;
                        cnt <= 0;
                        end
                end
        end
        


    end
    else
    begin
        enable_reward <= 1'b0;
        speedRecover <= 1'b0;
        cnt <= 1'b0;
        clk_cnt <= 0;
        reward_grade <= 1'b0;
        reward_protected <= 1'b0;
        reward_slowly <= 1'b0;
    end
end

reward_random_generator		u_reward_random_generator
(
	.clk				(clk), 
	.clk_4Hz			(clk_4Hz),
	.set_finish			(set_finish),
	.set_require		(set_require),
	.enable				(enable_reward),
	.dout				(),
	.reward_type		(reward_type),	
	.random_xpos		(random_xpos),
	.random_ypos		(random_ypos)
);

reward_display		u_reward_display
(
	.clk				(clk),
	.set_require		(set_require),
	.enable_reward		(enable_reward),
	.random_xpos		(random_xpos),
	.random_ypos		(random_ypos),
	.reward_type		(reward_type),
	.VGA_xpos			(VGA_xpos),
	.VGA_ypos			(VGA_ypos),
	.VGA_data			(VGA_data_icon)
);

reward_information	u_reward_information
(
	.clk				(clk),
	.reward_cnt			(cnt),
	.enable_reward		(enable_reward),
	.reward_protected	(reward_protected),
	.reward_grade		(reward_grade),
	.reward_slowly		(reward_slowly),
	.VGA_xpos			(VGA_xpos),
	.VGA_ypos			(VGA_ypos),
	.VGA_data			(VGA_data_information)
);

endmodule
