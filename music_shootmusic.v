/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				music_shootmusic.v
Date				:				2018-05-18
Description			:				the shoot music

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180518		QiiNn		1.0		
========================================================*/

module music_shootmusic
(
	input				clk,
	input				sht,
	input				enable_shoot,
	output reg			audio_out
);

reg			audio;
parameter 	cnt_end = 600000;
reg			[19:0]	cnt;
reg			[19:0]	cnt_once;
reg			[31:0]	cnt_delay;
reg			flag;

initial cnt_delay <= 0;
initial flag <= 0;

always@(posedge clk)
begin
if(enable_shoot)
begin
	if(sht)
	begin
		cnt <= cnt + 1;
		if(cnt >= cnt_end/2)
		begin
			audio <= 1;
		end
		if(cnt >= cnt_end)
		begin
			cnt <= 0;
			audio <= 0;
		end
	end
	else
		flag <= 0;
	
	if(sht == 1 && flag == 0)
	begin
		cnt_delay <= cnt_delay + 1;
		audio_out <= audio;
		if(cnt_delay > 30000000)
		begin
		flag <= 1;
		cnt_delay <= 0;
		audio_out <= 0;
		end
	end
end
else
	audio_out <= 0;
	
end



endmodule

/*



*/

