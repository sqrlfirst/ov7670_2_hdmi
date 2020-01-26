module camera_top 
        (
           input                ipclk,
           input                ivsync,
           input                ihref,
           input [7:0]          idata,
           input                iclk,
           input                iclk_sccb,
           input                ireset,
           inout                isio_d,
           input                istart,
           output               owr_en,
           output [18:0]        oaddr,
           output [23:0]        odata_out,
           output               opwdn,
           output               osio_c,
           output               odone
        );

    ov_7670_capture (
           .pclk            (ipclk),
           .vsync           (ivsync),
           .href            (ihref),
           .data            (idata),
           .addr            (oaddr),
           .data_out        (odata_out),
           .write_en        (owr_en),
    );

    ov_7670_init
        (
            .clk            (iclk),
            .clk_sccb       (iclk_sccb),
            .reset          (ireset),
            .pwdn           (opwdn),
            .sio_d          (isio_d),
            .sio_c          (osio_c),
            .start          (istart),
            .done           (odone)
        );

    

endmodule