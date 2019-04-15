module clk_unit(
	input clk,
	input rst,
	output clk_n
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