/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				driver_buttons.v
Date				:				2018-05-24
Description			:				The buttons controller between wired and wireless buttons

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180523		ctlvie		1.0			Initial version
180525		ctlvie		2.0			Final Version
========================================================*/

module	driver_buttons
(
	input			clk,
	input		[15:0]	sw,
	input			bt_w,
	input			bt_s,
	input			bt_a,
	input			bt_d,
	input			bt_st,
	input			btn_wireless_w,
	input			btn_wireless_s,
	input			btn_wireless_a,
	input			btn_wireless_d,
	input			btn_wireless_st,
	input			btn_wireless_tri,
	input			btn_wireless_sqr,
	input			btn_wireless_cir,
	input			btn_wireless_cro,
	output			btn_w,
	output			btn_s,
	output			btn_a,
	output			btn_d,
	output			btn_st,
	output	reg		btn_mode_sel,
	output	reg		btn_stop,
	output	reg		btn_return
);

assign		btn_w = btn_wireless_w  |  bt_w    ;
assign		btn_s = btn_wireless_s  |  bt_s    ;
assign		btn_a = btn_wireless_a  |  bt_a    ;
assign		btn_d = btn_wireless_d  |  bt_d    ;
assign		btn_st = btn_wireless_st  |  bt_st    ;



initial		
begin
btn_mode_sel <= 1'b1;
btn_return 	<= 1'b0;
btn_stop 	<= 1'b0;
end


always@(posedge clk)
begin
	if(sw[15] == 1 || btn_wireless_cro == 1)
		btn_mode_sel <= 1'b0;
	else
		btn_mode_sel <= 1'b1;
		
	if(btn_wireless_sqr == 1)
		btn_stop <= 1'b1;
	else
		btn_stop <= 1'b0;
		
	if(btn_wireless_cir == 1 || sw[0] == 1)
		btn_return <= 1'b1;
	else
		btn_return <= 1'b0;
end


endmodule

/*



*/

