/*
 * @Discription:  游戏界面显示模块
 * @Author: Qin Boyu
 * @Date: 2019-05-13 23:30:57
 * @LastEditTime: 2019-05-19 10:21:27
 */
module interface_display
(
    input           clk,
    input   [9:0]   x_pos,
    input   [9:0]   y_pos,
    input   [5:0]   apple_x,
    input   [4:0]   apple_y,
    input   [1:0]   snake,
    input   [1:0]   game_status,
    output reg [11:0]   VGA_data_interface
);

    localparam NONE = 2'b00;
    localparam HEAD = 2'b01;
    localparam BODY = 2'b10;
    localparam WALL = 2'b11;
    localparam HEAD_COLOR = 12'b0000_1111_0000;
    localparam BODY_COLOR = 12'b1111_1111_0000;

    localparam RESTART = 2'b00;
	localparam START = 2'b01;
	localparam PLAY = 2'b10;
	localparam DIE = 2'b11;

    wire	[2:0]		dout_pic;
    reg		[16:0]	addr_pic;

    reg [3:0] lox;
    reg [3:0] loy; 

    always@(posedge clk)
    begin
        lox = x_pos[3:0];
        loy = y_pos[3:0];						
        if(x_pos[9:4] == apple_x && y_pos[9:4] == apple_y)
            case({loy,lox})
                8'b0000_0000:VGA_data_interface = 12'b0000_0000_0000;
                default:VGA_data_interface = 12'b0000_0000_1111;
            endcase						
        else if(snake == NONE)
            VGA_data_interface = 12'b0000_0000_0000;
        else if(snake == WALL)
            VGA_data_interface = 12'b1111_0000_0000;
        else if(snake == HEAD|snake == BODY) begin   //根据当前扫描到的点是哪一部分输出相应颜色
            case({lox,loy})
                8'b0000_0000:VGA_data_interface = 12'b0000_0000_0000;
                default:VGA_data_interface = (snake == HEAD) ?  HEAD_COLOR : BODY_COLOR;
            endcase
        end

        if(game_status == START)
        begin
            if(x_pos > 130 && x_pos <= 510 && y_pos > 120 && y_pos <= 300)
            begin
                addr_pic <= (x_pos - 130)  + 380 * (y_pos - 120) ;
                VGA_data_interface <= {dout_pic[0],dout_pic[0],dout_pic[0],dout_pic[0],dout_pic[1],dout_pic[1],dout_pic[1],dout_pic[1],dout_pic[2],dout_pic[2],dout_pic[2],dout_pic[2]};
            end
            else
                VGA_data_interface <= 12'b0000_0000_0000;

            
        end
        
    end




pic_snake u_pic_snake (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_pic),  // input wire [17 : 0] addra
  .douta(dout_pic)  // output wire [7 : 0] douta
);





endmodule