# 基于Basys3的坦克大战游戏

## 引言

本设计是基于Xilinx Basys3的坦克大战游戏，通过Basys3板卡控制“坦克”的移动和射击，由拨码开关控制游戏的开始、模式选择等。游戏分为经典模式和无尽模式，经典模式中有4辆“敌方坦克”追击“己方坦克”，被击中后血量减一，直至血量为零后游戏终结，同时每击毁5辆坦克可使血量加一；无尽模式中以时间为游戏进度，倒计时结束后游戏终止，两种模式下击毁的坦克数均显示在开发板的数码管上。同时设置了道具机制，游戏中可随机掉落“加速”、“激光”、“冻结”等不同的道具，分别对应不同效果，丰富了游戏体验。

## 游戏介绍

游戏的启动界面如图所示，可通过拨码开关分别选择两种不同模式，且光标会随之移动。

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002029.png)

### 1. 经典模式和无尽模式

在经典模式中，屏幕上方会显示当前的“血量”，4辆敌方坦克会跟随玩家操纵的己方坦克自行移动，并发射炮弹，若玩家被击中则血量减一，直至血量为零时游戏结束。玩家需要通过操纵Basys3开发板上的4个按键控制己方坦克的移动，并发射炮弹，击中任意一个敌方坦克即可得一分，如图三所示，在开发板的数码管上会显示当前得分。

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002109.png)

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002125.png)

在无尽模式中，以时间为游戏进度，屏幕上方的进度条显示当前剩余时间，当玩家击中敌方坦克时可使时间加一，击中坦克的得分仍然在数码管上显示，直至游戏时间结束。图五显示了游戏结束之后的界面。

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002202.png)

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002214.png)

### 2. 道具机制

游戏中包含随机掉落的道具，在经典模式和无尽模式中均会随机出现，共分为“冻结”、“加时”、“加速”、“无敌”和“激光”五种。如图五所示，在吃到其中任何一种道具后均会在右上角显示该道具的剩余作用时间。

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002244.png)

 “加时”道具只出现在无尽模式中，吃到后可以延长一段游戏时间；“无敌”道具只出现在经典模式中，吃到后将会获得一段无敌时间；“冻结”道具激活后则四个敌方坦克将在一段时间内保持静止；图七显示了“激光”道具的作用效果，激活此道具后原有的“炮弹”升级为“激光”武器，可以直接击毁照射到的敌方坦克。

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002305.png)

## 系统设计

### 硬件设计

硬件部分主要由一块Basys3开发板和一台VGA显示器组成。

本设计使用了Basys3开发板的四个按键控制“坦克”的运动方向和射击，使用板上的拨码开关实现模式的选择，使用数码管显示当前得分。游戏的主体界面则由VGA显示器来显示。

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002341.png)

### 软件设计

本设计的软件部分由 Verilog HDL 代码编写完成，由赛灵思的 Vivado 设计套件配合 Modelsim 仿真软件完成设计。

图为 Verilog 代码的整体结构：

