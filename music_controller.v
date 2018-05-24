/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				music_controller.v
Date				:				2018-05-18
Description			:				the music top module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180518		QiiNn		1.0		
========================================================*/

module music_controller
(
	input				clk,
	input				sw1,
	input				sw2,
	input				btnC,
	input				enable_shootmusic,
	output reg	audio
);

wire	audio_gamemusic;
wire	audio_startmusic;
wire	audio_shootmusic;
reg		enable_shoot;
reg		audio_gamemusic_reg;
reg		audio_startmusic_reg;
reg		enable_gamemusic;
reg		enable_startmusic;
reg		audio_shootmusic_reg;
reg		sht;

always@(posedge clk)
begin
	if(sw1)
	begin
		enable_startmusic <= 1;
		enable_shoot <= 0;
		enable_gamemusic <= 0;
		audio <= audio_startmusic;
	end
	else if(sw2)
	begin
		enable_startmusic <= 0;
		enable_shoot <= 0;
		enable_gamemusic <= 1;
		audio <= audio_gamemusic;
	end
	else
		begin
		sht <= btnC;
		enable_startmusic <= 0;
		enable_shoot <= 1;
		enable_gamemusic <= 0;
		audio <= audio_shootmusic;
		end

end


/*
always@(posedge clk)
begin
	if(sw1)
	begin
		enable_startmusic <= 1;
		audio <= audio_startmusic;
	end
	else
	begin
		enable_startmusic <= 0;
	end
		
	if(sw2)
	begin
		enable_gamemusic <= 1'b1;
		audio <= audio_gamemusic;
	end
	else
	begin
		enable_gamemusic <= 1'b0;
	end
	
	
	if(btnC == 1 && enable_shootmusic == 1)
	begin
		enable_shoot <= 1'b1;
		sht <= 1'b1;
		audio <= audio_shootmusic;
	end
	else
	begin
		enable_shoot <= 1'b0;
	end
	

		
	
end
*/

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
	.sht			(sht),
	.enable_shoot	(enable_shoot),
	.audio_out		(audio_shootmusic)
);

endmodule

/*



*/

