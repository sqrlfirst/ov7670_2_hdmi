module hdmi_top(

);

    adv7513_init #(
        .CHIP_ADDR     (CHIP_ADDR     ),
        .I2C_CLKDIV    (I2C_CLKDIV    ),
        .I2C_TXN_DELAY (I2C_TXN_DELAY )
    ) u_adv7513_init (
            .clk   (clk   ),
            .reset (reset ),
            .sda   (sda   ),
            .scl   (scl   ),
            .start (start ),
            .done  (done  )
    );
    



endmodule 