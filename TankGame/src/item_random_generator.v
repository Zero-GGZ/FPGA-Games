/*=======================================================
Author				:				ctlvie
Email Address		:				ctlvie@gmail.com
Filename			:				item_random_generator.v
Date				:				2018-05-22
Description			:				the random numbers generator for reward mechanism

Modification History:
Date		By			Version		Description
----------------------------------------------------  ------
180522		ctlvie		1.0			Initial Version
180525		ctlvie		2.0			Final Version
========================================================*/
`timescale 1ns/1ns
module item_random_generator
(
    input               	clk, 
	input					clk_4Hz,
	input					enable,
	input					set_finish,
	output		reg			dout,
	output		reg			set_require,
	output reg	[2:0]		item_type,	
	output reg	[4:0] 		random_xpos,
	output reg	[4:0]		random_ypos
);

`define		STAY_TIME	40
`define		BASE_TIME	20	 	

reg [7:0] 	 	rand_num;
reg [7:0] 	 	rand_num_2;
reg	[31:0]		cnt; 
reg				load;
reg		[7:0]	seed;
reg				lock;
reg		[3:0]	random_key_xpos;
reg		[2:0]	random_key_ypos;


initial 		
	begin
	load <= 0;
	seed <= 0;
	cnt <= 0;
	rand_num <= 10;
	rand_num_2 <= 28;
	random_xpos <= 0;
	random_ypos <= 0;
	random_key_xpos <= 0;
	random_key_ypos <= 0; 
	item_type	<= 0;
	lock 		<= 0;
	end


always@(posedge clk)
begin
	seed <= seed + 1;
	if(!load)
		rand_num_2 <= rand_num;
	else
		begin
		rand_num_2[0] <= rand_num_2[7];
		rand_num_2[1] <= rand_num_2[0];
		rand_num_2[2] <= rand_num_2[1];
		rand_num_2[3] <= rand_num_2[2];
		rand_num_2[4] <= rand_num_2[3]^rand_num_2[7];
		rand_num_2[5] <= rand_num_2[4]^rand_num_2[7];
		rand_num_2[6] <= rand_num_2[5]^rand_num_2[7];
		rand_num_2[7] <= rand_num_2[6];
		end
end

always@(posedge clk_4Hz)
begin
    if(enable)
	begin		
		if(!load)
		begin
			rand_num <=	seed;    /*load the initial value when load is active*/
			load <= 1;
			rand_num[0] <= rand_num[7];
			rand_num[1] <= rand_num[0];
			rand_num[2] <= rand_num[1];
			rand_num[3] <= rand_num[2];
			rand_num[4] <= rand_num[3]^rand_num[7];
			rand_num[5] <= rand_num[4]^rand_num[7];
			rand_num[6] <= rand_num[5]^rand_num[7];
			rand_num[7] <= rand_num[6];
		end
		else
		begin
			cnt <= cnt + 1;
			if(cnt >= `BASE_TIME + rand_num/2 )
			begin
				dout <= 1;
				set_require <= 1'b1;
				if(	(cnt >= `BASE_TIME + rand_num/2 + `STAY_TIME) || set_finish == 1'b1)
				begin
					dout <= 0;
					load <= 0;
					cnt  <= 0;
					set_require <= 1'b0;
				end
			end
			else
				begin
				dout <= 0;
				set_require <= 1'b0;
				end
		end
	end     
end



always@ (posedge clk)
begin
	if(dout)
	begin
		if(!lock)
		begin
		random_key_xpos <= 	seed[3:0];
		random_key_ypos	<= 	rand_num_2[2:0];
		random_xpos <= random_key_xpos + 4;
		random_ypos <= random_key_ypos + 2;
		lock 		<= 1;
		if (rand_num_2 >= 0 && rand_num_2 <= 31)
			item_type <= 1;
		else if (rand_num_2 >= 32 && rand_num_2 <= 95)
			item_type <= 2;
		else if (rand_num_2 >= 96 && rand_num_2 <= 159)
			item_type <= 3;
		else if (rand_num_2 >= 160 && rand_num_2 <= 255)
			item_type <= 4;
		else
			item_type <= 0;
		end
	end
	else
	begin
		random_xpos <= 0;
		random_ypos <= 0;
		lock 		<= 0;
		item_type <= 0;
	end
	
end


endmodule