/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				clock.v
Date				:				2018-05-08
Description			:				Clock signal divider 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180508		ctlvie		1.0			Initial coding completed(unverified)
180510		ctlvie		1.0			Add the 2Hz clock for enemy tanks
180522		ctlvie		1.2			Add "Faster" function
180525		ctlvie		2.0			Final Version
========================================================*/
module clock
(
	input				clk,
	input				item_faster,
	output 	reg			clk_4Hz,
	output 	reg			clk_8Hz,
	output	reg			clk_2Hz
);

reg	[25:0]	cnt_2Hz;
reg [25:0]	cnt_4Hz;
reg	[27:0]	cnt_8Hz;

reg	[25:0]	ending_4Hz;

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

always@(posedge clk)
begin
	if(item_faster == 1'b1 )
		ending_4Hz <= 6250000;
	else
		ending_4Hz <= 12500000;
end

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