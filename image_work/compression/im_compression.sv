module im_compression #(
    parameter pIN_IM_WIDTH   = 640,
    parameter pIN_IM_HEIGHT  = 480,
    parameter pOUT_IM_WIDTH  = 160,
    parameter pOUT_IM_HEIGHT = 120,

    parameter pIN_DATA_W  = 24,
    parameter pOUT_DATA_W = 24,
)(
    input                               iclk,
    input                               irst,
    // reading im
    input  [pIN_DATA_W-1:0]             idata_rd,
    output [lpC2_IN_BYTES_NUM-1:0]      oaddr_rd,
    output                              omem_rd_en,
    // writing im
    output [pOUT_DATA_W-1:0]            odata_wr,
    output [lpC2_OUT_BYTES_NUM-1:0]     oaddr_wr,
    output                              omem_wr_en,
    // comtrol module
    input [pIN_DATA_W-1:0]              idata_start_ptr,              
    input                               istart_work,
    output                              omodule_work_f,
    output                              omodule_done_f,

);

    localparam  lpIN_BYTES_NUM    = pIN_IM_HEIGHT * pIN_IM_WIDTH   ;
    localparam  lpC2_IN_BYTES_NUM = $clog2(lpIN_BYTES_NUM)         ;
    localparam  lpOUT_BYTES_NUM    = pOUT_IM_HEIGHT * pOUT_IM_WIDTH;
    localparam  lpC2_OUT_BYTES_NUM = $clog2(lpOUT_BYTES_NUM)       ;

    logic [4][4][pIN_DATA_W-1:0]        mem_work;

    always_ff @( posedge iclk ) begin : ReadInMem
        
    end

    always_ff @( posedge iclk ) begin : CalculatingMean
        
    end


endmodule