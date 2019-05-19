/*
 * @Discription:  clock module for game
 * @Author: Qin Boyu
 * @Date: 2019-05-07 23:17:17
 * @LastEditTime: 2019-05-19 10:20:57
 */
module clk_unit(
	input clk,
	input rst,
	output reg clk_n
	);
	
    reg clk_n;
    reg clk_tmp;
    always @(posedge clk_tmp or posedge rst) begin
       if (rst)
        clk_n <= 0;
      else
        clk_n <= ~clk_n;
    end
    
    always @(posedge clk or posedge rst) begin
        if (rst)
            clk_tmp <= 0;
        else
            clk_tmp <= ~clk_tmp;
    end
endmodule