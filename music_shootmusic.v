/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				music_shootmusic.v
Date				:				2018-05-18
Description			:				the shoot music

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180518		ctlvie		1.0			Initial Version
180525		ctlvie		2.0			Final Version
========================================================*/

module music_shootmusic
(
	input				clk,
	input				sht,
	input				kill,
	input				enable_shoot,
	output reg			audio_out
);

reg			audio;
reg	[31:0]	cnt_end;
reg			[19:0]	cnt;
reg			[19:0]	cnt_once;
reg			[31:0]	cnt_delay;
reg			flag;

initial cnt_delay <= 0;
initial flag <= 0;
initial cnt_end = 600000;

always@(posedge clk)
begin
if(enable_shoot)
begin
	if(sht == 1 || kill == 1)
	begin
		if(kill)
			cnt_end <= 400000;
		else
			cnt_end <= 600000;
		cnt <= cnt + 1;
		if(cnt >= cnt_end/2 && cnt < cnt_end)
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
	
	if( (sht == 1 && flag == 0) || (kill == 1 && flag == 0) )
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

