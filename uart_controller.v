/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				uart_controller.v
Date				:				2018-05-18
Description			:				the uart top module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180518		QiiNn		1.0		
========================================================*/

module uart_controller
(
	input				clk,		
	input				fpga_rxd,		//pc 2 fpga uart receiver
	output				fpga_txd,		//fpga 2 pc uart transfer
	output	reg			bt_w,
	output	reg			bt_s,
	output	reg			bt_a,
	output	reg			bt_d,
	output	reg			bt_st,
	output	reg		[15:0] led
);


//------------------------------------
//Precise clk divider
wire	divide_clken;
uart_precise_divider	
#(
	//DEVIDE_CNT = 42.94967296 * fo
	
//	.DEVIDE_CNT	(32'd175921860)	//256000bps * 16	
//	.DEVIDE_CNT	(32'd87960930)	//128000bps * 16
	.DEVIDE_CNT	(32'd79164837)	//115200bps * 16
//	.DEVIDE_CNT	(32'd6597070)	//9600bps * 16
)
u_precise_divider
(
	//global
	.clk				(clk),		//100MHz clock
	.rst_n				(1'b1),    //global reset
	
	//user interface
	.divide_clk			(divide_clk),
	.divide_clken		(divide_clken)
);



wire	clken_16bps = divide_clken;
//---------------------------------
//Data receive for PC to FPGA.

wire			rxd_flag;
wire		[7:0]	rxd_data;

uart_receiver	u_uart_receiver
(
	//gobal clock
	.clk			(clk),
	.rst_n			(1'b1),
	
	//uart interface
	.clken_16bps	(clken_16bps),	//clk_bps * 16
	.rxd			(fpga_rxd),		//uart txd interface
	
	//user interface
	.rxd_data		(rxd_data),		//uart data receive
	.rxd_flag		(rxd_flag)  	//uart data receive done
);


always@(posedge clk)
begin
	if(rxd_data == 8'h41)
	begin
		bt_w <= 1'b1;
		led[15] <= 1'b1;
	end
	else
	begin
		bt_w <= 1'b0;
		led[15] <= 1'b0;
	end
end

always@(posedge clk)
begin
	if(rxd_data == 8'h42)
	begin
		bt_s <= 1'b1;
		led[14] <= 1'b1;
	end
	else
	begin
		bt_s <= 1'b0;
		led[14] <= 1'b0;
	end
end

always@(posedge clk)
begin
	if(rxd_data == 8'h43)
	begin
		bt_a <= 1'b1;
		led[13] <= 1'b1;
	end
	else
	begin
		bt_a <= 1'b0;
		led[13] <= 1'b0;
	end
end

always@(posedge clk)
begin
	if(rxd_data == 8'h44)
	begin
		bt_d <= 1'b1;
		led[12] <= 1'b1;
	end
	else
	begin
		bt_d <= 1'b0;
		led[12] <= 1'b0;
	end
end

always@(posedge clk)
begin
	if(rxd_data == 8'h46 || rxd_data == 8'h4E)
	begin
		bt_st <= 1'b1;
		led[11] <= 1'b1;
	end
	else
	begin
		bt_st <= 1'b0;
		led[11] <= 1'b0;
	end
end

//---------------------------------
//Data receive for PC to FPGA.
uart_transfer	u_uart_transfer
(
	//gobal clock
	.clk			(clk),
	.rst_n			(1'b1),
	
	//uaer interface
	.clken_16bps	(clken_16bps),	//clk_bps * 16
	.txd			(fpga_txd),  	//uart txd interface
           
	//user interface   
	.txd_en			(),		//uart data transfer enable
	.txd_data		(), 	//uart transfer data	
	.txd_flag		() 			//uart data transfer done
);


endmodule

/*



*/

