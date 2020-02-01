module camera_top 
        (
           input                iclk_100M,      // system clock 100Mhz
           input                ipclk    ,
           input                ivsync   ,
           input                ihref    ,
           input [7:0]          idata    ,
           // input                iclk_sccb,
           input                ireset   ,
           inout                isio_d   ,
           input                istart   ,
           output               owr_en   ,
           output [18:0]        oaddr    ,
           output [23:0]        odata_out,
           output               opwdn    ,
           output               osio_c   ,
           output               odone
        );

    import top_package::SCCB_CLKDIV;
    import top_package::CHIP_ADDR  ;

	logic [9:0]			main_clk_div_cnt = 10'd0; // [5:0] - div 100 [9:6] - div 10
	logic				clk_sccb;

    ov_7670_capture u_ov_7670_capture (
        .pclk            ( ipclk     ),
        .vsync           ( ivsync    ),
        .href            ( ihref     ),
        .data            ( idata     ),
        .addr            ( oaddr     ),
        .data_out        ( odata_out ),
        .write_en        ( owr_en    ),
    );

    ov_7670_init #(
        .SCCB_CLKDIV  ( SCCB_CLKDIV  ),
        .CHIP_ADDR    ( CHIP_ADDR    )
        )  u_ov_7670_init (
            .clk            ( iclk_100M ),
            .clk_sccb       ( clk_sccb ),
            .reset          ( ireset    ),
            .pwdn           ( opwdn     ),
            .sio_d          ( isio_d    ),
            .sio_c          ( osio_c    ),
            .start          ( istart    ),
            .done           ( odone     )
    );

    always_ff @( posedge iclk_100M ) begin 
		
		if ( main_clk_div_cnt < 10'd999 ) begin
			main_clk_div_cnt <= main_clk_div_cnt + 10'd1;
		end 
		else begin
			main_clk_div_cnt <= 10'd0;
		end

		case ( main_clk_div_cnt )
			10'd0  : clk_sccb = 1'b0;
			10'd500: clk_sccb = 1'b1;
		endcase

	end    
    

endmodule