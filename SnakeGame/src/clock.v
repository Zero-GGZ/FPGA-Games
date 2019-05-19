/*
 * @Discription: clock module for whole design
 * @Author: Qin Boyu
 * @Date: 2019-05-14 19:22:50
 * @LastEditTime: 2019-05-19 10:21:16
 */

module clock
(
	input				clk,
	output 	reg			clk_4Hz,
	output 	reg			clk_8Hz,
	output	reg			clk_2Hz
);

reg	[25:0]	cnt_2Hz;
reg [25:0]	cnt_4Hz;
reg	[27:0]	cnt_8Hz;

reg	[25:0]	ending_4Hz = 12500000;

initial cnt_4Hz <= 26'b0;
initial cnt_8Hz <= 26'b0;
initial	cnt_2Hz <= 27'b0;

always@(posedge clk)
begin
	cnt_2Hz <= cnt_2Hz + 28'b1;
	if (cnt_2Hz >= 25000000)		
	begin
		clk_2Hz <= 1;
		
	end
	else clk_2Hz <= 0;
	if	(cnt_2Hz >= 50000000)
	begin	
		cnt_2Hz <= 28'b0;
	end
end

/*
always@(posedge clk)
begin
	if(reward_faster == 1'b1 )
		ending_4Hz <= 6250000;
	else
		ending_4Hz <= 12500000;
end
*/

always@(posedge clk)
begin
	cnt_4Hz <= cnt_4Hz + 26'b1;
	if (cnt_4Hz >= ending_4Hz)		
	begin
		clk_4Hz <= 1;
		
	end
	else clk_4Hz <= 0;
	if	(cnt_4Hz >= (ending_4Hz * 2) )
	begin	
		cnt_4Hz <= 26'b0;
	end
end

always@(posedge clk)
begin
	cnt_8Hz <= cnt_8Hz + 26'b1;
	if (cnt_8Hz >= 6250000)
	begin
		clk_8Hz <= 1;
	end
	else
		clk_8Hz <= 0;
	if (cnt_8Hz >= 12500000)
	begin
		clk_8Hz <= 0;
		cnt_8Hz <= 26'b0;
	end
end


endmodule