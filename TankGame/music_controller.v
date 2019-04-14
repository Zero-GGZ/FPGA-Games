/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				music_controller.v
Date				:				2018-05-18
Description			:				the music top controller module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180518		ctlvie		1.0			Initial Version
180525		ctlvie		2.0			Final Version
========================================================*/

module music_controller
(
	input				clk,
	input				sw1,
	input				sw2,
	input				btnC,
	input				kill,
	output 		reg		audio
);

wire	audio_gamemusic;
wire	audio_startmusic;
wire	audio_shootmusic;
reg		enable_shoot;
reg		enable_gamemusic;
reg		enable_startmusic;
reg		sht;
reg		kil;

always@(posedge clk)
begin
	if(sw1 == 1 )
	begin
		enable_startmusic <= 1;
		enable_shoot <= 0;
		enable_gamemusic <= 0;
		audio <= audio_startmusic;
	end
	else if(sw2 == 1)
	begin
		enable_startmusic <= 0;
		enable_shoot <= 0;
		enable_gamemusic <= 1;
		audio <= audio_gamemusic;
	end
	else
		begin
		sht <= btnC;
		kil <= kill;
		enable_startmusic <= 0;
		enable_shoot <= 1;
		enable_gamemusic <= 0;
		audio <= audio_shootmusic;
		end

end

music_gamemusic u_music_gamemusic
(
	.clk		(clk),
	.audio		(audio_gamemusic),
	.enable_gamemusic	(enable_gamemusic)
);

music_startmusic u_music_startmusic
(
	.clk		(clk),
	.audio		(audio_startmusic),
	.enable_startmusic	(enable_startmusic)
);

music_shootmusic u_music_shootmusic
(
	.clk			(clk),
	.kill			(kil),
	.sht			(sht),
	.enable_shoot	(enable_shoot),
	.audio_out		(audio_shootmusic)
);

endmodule

/*
*/