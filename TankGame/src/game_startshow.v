/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				game_startshow.v
Date				:				2018-05-11
Description			:				the start show for the game

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180512		ctlvie		1.0			Initial Version
180525		ctlvie		2.0			Final Version
========================================================*/

`define	RED			12'hF00
`define	GREEN		12'h0F0
`define	BLUE		12'h00F
`define	WHITE		12'hFFF
`define	BLACK		12'h000
`define	YELLOW		12'hFF0
`define	CYAN		12'hF0F
`define	ROYAL		12'h0FF

module game_startshow
(
	input 			clk,
	input			clk_4Hz,
	input			clk_8Hz,
	input			enable,
	input [2:0]		mode,
	input	[10:0]	VGA_xpos,
	input	[10:0]	VGA_ypos,
	output	reg	[11:0]	VGA_data
);

reg [5:0]	counter;
reg			show1_sht_auto;
reg			show2_sht_auto;

always@(posedge clk_4Hz)
begin
	counter <= counter + 1;
	if(counter <= 60 )
		begin
		show1_sht_auto <=  1'b1;
		show2_sht_auto <=  1'b1;
		end
	else
		begin
		show1_sht_auto <=  1'b0;
		show2_sht_auto <=  1'b0;
		end
end


reg			show_en;

wire [4:0]	show1_x;
wire [4:0]	show1_y;
wire			show1_sht ;
wire			show1_shell_fb;
wire	[11:0]	VGA_data_show1_shell;
wire	[11:0]	VGA_data_show1_tank;
wire	[1:0]	show1_dir_out;


showtank_control show1_control
(	
	.clk			(clk),
	.clk_4Hz		(clk_4Hz),
	.enable			(show_en),
	.start_x		(0),
	.start_y		(2),
	.start_dir		(2'b11),
	.shell_state_feedback	(show1_shell_fb),
	.x_rel_pos_out		(show1_x),
	.y_rel_pos_out		(show1_y),	
	.tank_dir_out		(show1_dir_out),
	.shell_sht			(show1_sht)
);

shell show1_shell
(
	.clk		(clk),
	.clk_8Hz	(clk_8Hz),
	.enable		(show_en),

	
	.shell_dir	(show1_dir_out),	//the direction of shell
	.shell_state	(show1_sht_auto),	//the state of my shell
	
	.shell_ide	(1'b1),
	.tank_xpos	(show1_x),
	.tank_ypos	(show1_y),
	//input and output the position of my shell
	.x_shell_pos_out	(),
	.y_shell_pos_out	(),
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	//input the VGA data
	.VGA_data	(VGA_data_show1_shell),
	
	.shell_state_feedback	(show1_shell_fb)
);

tank_display	show1_phy
(
	.clk		(clk),
	.enable		(show_en),

	//input the relative position of tank
	.x_rel_pos	(show1_x),
	.y_rel_pos	(show1_y),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(1'b1),	//the state of tank
	.tank_ide	(1'b0),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(show1_dir_out),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_show1_tank)
);


wire [4:0]	show2_x;
wire [4:0]	show2_y;
wire			show2_sht ;
wire			show2_shell_fb;
wire	[11:0]	VGA_data_show2_shell;
wire	[11:0]	VGA_data_show2_tank;
wire	[1:0]	show2_dir_out;

showtank_control show2_control
(	
	.clk			(clk),
	.clk_4Hz		(clk_4Hz),
	.enable			(show_en),
	.start_x		(20),
	.start_y		(4),
	.start_dir		(2'b01),
	.shell_state_feedback	(show2_shell_fb),
	.x_rel_pos_out		(show2_x),
	.y_rel_pos_out		(show2_y),	
	.tank_dir_out		(show2_dir_out),
	.shell_sht			(show2_sht)
);

shell show2_shell
(
	.clk		(clk),
	.clk_8Hz	(clk_8Hz),
	.enable		(show_en),

	.shell_ide	(1'b0),
	.shell_dir	(show2_dir_out),	//the direction of shell
	.shell_state	(show2_sht_auto),	//the state of my shell
	
	.tank_xpos	(show2_x),
	.tank_ypos	(show2_y),
	//input and output the position of my shell
	.x_shell_pos_out	(),
	.y_shell_pos_out	(),
	//input VGA scan coordinate
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	//input the VGA data
	.VGA_data	(VGA_data_show2_shell),
	
	.shell_state_feedback	(show2_shell_fb)
);

tank_display	show2_phy
(
	.clk		(clk),
	.enable		(show_en),

	//input the relative position of tank
	.x_rel_pos	(show2_x),
	.y_rel_pos	(show2_y),
	.VGA_xpos	(VGA_xpos),
	.VGA_ypos	(VGA_ypos),
	
	.tank_state	(1'b1),	//the state of tank
	.tank_ide	(1'b1),	//the identify of tank (my tank(1'b1) or enemy tank(1'b0))
	.tank_dir	(show2_dir_out),	//the direction of tank
	
	//output the VGA data
	.VGA_data	(VGA_data_show2_tank)
);

reg		[12:0]		addr_bigtank;
wire	[0:0]		bigtank_pic;
reg		[11:0]		bigtank_reg;
reg		[8:0]		bigtank_x_offset;
initial 	bigtank_x_offset <= 0;

always@(posedge clk_4Hz)
	bigtank_x_offset <= bigtank_x_offset + 5;

always @(posedge clk)
begin
	if((show_en == 1)&&(VGA_xpos > 0 + bigtank_x_offset) && (VGA_xpos <= 90 + bigtank_x_offset) && (VGA_ypos > 260) && (VGA_ypos <= 350))
	begin
		addr_bigtank <= (VGA_xpos - bigtank_x_offset)  + 90 * (VGA_ypos - 260) ;
		if (bigtank_pic)
			bigtank_reg <= `GREEN;
		else
			bigtank_reg <= 0;
	end
	else
		bigtank_reg <= 0;
end

showtank_pic u_bigtank_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_bigtank),  // input wire [12 : 0] addra
  .douta(bigtank_pic)  // output wire [0 : 0] douta
);


always@(posedge clk)
begin
if(mode == 0)
begin
	show_en <= 1'b1;
	if ((VGA_xpos > 60)&&(VGA_xpos < 580)&&(VGA_ypos > 60)&&(VGA_ypos < 340))
		VGA_data  <= VGA_data_show1_shell | VGA_data_show1_tank | VGA_data_show2_shell | VGA_data_show2_tank | bigtank_reg ;
	else
		VGA_data <= 0;
end
else
begin
	show_en <= 1'b0;
	VGA_data <= 0;
end
end

endmodule
