module top_module(
    // clocks
    input                       iclk_125M_p,        // PIN u12  lvds
    input                       iclk_125M_n,        // PIN v12  lvds
    input                       iclk_50M_b5b,       // PIN r20  3.3v
    input                       iclk_50M_b6a,       // PIN n20  3.3v
    input                       iclk_50M_b7a,       // PIN h12  2.5v
    input                       iclk_50M_b8a,       // PIN m10  2.5v
    // 
    input                       iclk_ref_clkp0,     // PIN v6
    input                       iclk_ref_clkn0,     // PIN w6
    input                       iclk_ref_clkp1,     // PIN n7
    input                       iclk_ref_clkn1,     // PIN p6
    // SI5338 control
    output                      osi5338_i2c_scl,    // PIN b7
    inout                       iosi5338_i2c_sda,   // PIN g11

    // OV7670 - camera

    input                       ipclk,
    input                       ivsync,
    input                       ihref,
    input [7:0]                 idata,

    // HDMI PHY interface ADV7513
    output [23:0]               ohdmi_tx_d   ,      // PIN  v23  aa26 w25  w26  v24  v25  u24  t23  t24  t26  r23   r25
                                                    // line 0    1    2    3    4    5    6    7    8    9    10    11                
                                                    // PIN  p22  p23  n25  p26  p21  r24  r26  ab26 aa24 ab25 ac25  ad25
                                                    // line 12   13   14   15   16   17   18   19   20   21   22    23  
    output                      ohdmi_tx_clk ,      // PIN  y25
    output                      ohdmi_tx_de  ,      // PIN  y26
    output                      ohdmi_tx_hs  ,      // PIN  u26
    output                      ohdmi_tx_vs  ,      // PIN  u25
    input                       ohdmi_tx_int ,      // PIN  t12
    inout                       ohdmi_i2c_sda,      // PIN  b7  
    output                      ohdmi_i2c_scl,      // PIN  g11
    // Micro SD
    output                      omicro_sd_clk,      // PIN  ab6 
    inout                       omicro_sd_cmd,      // PIN  w8 
    inout  [3:0]                omicro_sd_dat,      // PIN  u7  t7  v8  t8         
                                                    // line 0   1   2   3

    // camera interface OV7670
    input [7:0]                 icam_data,          // GPIO pins 16..23
                                                    // pin  ad6     ad7     aa6     aa7     y8      g26     y9      f26    
                                                    //      D0(23)  D1(22)  D2(21)  D3(20)  D4(19)  D5(18)  D6(17)  D7(16) 
    output                      ocam_sioc ,         // GPIO10 pin u19 
    inout                       iocam_siod,         // GPIO11 pin u22
    input                       icam_vsync,         // GPIO12 pin p8
    input                       icam_href ,         // GPIO13 pin r8
    input                       icam_pclk ,         // GPIO14 pin r9
    output                      ocam_xclk ,         // GPIO15 pin r10
    output                      ocam_rst  ,         // GPIO24 pin u20
    output                      ocam_pwdn           // GPIO25 pin v22

);

    // pll 
    // c0   24   Mhz 
    // c1   100  Mhz
    // c2   150  Mhz
    pll_24Mhz (
		.refclk             ( ),   
		.rst                ( ),   
		.outclk_0           ( ), 
		.outclk_1           ( ), 
		.outclk_2           ( ),
		.locked             ( ) 
	);

    // OV7670




endmodule 