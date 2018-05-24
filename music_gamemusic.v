/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				music_gamemusic.v
Date				:				2018-05-18
Description			:				the music during game playing

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180518		QiiNn		1.0		
========================================================*/

module music_gamemusic
(
	input				clk,
	input				enable_gamemusic,
	output reg			audio
);


reg [3:0]high,med,low;
reg [13:0]divider,origin;
reg [9:0]counter;
initial	counter <= 0;

wire carry;
assign carry = (divider==16383);

parameter L1 =12'b000000000001,			  		
		  L2 =12'b000000000010,				
		  L3 =12'b000000000011,		 		
		  L4 =12'b000000000100,	   		
		  L5 =12'b000000000101,	 
 		  L6 =12'b000000000110,    			 	
		  L7 =12'b000000000111,			   	
		  M1 =12'b000000010000,		 		 			 		
          M2 =12'b000000100000,
		  M3 =12'b000000110000,
  		  M4 =12'b000001000000,
		  M5 =12'b000001010000,	
		  M6 =12'b000001100000,	
		  M7 =12'b000001110000,	
		  H1 =12'b000100000000,	
		  H2 =12'b001000000000,		
		  H3 =12'b001100000000,
		  H4 =12'b010000000000,	
		  H5 =12'b010100000000,
		  H6 =12'b011000000000,		
		  H7 =12'b011100000000,
		  E0 =12'b000000000000;

		  

reg 		clk_6MHz;
reg[1:0]  	cnt_6MHz;

//	parameters HALFDIV  3;      //（50m/6m=8. 333 333  8/2-1=3）
always @(posedge clk)
begin
	if(cnt_6MHz < 3) 
		cnt_6MHz = cnt_6MHz + 1;            
	else 
		begin 
		cnt_6MHz = 0;  
		clk_6MHz = ~clk_6MHz; 
		end	
end

reg[26:0] cnt_4Hz;
reg  clk_4Hz;

always @(posedge clk)
begin
	//if(cnt_4Hz < 12499999)
	if(cnt_4Hz < 8499999)
			cnt_4Hz = cnt_4Hz + 1;  // (50m/4hz=12500000,cnt<[12 500 000/2-1=12499999）
	else  
		begin  
		cnt_4Hz = 0;  
		clk_4Hz =~ clk_4Hz;  
		end	  
end

	
always @(posedge clk_6MHz)
begin 
	if(carry)
		divider <= origin;
	else
		divider <= divider + 1;
end

always @(posedge carry)
	audio <=~ audio; 

	
always @(posedge clk_4Hz)
	begin 
		case({high,med,low})
		L1:origin<=4933;
		L2:origin<=6179;
		L3:origin<=7292;
		L4:origin<=7787;
		L5:origin<=8730;
		L6:origin<=9565;
		L7:origin<=10310;
		M1:origin<=10647;
		M2:origin<=11272;
		M3:origin<=11831;
		M4:origin<=12085;
		M5:origin<=12556;
		M6:origin<=12974;
		M7:origin<=13347;
		H1:origin<=13515;
		H2:origin<=13830;
		H3:origin<=14107;
		H4:origin<=14236;
		H5:origin<=14470;
		H6:origin<=14678;
		H7:origin<=14858;
		E0:origin<=16383;
		endcase
end


always @(posedge clk_4Hz)
begin
	if(enable_gamemusic)
	begin
		counter <= counter+1;
		case(counter)
		1:{high,med,low} <= M1;
		2:{high,med,low} <= M2;
		3:{high,med,low} <= M3;
		4:{high,med,low} <= M1;
		5:{high,med,low} <= M2;
		6:{high,med,low} <= M3;
		7:{high,med,low} <= M3;
		8:{high,med,low} <= M4;
		9:{high,med,low} <= M5;
		10:{high,med,low} <= M3;
		11:{high,med,low} <= M4;
		12:{high,med,low} <= M5;
		13:{high,med,low} <= M4;
		14:{high,med,low} <= M5;
		15:{high,med,low} <= M6;
		16:{high,med,low} <= M4;
		17:{high,med,low} <= M5;
		18:{high,med,low} <= M6;
		19:{high,med,low} <= M6;
		20:{high,med,low} <= M7;
		21:{high,med,low} <= H1;
		22:{high,med,low} <= E0;
		23:{high,med,low} <= H1;
		24:{high,med,low} <= H1;
		25:{high,med,low} <= E0;
		26:{high,med,low} <= H1;
		27:{high,med,low} <= E0;
		28:{high,med,low} <= H1;
		29:{high,med,low} <= E0;
		30:{high,med,low} <= H1;
		31:{high,med,low} <= E0;
		32:{high,med,low} <= H1;
		33:{high,med,low} <= H1;
		34:{high,med,low} <= E0;

		endcase
	end
	else
		counter <= 0;
		
end

endmodule

/*



*/

