/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				driver_VGA.v
Date				:				2018-04-16
Description			:				The driver module of VGA display

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180416		ctlvie		1.0			Origin (without Modelsim simulation)
180420		ctlvie		1.1			First successful simulation and add parameters which only use in simulation
180507		ctlvie		1.2			Bug fixed - change the VGA_en output property to input 
180507		ctlvie		1.2			Bug fixed - correct the colors interfaces
180525		ctlvie		2.0			Final Version
========================================================*/

`timescale 1ns/1ns

//640*480@60Hz	VGA Timing
`define		H_FRONT		11'd16
`define		H_SYNC		11'd96
`define		H_BACK		11'd48
`define		H_DISP		11'd640
`define		H_TOTAL		11'd800
`define		V_FRONT		11'd10
`define		V_SYNC		11'd2
`define		V_BACK		11'd33
`define		V_DISP		11'd480
`define		V_TOTAL		11'd525


//parameters which only use in simulation
/*
`define		H_FRONT		11'd5
`define		H_SYNC		11'd5
`define		H_BACK		11'd5
`define		H_DISP		11'd32
`define		H_TOTAL		11'd47
`define		V_FRONT		11'd1
`define		V_SYNC		11'd1
`define		V_BACK		11'd0
`define		V_DISP		11'd5
`define		V_TOTAL		11'd7
*/


module driver_VGA
(
//global clock
input 					clk,
input					rst_n,

//vga interface
output					VGA_en,
output					Hsync,
output					Vsync,
output		[3:0]		vgaRed,
output		[3:0]		vgaBlue,
output		[3:0]		vgaGreen,

//user interface
output					VGA_request,
output		[10:0]		VGA_xpos,
output		[10:0]		VGA_ypos,
input		[11:0]		VGA_data
);


//----------------------------------------
//Hsync counter and generator
reg [10:0]	hcnt;
always@(posedge clk or negedge rst_n)
begin	
	if(!rst_n)
		hcnt <= 11'd0;
	else
		begin
		if(hcnt < `H_TOTAL - 1'b1)
			hcnt <= hcnt + 1'b1;
		else
			hcnt <= 11'd0;
		end
end
assign	Hsync = (hcnt <= `H_SYNC - 1'b1)?1'b0:1'b1;

//----------------------------------------
//Vsync counter and generator
reg [10:0]	vcnt;
always@(posedge clk or negedge rst_n)
begin	
	if(!rst_n)
		vcnt <= 11'd0;
	else if(hcnt == `H_TOTAL - 1'b1)
		begin
		if(vcnt < `V_TOTAL - 1'b1)
			vcnt <= vcnt + 1'b1;
		else
			vcnt <= 11'b0;
		end
end
assign	Vsync = (vcnt <= `V_SYNC - 1'b1)?1'b0:1'b1;

//----------------------------------------
assign	VGA_en	=	(hcnt >= `H_SYNC + `H_BACK &&
					 hcnt < `H_SYNC + `H_BACK + `H_DISP)&&
					(vcnt >= `V_SYNC + `V_BACK &&
					 vcnt < `V_SYNC + `V_BACK + `V_DISP)?1'b1:1'b0;
					 
assign	vgaRed[3] = VGA_en ? VGA_data[11] : 1'b0 ;
assign	vgaRed[2] = VGA_en ? VGA_data[10] : 1'b0 ;
assign	vgaRed[1] = VGA_en ? VGA_data[9] : 1'b0 ;
assign	vgaRed[0] = VGA_en ? VGA_data[8] : 1'b0 ;
assign	vgaGreen[3] = VGA_en ? VGA_data[7] : 1'b0 ;
assign	vgaGreen[2] = VGA_en ? VGA_data[6] : 1'b0 ;
assign	vgaGreen[1] = VGA_en ? VGA_data[5] : 1'b0 ;
assign	vgaGreen[0] = VGA_en ? VGA_data[4] : 1'b0 ;
assign	vgaBlue[3] = VGA_en ? VGA_data[3] : 1'b0 ;
assign	vgaBlue[2] = VGA_en ? VGA_data[2] : 1'b0 ;
assign	vgaBlue[1] = VGA_en ? VGA_data[1] : 1'b0 ;
assign	vgaBlue[0] = VGA_en ? VGA_data[0] : 1'b0 ;


//----------------------------------------
//ahead x clock
localparam H_AHEAD = 11'b1;
assign	VGA_request = 	(hcnt >= `H_SYNC + `H_BACK - H_AHEAD &&
						 hcnt < `H_SYNC + `H_BACK + `H_DISP - H_AHEAD)&&
						(vcnt >= `V_SYNC + `V_BACK &&
						 vcnt < `V_SYNC + `V_BACK + `V_DISP)
						 ?1'b1:1'b0;
						 
//----------------------------------------
//VGA xpos and ypos
assign	VGA_xpos = VGA_request ? (hcnt - (`H_SYNC + `H_BACK - H_AHEAD)):11'd0;
assign	VGA_ypos = VGA_request ? (vcnt - (`V_SYNC + `V_BACK)) : 11'd0;

endmodule