![](https://picture-1256315926.cos.ap-shanghai.myqcloud.com/img/20190621002425.png)

#### 1. 程序清单

| 模块名                | 功能                       |
| :-------------------- | -------------------------- |
|clock                 | 时钟控制模块               |
|driver_buttons        | 按键驱动模块               |
|driver_seg            | 数码管驱动模块             |
|driver_VGA            | VGA显示器驱动模块          |
|game_top              | 顶层模块                   |
|game_background       | 背景图片显示模块           |
|game_information      | 开始界面模式选择显示模块   |
|game_logic_classic    | 经典模式的控制模块         |
|game_logic_infinity   | 无尽模式的控制模块         |
|game_mode             | 模式选择模块               |
|game_startshow        | 开始界面动画显示模块       |
|enemytank_control     | “敌方坦克”控制模块         |
|mytank_control        | “己方坦克”控制模块         |
|tank_display          | 坦克显示模块               |
|tank_generate         | “敌方坦克”的生成模块       |
|shell                 | “炮弹”控制和显示模块       |
|item_display          | 道具图标显示模块           |
|item_information      | 道具信息显示模块           |
|item_laser            | “激光”道具控制模块         |
|item_logic            | 道具控制模块               |
|item_random_generator | 道具随机生成模块           |
|VGA_data_selector     | VGA显示数据选择模块        |
|seg_bin2dec           | 数码管驱动的二进制转换模块 |



#### 2. 游戏控制部分

游戏控制部分主要由“game_mode”、“game_logic_infinity”、“game_logic_classic”、“enemytank_control”、“mytank_control”、“shell”等几个模块来完成。

在游戏的模式控制上，游戏分为“经典模式”和“无限模式”两种模式，因此“game_mode”模块通过模式选择的拨码开关得到的信号来完成对不同模块的使能，如显示“坦克”的数量、道具的种类和生成方式等，进而达到模式控制的目的。而“game_logic_classic”和“game_logic_infinity”则分别对应两种模式下的计分、计时等功能。

在坦克的控制上，由“enemytank_control”和“mytank_control”分别对应玩家控制的己方坦克和敌方的坦克。玩家的己方坦克控制通过Basys3开发板上的四个按键实现，每次按下按键后更新“坦克”的方向信息和相应方向上的坐标。同时当坦克的坐标和敌方坦克发射的炮弹的坐标相同时输出一个反馈信号表示被击中。“enemytank_control”则负责敌方坦克的移动，在游戏中敌方坦克可以根据己方坦克的坐标位置，不断向着己方坦克的方向移动，并在达到和己方坦克水平坐标相同或垂直坐标相同时发射炮弹，进而达到自动追随移动的功能，丰富了游戏体验。“shell”模块负责“炮弹”的移动，当按下Basys3板卡上的按键后，它读取当前“坦克”的坐标和方向并开始移动，直到击中另一个“坦克”为止。

#### 3. 道具模块部分

在游戏的过程中，会随机掉落道具以实现不同的效果，主要由“item_random_generator”、“item_logic”、“item_display”、“item_information”等模块实现。

item_random_generator 为道具的随机生成模块，以游戏运行的时间作为种子值，使用线性反馈移位寄存器生成伪随机序列。当生成的随机数处于不同的范围时，对应不同的道具，进而使各种道具的出现概率有难易区分。

item_logic 为道具的控制模块，控制不同道具的作用时间，并输出不同的信号供其他模块配合响应，如“加速”道具激活后输出一个信号使坦克每个时钟周期的移动坐标更大、速度更快；“冻结”道具激活后输出信号使所有敌方坦克坐标不改变进而停止移动。item_display 和 item_information 均为道具的显示模块，分别负责在随机坐标处显示道具的图标，和在屏幕的右上角显示剩余的作用时间。

#### 4. 显示控制部分

显示控制部分主要负责“坦克”、“炮弹”以及各种图片信息在VGA显示器上的显示，主要可分为两类，一类是“tank_display”等模块，根据VGA驱动模块当前扫描像素点位置坐标来划分对应区域、显示不同的颜色，坦克和炮弹的显示均是通过这种方法；另一类则是图片的显示，通过将图片的像素信息存储在FPGA的 BRAM 上，调用相应的IP核来读取单口RAM的信息，进而显示出图片。

#### 5. 时钟和驱动控制部分

时钟部分主要由“clock”模块控制；“driver_seg”负责将得分信息显示在Basys3板卡的数码管上，“driver_VGA”则是VGA显示器的驱动模块。

## IP核调用

### 1. 时钟系统设计

本设计的时钟控制主要由“clock”模块和 Clocking IP核实现，图一为IP核的配置细节，输入为板上晶振的100MHz时钟信号，输出分别为一个100MHz时钟和25MHz时钟，25MHz的时钟主要用于VGA显示器的驱动。

由于Clocking IP核的最低输出频率为1MHz，其余的几个低频的时钟信号由clock模块完成，该模块利用计数器的方法将100MHz的主时钟输出为4Hz、8Hz的时钟，分别对应于坦克、炮弹的移动速度。

### 2. 图片显示

在游戏的开始界面、道具图标、结束界面和背景界面等位置，均使用了图片的显示，都是通过 Block Memory Generator IP核配合VGA显示器的驱动模块完成的。

首先将需要显示的图片通过Bmp2Mif等软件最终转化为coe文件，用于初始化ROM。其次生成一个Block Memory Generator IP核，配置一个单口ROM，其宽度为图片的位宽，深度为图片的总像素数，以刚才的coe文件对其初始化之后，在代码中例化相应的ROM，VGA驱动的扫描像素点即为读取ROM的地址信息，读出的数据则为需要在此像素点显示的颜色，最终即可实现图片的显示，以游戏结束图片的显示为例，其代码如下所示：

```VERILOG
always @(posedge clk)
begin
	if(VGA_xpos > 130 && VGA_xpos <= 510 && VGA_ypos > 120 && VGA_ypos <= 300)
	begin
		addr_gameover_pic <= (VGA_xpos - 130)  + 380 * (VGA_ypos - 120) ;
		gameover_reg <= gameover_pic ;
	end
	else
		gameover_reg <= 0;
end

gameove_pic u_gameover_pic (
  .clka(clk),    // input wire clka
  .ena(1'b1),      // input wire ena
  .addra(addr_gameover_pic),  // input wire [16 : 0] addra
  .douta(gameover_pic)  // output wire [2 : 0] douta
);
```



