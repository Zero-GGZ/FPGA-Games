/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				reward_laser.v
Date				:				2018-05-23
Description			:				

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180523		QiiNn		1.0			Initial Version
180524		QiiNn		1.2			Add enable interface
========================================================*/

module	reward_laser
(
	input				clk,
	input				enable_reward,
	input				reward_laser,
	input	[4:0]		mytank_xpos,
	input	[4:0]		mytank_ypos,
	input	[1:0]		mytank_dir,
	input	[10:0]		VGA_xpos,
	input	[10:0]		VGA_ypos,
	input				reward_test,
	output	reg [11:0]	VGA_data
);

always@(posedge clk)
begin
if(enable_reward)
begin
	if(reward_laser == 1'b1 || reward_test == 1'b1)
	begin
	case(mytank_dir)
	2'b00:
		begin
		if( (VGA_xpos >= mytank_xpos * 20 + 80 - 2) 
			&& (VGA_xpos <= mytank_xpos * 20 + 80 + 2)
			&& (VGA_ypos >= 70 )
			&& (VGA_ypos <= mytank_ypos * 20 + 80 - 10 ) )
			VGA_data <= 12'hFF0;
		else
			VGA_data <= 0;	
		end
	2'b01:
		begin
		if( (VGA_xpos >= mytank_xpos * 20 + 80 - 2) 
			&& (VGA_xpos <= mytank_xpos * 20 + 80 + 2)
			&& (VGA_ypos >= mytank_ypos * 20 + 80 + 10 )
			&& (VGA_ypos <= 330 ) )
			VGA_data <= 12'hFF0;
		else
			VGA_data <= 0;	
		end
	2'b10:
		begin
		if( (VGA_xpos >= 70 ) 
			&& (VGA_xpos <= mytank_xpos * 20 + 80 - 10)
			&& (VGA_ypos >= mytank_ypos * 20 + 80 - 2 )
			&& (VGA_ypos <= mytank_ypos * 20 + 80 + 2 ) )
			VGA_data <= 12'hFF0;
		else
			VGA_data <= 0;	
		end
	2'b11:
		begin
		if( (VGA_xpos >= mytank_xpos * 20 + 80 + 10 ) 
			&& (VGA_xpos <= 570)
			&& (VGA_ypos >= mytank_ypos * 20 + 80 - 2 )
			&& (VGA_ypos <= mytank_ypos * 20 + 80 + 2 ) )
			VGA_data <= 12'hFF0;
		else
			VGA_data <= 0;	
		end
	endcase	
	end
	else
		VGA_data <= 0;
end
else
	VGA_data <= 0;
end



endmodule

