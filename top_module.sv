module top_module(
    // clocks
    input                       iclk_125M_p,        // PIN u12  lvds
    input                       iclk_125M_n,        // PIN v12  lvds
    input                       iclk_50M_b5b,       // PIN r20  3.3v
    input                       iclk_50M_b6a,       // PIN n20  3.3v
    input                       iclk_50M_b7a,       // PIN h12  2.5v
    input                       iclk_50M_b8a,       // PIN m10  2.5v
    // 
    // input                       iclk_ref_clkp0,     // PIN v6
    // input                       iclk_ref_clkn0,     // PIN w6
    // input                       iclk_ref_clkp1,     // PIN n7
    // input                       iclk_ref_clkn1,     // PIN p6
    // SI5338 control
    output                      osi5338_i2c_scl,    // PIN b7
    inout                       iosi5338_i2c_sda,   // PIN g11

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
    input [7:0]                 icam_data,          // GPIO pins 2..9
                                                    // pin  E26     K25     M26     K26     P20     M21     T19     T22
                                                    //      D0(3)   D1(2)   D2(5)   D3(4)   D4(7)   D5(6)   D6(9)   D7(8) 
    output                      ocam_sioc ,         // GPIO16 pin F26 
    inout                       iocam_siod,         // GPIO17 pin Y9
    input                       icam_vsync,         // GPIO14 pin R9
    input                       icam_href ,         // GPIO15 pin R10
    input                       icam_pclk ,         // GPIO12 pin P8                           
    output                      ocam_xclk ,         // GPIO13 pin R8               system clock output = 24 MHz - goes to camera
    output                      ocam_rst  ,         // GPIO0  pin T21
    output                      ocam_pwdn           // GPIO1  pin D26 

);


    // OV7670

logic                            w100MHz;
logic                            w150MHz;
logic [18:0]                     waddr;
logic [23:0]                     wdata_out;
logic                            wwr_en;

logic [7:0]                       r_counter = '0;
logic                             r400KHz;        // maybe 400 is required?

logic                            wpwdn;
logic                            wsio_c;
logic                            wsio_d;
logic                            wdone;
logic                            wstart;
logic                             rreset = 1'b1;
logic                             rstart = 1'b0;


    camera_top(
    	.ipclk              ( icam_pclk     ),        // Camera frequency 24MHz
        .ivsync             ( icam_vsync    ),
        .ihref              ( icam_href     ),
        .idata              ( icam_data     ),
        .iclk_100M          ( w100MHz       ),           // Not sure
        // .iclk_sccb          (        ),                 // Clock for SCCB protocol (100kHz to 400kHz)
        .ireset             ( rreset        ),           // Async reset signal - should be described in top_module  
        .isio_d             ( iocam_siod    ),
        .osio_c             ( ocam_sioc     ),

        .istart             ( rstart        ),
        .owr_en             ( wwr_en        ),
        .oaddr              ( waddr         ),
        .odata_out          ( wdata_out     ),
        .opwdn              ( ocam_pwdn     ),
        .odone              ( wdone         )            // Means, that camera initialization is done
    );

    // pll 
    // c0   24   Mhz 
    // c1   100  Mhz
    // c2   150  Mhz
    pll_24Mhz (                         
		.refclk             ( iclk_50M_b5b ),          
		.rst                (  ),   
		.outclk_0           ( ocam_xclk    ), 
		.outclk_1           ( w100MHz      ), 
		.outclk_2           ( w150MHz      ),
		.locked             (              ) 
	);


endmodule 