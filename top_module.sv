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
    input                       icam_href ,         // GPIO1camera_top  3 pin r8
    input                       icam_pclk ,         // GPIO14 pin r9                           
    output                      ocam_xclk ,         // GPIO15 pin r10               system clock output = 24 MHz - goes to camera
    output                      ocam_rst  ,         // GPIO24 pin u20               // not used
    output                      ocam_pwdn           // GPIO25 pin v22

);


    // OV7670

wire                            w100MHz;
wire                            w150MHz;
wire [18:0]                     waddr;
wire [23:0]                     wdata_out;
wire                            wwr_en;

reg [7:0]                       r_counter = '0;
reg                             r400KHz;        // maybe 400 is required?

wire                            wpwdn;
wire                            wsio_c;
wire                            wsio_d;
wire                            wdone;
wire                            wstart;
reg                             rreset = 1'b0;
reg                             rstart = 1'b1;


 camera_top(
    	.ipclk              (icam_pclk        ),        // Camera frequency 24MHz
        .ivsync             (icam_vsync    ),
        .ihref              (icam_href     ),
        .idata              (icam_data     ),
        .iclk               (w150MHz       ),           // Not sure
        .iclk_sccb          (r100KHz ),                 // Clock for SCCB protocol (100kHz to 400kHz)
        .ireset             (rreset        ),           // Async reset signal - should be described in top_module  
        .isio_d             (iocam_siod    ),
        .istart             (rstart    ),
        .owr_en             (wwr_en    ),
        .oaddr              (waddr     ),
        .odata_out          (wdata_out ),
        .opwdn              (ocam_pwdn     ),
        .osio_c             (ocam_sioc    ),
        .odone              (wdone     )            // Means, that camera initialization is done
    );

    // pll 
    // c0   24   Mhz 
    // c1   100  Mhz
    // c2   150  Mhz
    pll_24Mhz (                         
		.refclk             ( ipclk),          
		.rst                ( ),   
		.outclk_0           (ocam_xclk ), 
		.outclk_1           (w100MHz), 
		.outclk_2           (w150MHz),
		.locked             ( ) 
	);

<<<<<<< HEAD
    // OV7670

    camera_top u_camera_top(
    	.ipclk          (  ),
        .ivsync         (  ),
        .ihref          (  ),
        .idata          (  ),
        .iclk           (  ),
        .iclk_sccb      (  ),
        .ireset         (  ),
        .isio_d         (  ),
        .istart         (  ),
        .owr_en         (  ),
        .oaddr          (  ),
        .odata_out      (  ),
        .opwdn          (  ),
        .osio_c         (  ),
        .odone          (  )
    );
    
    


=======
always @(posedge w100MHz)
begin
    if (r_counter == 8'd249) begin
        r_counter <= 8'd0;
        r100KHz <= 1'b1;
    end
    else 
    begin 
        r_counter <= r_counter + 1'b1;
        r100KHz <= 1'b0;
    end
end
>>>>>>> e8600b98e37a4372ae8490f8df5342999d78040b

endmodule 