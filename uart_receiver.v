/*-----------------------------------------------------------------------
								 \\\|///
							   \\  - -  //
								(  @ @  )
+-----------------------------oOOo-(_)-oOOo-----------------------------+
CONFIDENTIAL IN CONFIDENCE
This confidential and proprietary software may be only used as authorized
by a licensing agreement from CrazyBingo (Thereturnofbingo).
In the event of publication, the following notice is applicable:
Copyright (C) 2013-20xx CrazyBingo Corporation
The entire notice above must be reproduced on all authorized copies.
Author				:		CrazyBingo
Technology blogs 	: 		www.crazyfpga.com
Email Address 		: 		crazyfpga@vip.qq.com
Filename			:		uart_receiver.v
Date				:		2012-01-28
Description			:		Data receive for PC to FPGA.
Modification History	:
Date			By			Version			Change Description
=========================================================================
12/01/28		CrazyBingo	1.0				Original
12/12/04		CrazyBingo	2.0				Modification
13/06/25		CrazyBingo	3.0				Modification
14/04/11		CrazyBingo	3.1				Modification
-------------------------------------------------------------------------
|                                     Oooo								|
+-------------------------------oooO--(   )-----------------------------+
                               (   )   ) /
                                \ (   (_/
                                 \_)
-----------------------------------------------------------------------*/

`timescale 1 ns / 1 ns
module uart_receiver
(
	//gobal clock
	input				clk,
	input				rst_n,
	
	//user interface
	input				clken_16bps,//clk_bps * 16
	
	//uart interface
	input				rxd,		//uart txd interface
	output	reg	[7:0]	rxd_data,	//uart data receive
	output	reg			rxd_flag	//uart data receive done 
);


/**************************************************************************
..IDLE...Start...............UART DATA........................End...IDLE...
________													 ______________
        |____< D0 >< D1 >< D2 >< D3 >< D4 >< D5 >< D6 >< D7 >
		Bit0  Bit1  Bit2  Bit3  Bit4  Bit5  Bit6  Bit7  Bit8  Bit9
**************************************************************************/

//---------------------------------
//sync the rxd data: rxd_sync
reg	rxd_sync;				
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rxd_sync <= 1;
	else
		rxd_sync <= rxd;
end

//---------------------------------------
//parameter of uart transfer
localparam	R_IDLE		=	2'd0;		//detect if the uart data is begin
localparam	R_START		=	2'd1;		//uart transfert start mark bit
localparam	R_SAMPLE	=	2'd2;		//uart 8 bit data receive
localparam	R_STOP		=	2'd3;		//uart transfer stop mark bit
reg	[1:0]	rxd_state;					//uart receive state
reg	[3:0]	rxd_cnt;					//uart 8 bit data counter
reg	[3:0]	smp_cnt;					//16 * clk_bps, the center for sample
localparam	SMP_TOP		=	4'd15;
localparam	SMP_CENTER	=	4'd7;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		smp_cnt <= 0;
		rxd_cnt <= 0;
		rxd_state <= R_IDLE;
		end
	else 
		case(rxd_state)
		R_IDLE:		//Wait for start bit
			begin
			rxd_cnt <= 0;
			smp_cnt <= 0;
			if(rxd_sync == 1'b0)			//uart rxd start bit
				rxd_state <= R_START;
			else
				rxd_state <= R_IDLE;
			end
		R_START:
			begin
			if(clken_16bps == 1)			//clk_bps * 16
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_CENTER && rxd_sync != 1'b0)	//invalid data	
					begin
					rxd_cnt <= 0;
					rxd_state <= R_IDLE;
					end
				else if(smp_cnt == SMP_TOP)	//Count for 16 clocks
					begin
					rxd_cnt <= 1;
					rxd_state <= R_SAMPLE;	//start mark bit is over
					end
				else
					begin
					rxd_cnt <= 0;
					rxd_state <= R_START;	//wait start mark bit over
					end
				end
			else							//invalid data
				begin
				smp_cnt <= smp_cnt;
				rxd_state <= rxd_state;
				end
			end
		R_SAMPLE:	//Sample 8 bit of Uart: {LSB, MSB}
			begin
			if(clken_16bps == 1)			//clk_bps * 16
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_TOP)
					begin
					if(rxd_cnt < 4'd8)		//Totally 8 data
						begin
						rxd_cnt <= rxd_cnt + 1'b1;
						rxd_state <= R_SAMPLE;
						end
					else
						begin
						rxd_cnt <= 4'd9;	//Turn of stop bit
						rxd_state <= R_STOP;
						end
					end
				else
					begin
					rxd_cnt <= rxd_cnt;
					rxd_state <= rxd_state;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
		R_STOP:
			begin
			if(clken_16bps == 1)		//clk_bps * 16
				begin
				smp_cnt <= smp_cnt + 1'b1;
				if(smp_cnt == SMP_TOP)
					begin
					rxd_state <= R_IDLE;
					rxd_cnt <= 0;		//Stop data bit is done
					end
				else
					begin
					rxd_cnt <= 9;		//Stop data bit
					rxd_state <= R_STOP;
					end
				end
			else
				begin
				smp_cnt <= smp_cnt;
				rxd_cnt <= rxd_cnt;
				rxd_state <= rxd_state;
				end
			end
				
		endcase
end

//----------------------------------
//uart data receive in center point
reg	[7:0]	rxd_data_r;
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		rxd_data_r <= 0;
	else if(rxd_state == R_SAMPLE)
		begin
		if(clken_16bps == 1 && smp_cnt == SMP_CENTER)	//sample center point
			case(rxd_cnt)
			4'd1:	rxd_data_r[0] <= rxd_sync;
			4'd2:	rxd_data_r[1] <= rxd_sync;
			4'd3:	rxd_data_r[2] <= rxd_sync;
			4'd4:	rxd_data_r[3] <= rxd_sync;
			4'd5:	rxd_data_r[4] <= rxd_sync;
			4'd6:	rxd_data_r[5] <= rxd_sync;
			4'd7:	rxd_data_r[6] <= rxd_sync;
			4'd8:	rxd_data_r[7] <= rxd_sync;
			default:;
			endcase
		else
			rxd_data_r <= rxd_data_r;
		end
	else if(rxd_state == R_STOP)
		rxd_data_r <= rxd_data_r;
	else
		rxd_data_r <= 0;
end

//----------------------------------
//update uart receive data and receive flag signal
always@(posedge clk or negedge rst_n)
begin
	if(!rst_n)
		begin
		rxd_data <= 0;
		rxd_flag <= 0;
		end
	else if(clken_16bps == 1 &&  rxd_cnt == 4'd9 && smp_cnt == SMP_TOP)	//Start + 8 Bit + Stop Bit
		begin
		rxd_data <= rxd_data_r;
		rxd_flag <= 1;
		end
	else
		begin
		rxd_data <= rxd_data;
		rxd_flag <= 0;
		end
end


endmodule
