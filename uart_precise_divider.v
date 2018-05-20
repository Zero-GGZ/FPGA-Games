
/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )
+-----------------------------oOOo-(_)-oOOo-----------------------------+
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo (Thereturnofbingo).
In the event of publication, the following notice is applicable:
Copyright (C) 2012-20xx CrazyBingo Corporation
The entire notice above must be reproduced on all authorized copies.
Author				:		CrazyBingo
Technology blogs 	: 		www.crazyfpga.com
Email Address 		: 		crazyfpga@vip.qq.com
Filename			:		precise_divider.v
Date				:		2013-06-25
Description			:		Precise clk divider.
Modification History	:
Date			By			Version			Change Description
=========================================================================
13/06/25		CrazyBingo	1.0				Original
14/04/11		CrazyBingo	1.1				Modification
-------------------------------------------------------------------------
|                                     Oooo								|
+-------------------------------oooO--(   )-----------------------------+
                               (   )   ) /
                                \ (   (_/
                                 \_)
-----------------------------------------------------------------------*/   
/***********************************************************************
	fc	:	Refrence clock = 100MHz = 100*10^6
	fo	:	Output	clock
	K	:	Counter Step
	fo	=	fc*[K/(2^32)]
	K	=	fo*(2^32)/fc = fo*(2^32)/(100*10^6)	= 42.94967296 * fo
***********************************************************************/

`timescale 1ns/1ns
module	uart_precise_divider
#(
	//DEVIDE_CNT = 42.94967296 * fo
//	parameter		DEVIDE_CNT = 32'd175921860	//256000bps * 16
//	parameter		DEVIDE_CNT = 32'd87960930	//128000bps * 16
//	parameter		DEVIDE_CNT = 32'd79164837	//115200bps * 16
	parameter		DEVIDE_CNT = 32'd6597070	//9600bps * 16
)
(
	//global clock
	input			clk,
	input			rst_n,
	
	//user interface
	output			divide_clk,
	output			divide_clken
);

//------------------------------------------------------
//RTL1: Precise fractional frequency for uart bps clock 
reg	[31:0]	cnt;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt <= 0;
	else
		cnt <= cnt + DEVIDE_CNT;		
end

//------------------------------------------------------
//RTL2: Equal division of the Frequency division clock
reg	cnt_equal;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_equal <= 0;
	else if(cnt < 32'h7FFF_FFFF)
		cnt_equal <= 0;
	else
		cnt_equal <= 1;
end

//------------------------------------------------------
//RTL3: Generate enable clock for clock
reg	cnt_equal_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		cnt_equal_r <= 0;
	else
		cnt_equal_r <= cnt_equal;
end
assign	divide_clken = (~cnt_equal_r & cnt_equal) ? 1'b1 : 1'b0; 
assign	divide_clk = cnt_equal_r;


endmodule
