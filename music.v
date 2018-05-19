/*=======================================================
Author				:				QiiNn
Email Address		:				ctlvie@gmail.com
Filename			:				music.v
Date				:				2018-05-18
Description			:				the music player module

Modification History:
Date		By			Version		Description
----------------------------------------------------------
180518		QiiNn		1.0		
========================================================*/

module music
(
	input				clk,
	input  		enable_music1,
	input		enable_music2,
	output reg	audio
);


reg [3:0]high,med,low;
reg [13:0]divider,origin;
reg [9:0]counter;
reg [9:0]counter_2;
initial	counter <= 0;
initial counter_2 <= 0;

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

reg		start_flag;

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
	if(enable_music1 == 1'b1)
	begin
		if(counter >= 259)
			counter <= 0;
		else counter <= counter+1;
		case(counter)
		1	:{high,med,low} <= E0 ;
		2	:{high,med,low} <= L5 ;
		3	:{high,med,low} <= L6 ;
		4	:{high,med,low} <= L7 ;
		5	:{high,med,low} <= M1 ;
		6	:{high,med,low} <= E0 ;
		7	:{high,med,low} <= M1 ;
		8	:{high,med,low} <= E0 ;
		9	:{high,med,low} <= M1 ;
		10	:{high,med,low} <= L7 ;
		11	:{high,med,low} <= M1 ;
		12	:{high,med,low} <= M2 ;
		13	:{high,med,low} <= M3 ;
		14	:{high,med,low} <= E0 ;
		15	:{high,med,low} <= M3 ;
		16	:{high,med,low} <= E0 ;
		17	:{high,med,low} <= M3 ;
		18	:{high,med,low} <= M2 ;
		19	:{high,med,low} <= M3 ;
		20	:{high,med,low} <= M4 ;
		21	:{high,med,low} <= M5 ;
		22	:{high,med,low} <= E0 ;
		23	:{high,med,low} <= M5 ;
		24	:{high,med,low} <= E0 ;
		25	:{high,med,low} <= M5 ;
		26	:{high,med,low} <= M4 ;
		27	:{high,med,low} <= M5 ;
		28	:{high,med,low} <= H1 ;
		29	:{high,med,low} <= M5 ;
		30	:{high,med,low} <= M5 ;
		31	:{high,med,low} <= M5 ;
		32	:{high,med,low} <= M5 ;
		33	:{high,med,low} <= M5 ;
		34	:{high,med,low} <= E0 ;
		35	:{high,med,low} <= M3 ;
		36	:{high,med,low} <= M3 ;
		37	:{high,med,low} <= M4 ;
		38	:{high,med,low} <= E0 ;
		39	:{high,med,low} <= M4 ;
		40	:{high,med,low} <= M3 ;
		41	:{high,med,low} <= M2 ;
		42	:{high,med,low} <= M2 ;
		43	:{high,med,low} <= M4 ;
		44	:{high,med,low} <= M4 ;
		45	:{high,med,low} <= M3 ;
		46	:{high,med,low} <= E0 ;
		47	:{high,med,low} <= M3 ;
		48	:{high,med,low} <= M2 ;
		49	:{high,med,low} <= M1 ;
		50	:{high,med,low} <= M1 ;
		51	:{high,med,low} <= M3 ;
		52	:{high,med,low} <= M3 ;
		53	:{high,med,low} <= M2 ;
		54	:{high,med,low} <= M2 ;
		55	:{high,med,low} <= L6 ;
		56	:{high,med,low} <= L6 ;
		57	:{high,med,low} <= L7 ;
		58	:{high,med,low} <= L7 ;
		59	:{high,med,low} <= M1 ;
		60	:{high,med,low} <= M1 ;
		61	:{high,med,low} <= M2 ;
		62	:{high,med,low} <= M2 ;
		63	:{high,med,low} <= M2 ;
		64	:{high,med,low} <= M2 ;
		65	:{high,med,low} <= E0 ;
		66	:{high,med,low} <= L5 ;
		67	:{high,med,low} <= L6 ;
		68	:{high,med,low} <= L7 ;
		69	:{high,med,low} <= M1 ;
		70	:{high,med,low} <= E0 ;
		71	:{high,med,low} <= M1 ;
		72	:{high,med,low} <= E0 ;
		73	:{high,med,low} <= M1 ;
		74	:{high,med,low} <= L7 ;
		75	:{high,med,low} <= M1 ;
		76	:{high,med,low} <= M2 ;
		77	:{high,med,low} <= M3 ;
		78	:{high,med,low} <= E0 ;
		79	:{high,med,low} <= M3 ;
		80	:{high,med,low} <= E0 ;
		81	:{high,med,low} <= M3 ;
		82	:{high,med,low} <= M2 ;
		83	:{high,med,low} <= M3 ;
		84	:{high,med,low} <= M4 ;
		85	:{high,med,low} <= M5 ;
		86	:{high,med,low} <= E0 ;
		87	:{high,med,low} <= M5 ;
		88	:{high,med,low} <= E0 ;
		89	:{high,med,low} <= M5 ;
		90	:{high,med,low} <= M4 ;
		91	:{high,med,low} <= M5 ;
		92	:{high,med,low} <= H1 ;
		93	:{high,med,low} <= M5 ;
		94	:{high,med,low} <= M5 ;
		95	:{high,med,low} <= M5 ;
		96	:{high,med,low} <= M5 ;
		97	:{high,med,low} <= M5 ;
		98	:{high,med,low} <= E0 ;
		99	:{high,med,low} <= M1 ;
		100	:{high,med,low} <= M1 ;
		101	:{high,med,low} <= M6 ;
		102	:{high,med,low} <= M6 ;
		103	:{high,med,low} <= M5 ;
		104	:{high,med,low} <= M5 ;
		105	:{high,med,low} <= M4 ;
		106	:{high,med,low} <= M4 ;
		107	:{high,med,low} <= M3 ;
		108	:{high,med,low} <= M3 ;
		109	:{high,med,low} <= M2 ;
		110	:{high,med,low} <= M2 ;
		111	:{high,med,low} <= M1 ;
		112	:{high,med,low} <= M1 ;
		113	:{high,med,low} <= L7 ;
		114	:{high,med,low} <= L7 ;
		115	:{high,med,low} <= M1 ;
		116	:{high,med,low} <= M1 ;
		117	:{high,med,low} <= M2 ;
		118	:{high,med,low} <= M2 ;
		119	:{high,med,low} <= M3 ;
		120	:{high,med,low} <= M4 ;
		121	:{high,med,low} <= M3 ;
		122	:{high,med,low} <= M3 ;
		123	:{high,med,low} <= M2 ;
		124	:{high,med,low} <= M2 ;
		125	:{high,med,low} <= M1 ;
		126	:{high,med,low} <= M1 ;
		127	:{high,med,low} <= L5 ;
		128	:{high,med,low} <= L6 ;
		129	:{high,med,low} <= L7 ;
		130	:{high,med,low} <= M1 ;
		131	:{high,med,low} <= M2 ;
		132	:{high,med,low} <= M3 ;
		133	:{high,med,low} <= M4 ;
		134	:{high,med,low} <= E0 ;
		135	:{high,med,low} <= M4 ;
		136	:{high,med,low} <= E0 ;
		137	:{high,med,low} <= M4 ;
		138	:{high,med,low} <= E0 ;
		139	:{high,med,low} <= M4 ;
		140	:{high,med,low} <= E0 ;
		141	:{high,med,low} <= M4 ;
		142	:{high,med,low} <= M4 ;
		143	:{high,med,low} <= M3 ;
		144	:{high,med,low} <= M3 ;
		145	:{high,med,low} <= M4 ;
		146	:{high,med,low} <= M4 ;
		147	:{high,med,low} <= E0 ;
		148	:{high,med,low} <= M4 ;
		149	:{high,med,low} <= M5 ;
		150	:{high,med,low} <= E0 ;
		151	:{high,med,low} <= M5 ;
		152	:{high,med,low} <= E0 ;
		153	:{high,med,low} <= M5 ;
		154	:{high,med,low} <= M4 ;
		155	:{high,med,low} <= M3 ;
		156	:{high,med,low} <= M4 ;
		157	:{high,med,low} <= M5 ;
		158	:{high,med,low} <= M5 ;
		159	:{high,med,low} <= M5 ;
		160	:{high,med,low} <= M5 ;
		161	:{high,med,low} <= M5 ;
		162	:{high,med,low} <= E0 ;
		163	:{high,med,low} <= M2 ;
		164	:{high,med,low} <= M3 ;
		165	:{high,med,low} <= M4 ;
		166	:{high,med,low} <= E0 ;
		167	:{high,med,low} <= M4 ;
		168	:{high,med,low} <= E0 ;
		169	:{high,med,low} <= M4 ;
		170	:{high,med,low} <= E0 ;
		171	:{high,med,low} <= M4 ;
		172	:{high,med,low} <= E0 ;
		173	:{high,med,low} <= M4 ;
		174	:{high,med,low} <= M3 ;
		175	:{high,med,low} <= M4 ;
		176	:{high,med,low} <= M4 ;
		177	:{high,med,low} <= M4 ;
		178	:{high,med,low} <= E0 ;
		179	:{high,med,low} <= M4 ;
		180	:{high,med,low} <= M4 ;
		181	:{high,med,low} <= M5 ;
		182	:{high,med,low} <= E0 ;
		183	:{high,med,low} <= M5 ;
		184	:{high,med,low} <= E0 ;
		185	:{high,med,low} <= M5 ;
		186	:{high,med,low} <= M4 ;
		187	:{high,med,low} <= M3 ;
		188	:{high,med,low} <= M4 ;
		189	:{high,med,low} <= M5 ;
		190	:{high,med,low} <= M5 ;
		191	:{high,med,low} <= M5 ;
		192	:{high,med,low} <= M5 ;
		193	:{high,med,low} <= E0 ;
		194	:{high,med,low} <= E0 ;
		195	:{high,med,low} <= M1 ;
		196	:{high,med,low} <= M1 ;
		197	:{high,med,low} <= M6 ;
		198	:{high,med,low} <= E0 ;
		199	:{high,med,low} <= M6 ;
		200	:{high,med,low} <= E0 ;
		201	:{high,med,low} <= H1 ;
		202	:{high,med,low} <= H1 ;
		203	:{high,med,low} <= H1 ;
		204	:{high,med,low} <= M6 ;
		205	:{high,med,low} <= M5 ;
		206	:{high,med,low} <= E0 ;
		207	:{high,med,low} <= M5 ;
		208	:{high,med,low} <= E0 ;
		209	:{high,med,low} <= M5 ;
		210	:{high,med,low} <= M4 ;
		211	:{high,med,low} <= M3 ;
		212	:{high,med,low} <= M3 ;
		213	:{high,med,low} <= M4 ;
		214	:{high,med,low} <= E0 ;
		215	:{high,med,low} <= M4 ;
		216	:{high,med,low} <= E0 ;
		217	:{high,med,low} <= L7 ;
		218	:{high,med,low} <= L7 ;
		219	:{high,med,low} <= M4 ;
		220	:{high,med,low} <= M4 ;
		221	:{high,med,low} <= M3 ;
		222	:{high,med,low} <= E0 ;
		223	:{high,med,low} <= M3 ;
		224	:{high,med,low} <= E0 ;
		225	:{high,med,low} <= M3 ;
		226	:{high,med,low} <= M2 ;
		227	:{high,med,low} <= M1 ;
		228	:{high,med,low} <= M1 ;
		229	:{high,med,low} <= M6 ;
		230	:{high,med,low} <= E0 ;
		231	:{high,med,low} <= M6 ;
		232	:{high,med,low} <= E0 ;
		233	:{high,med,low} <= H1 ;
		234	:{high,med,low} <= H1 ;
		235	:{high,med,low} <= H1 ;
		236	:{high,med,low} <= M6 ;
		237	:{high,med,low} <= M5 ;
		238	:{high,med,low} <= E0 ;
		239	:{high,med,low} <= M5 ;
		240	:{high,med,low} <= E0 ;
		241	:{high,med,low} <= M5 ;
		242	:{high,med,low} <= M4 ;
		243	:{high,med,low} <= M3 ;
		244	:{high,med,low} <= M3 ;
		245	:{high,med,low} <= M4 ;
		246	:{high,med,low} <= E0 ;
		247	:{high,med,low} <= M4 ;
		248	:{high,med,low} <= E0 ;
		249	:{high,med,low} <= L7 ;
		250	:{high,med,low} <= L7 ;
		251	:{high,med,low} <= M2 ;
		252	:{high,med,low} <= M2 ;
		253	:{high,med,low} <= M1 ;
		254	:{high,med,low} <= M1 ;
		255	:{high,med,low} <= E0 ;
		256	:{high,med,low} <= M1 ;
		257	:{high,med,low} <= E0 ;
		258	:{high,med,low} <= M1 ;
		endcase
	end
	if (enable_music2 == 1'b1 )
	begin
	if(start_flag == 1'b0)
	begin
		start_flag <= 1'b1;
		if(counter_2 >= 59)
				counter_2 <= 0;
			else counter_2 <= counter_2+1;
			case(counter_2)
			1	:{high,med,low} <= M1 ;
			2	:{high,med,low} <= M1 ;
			3	:{high,med,low} <= M2 ;
			4	:{high,med,low} <= M2 ;
			5	:{high,med,low} <= M3 ;
			6	:{high,med,low} <= M3 ;
			7	:{high,med,low} <= M1 ;
			8	:{high,med,low} <= M1 ;
			9	:{high,med,low} <= M2 ;
			10	:{high,med,low} <= M2 ;
			11	:{high,med,low} <= M3 ;
			12	:{high,med,low} <= M3 ;
			13	:{high,med,low} <= E0 ;
			14	:{high,med,low} <= M3 ;
			15	:{high,med,low} <= M3 ;
			16	:{high,med,low} <= M4 ;
			17	:{high,med,low} <= M4 ;
			18	:{high,med,low} <= M5 ;
			19	:{high,med,low} <= M5 ;
			20	:{high,med,low} <= M3 ;
			21	:{high,med,low} <= M3 ;
			22	:{high,med,low} <= M4 ;
			23	:{high,med,low} <= M4 ;
			24	:{high,med,low} <= M5 ;
			25	:{high,med,low} <= M5 ;
			26	:{high,med,low} <= M4 ;
			27	:{high,med,low} <= M4 ;
			28	:{high,med,low} <= M5 ;
			29	:{high,med,low} <= M5 ;
			30	:{high,med,low} <= M6 ;
			31	:{high,med,low} <= M6 ;
			32	:{high,med,low} <= M4 ;
			33	:{high,med,low} <= M4 ;
			34	:{high,med,low} <= M5 ;
			35	:{high,med,low} <= M5 ;
			36	:{high,med,low} <= M6 ;
			37	:{high,med,low} <= M6 ;
			38	:{high,med,low} <= E0 ;
			39	:{high,med,low} <= M6 ;
			40	:{high,med,low} <= M6 ;
			41	:{high,med,low} <= M7 ;
			42	:{high,med,low} <= M7 ;
			43	:{high,med,low} <= H1 ;
			44	:{high,med,low} <= H1 ;
			45	:{high,med,low} <= E0 ;
			46	:{high,med,low} <= H1 ;
			47	:{high,med,low} <= H1 ;
			48	:{high,med,low} <= H1 ;
			49	:{high,med,low} <= E0 ;
			50	:{high,med,low} <= H1 ;
			51	:{high,med,low} <= E0 ;
			52	:{high,med,low} <= H1 ;
			53	:{high,med,low} <= E0 ;
			54	:{high,med,low} <= H1 ;
			55	:{high,med,low} <= E0 ;
			56	:{high,med,low} <= H1 ;
			57	:{high,med,low} <= H1 ;
			58	:{high,med,low} <= E0 ;
			endcase
		end
	end
	else
		begin
		start_flag <= 1'b0;
		end
		
end

endmodule

/*



*/

