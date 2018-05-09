/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				clock.v
Date				:				2018-05-08
Description			:				Clock signal divider 

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180508		QiiNn		1.0			Initial coding completed(unverified)
========================================================*/
module clock
(
	input				clk,
	output 	reg			clk_4Hz,
	output 	reg			clk_8Hz
);

reg [25:0]	cnt_4Hz;
reg	[25:0]	cnt_8Hz;

initial cnt_4Hz <= 26'b0;
initial cnt_8Hz <= 26'b0;

always@(posedge clk)
begin
	cnt_4Hz <= cnt_4Hz + 26'b1;
	if (cnt_4Hz >= 12500000)		
	begin
		clk_4Hz <= 1;
		
	end
	else clk_4Hz <= 0;
	if	(cnt_4Hz >= 25000000)
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

assign null_output = ((&cnt_4Hz)&&(&cnt_8Hz));

endmodule