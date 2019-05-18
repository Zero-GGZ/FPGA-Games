/*
 * @Discription:  游戏界面显示模块
 * @Author: Qin Boyu
 * @Date: 2019-05-13 23:30:57
 * @LastEditTime: 2019-05-13 23:45:45
 */
module interface_display
(
    input           clk,
    input   [9:0]   x_pos,
    input   [9:0]   y_pos,
    input   [5:0]   apple_x,
    input   [4:0]   apple_y,
    input   [1:0]   snake,
    output reg [11:0]   VGA_data_interface
);

    localparam NONE = 2'b00;
    localparam HEAD = 2'b01;
    localparam BODY = 2'b10;
    localparam WALL = 2'b11;
    localparam HEAD_COLOR = 12'b0000_1111_0000;
    localparam BODY_COLOR = 12'b0000_1111_1111;

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
            VGA_data_interface = 3'b101;
        else if(snake == HEAD|snake == BODY) begin   //根据当前扫描到的点是哪一部分输出相应颜色
            case({lox,loy})
                8'b0000_0000:VGA_data_interface = 12'b0000_0000_0000;
                default:VGA_data_interface = (snake == HEAD) ?  HEAD_COLOR : BODY_COLOR;
            endcase
        end
    end










endmodule