# 基于FPGA的坦克大战游戏

## 功能简介

本设计是基于Xilinx Basys3的坦克大战游戏，实现了通过无线手柄控制坦克的移动和射击，由Basys3上的拨码开关控制游戏的开始、模式选择、难度设置等。游戏分为经典模式和无尽模式，经典模式中有4辆敌方坦克追击己方坦克，被击中后血量减一，直至血量为零后游戏终结，同时每击毁5辆坦克可使血量加一；无尽模式中则是以时间为游戏进度，倒计时结束后游戏终止，两种模式下击毁的坦克数均显示在开发板的数码管上。同时设置了奖励机制，捡到随机掉落的补给后有一定的奖励。同时游戏中设置有背景音乐。

通过各模块间的配合实现游戏的功能，接收无线手柄发送的串口数据执行坦克的移动和射击操作；音频方面，产生特定频率的信号由扬声器输出实现背景音乐和音效；实现了多种游戏模式和随机奖励的机制；敌方坦克可自动追踪和射击；具有背景音乐和无线手柄控制，丰富了游戏体验。

## 程序清单

|文件名|功能描述|
|-----|--------|
|game_top.v|顶层文件|
|mytank_app.v|“己方坦克”的控制模块|
|enytank_app.v|“敌方坦克”的控制模块|
|bullet.v|“炮弹”的控制模块|
|tank_generate.v|“坦克”的生成模块|
|tank_phy.v|“坦克”的底层显示驱动模块|
|game_information.v|显示“血量”及游戏时间|
|game_interface.v|游戏界面的显示模块|
|game_mode_v2.v|游戏模式选择模块|
|game_logic_classic.v|“经典模式”的控制模块|
|game_logic_infinity.v|“无尽模式”的控制模块|
|game_startshow.v|启动界面的显示模块|
|reward_display.v|掉落随机奖励的显示模块|
|reward_information.v|随机奖励的倒计时显示模块|
|reward_laser.v|随机奖励“激光武器”的控制模块|
|reward_logic.v|随机奖励的逻辑控制模块|
|reward_random_generator.v|随机奖励的随机生成模块|
|music_controller.v|音乐控制模块|
|music_gamemusic.v|游戏音乐模块|
|music_shootmusic.v|“射击”音效模块|
|music_startmusic.v|启动界面背景音乐模块|
|showtank_app.v|启动界面中演示“坦克”的显示模块|
|uart_controller.v|串口通信控制模块|
|uart_precise_divider.v|串口通信的底层驱动模块|
|game_SegAndLed.v|数码管控制模块(用于显示得分)|
|Seg_7_Display.v|数码管底层驱动模块|
|uart_receiver.v|串口通信的底层驱动模块|
|VGA_data_selector.v|多个图像的VGA显示选择|
|VGA_driver.v|VGA显示驱动模块|

## 实物图

![实物图](https://i.loli.net/2019/01/20/5c43e633000f8.gif)
