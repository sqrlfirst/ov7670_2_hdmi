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
    output reg [pOUT_DATA_W-1:0]        odata_wr,                                   //is it nessesary?    
    output [lpC2_OUT_BYTES_NUM-1:0]     oaddr_wr,
    output                              omem_wr_en,
    // comtrol module
    input [pIN_DATA_W-1:0]              idata_start_ptr,              
    input                               istart_work,
    output reg                          omodule_work_f,                             // from lpREAD to lpFINISH;          
    output reg                          omodule_done_f,                             // 1 clock

);

    localparam  lpIN_BYTES_NUM    = pIN_IM_HEIGHT * pIN_IM_WIDTH   ;                //not sure about localparams in input
    localparam  lpC2_IN_BYTES_NUM = $clog2(lpIN_BYTES_NUM)         ;
    localparam  lpOUT_BYTES_NUM    = pOUT_IM_HEIGHT * pOUT_IM_WIDTH;
    localparam  lpC2_OUT_BYTES_NUM = $clog2(lpOUT_BYTES_NUM)       ;

     localparam lpWAIT = 3'b000,
                lpREAD = 3'b001,
                lpSUM_8 = 3'b010,
                lpSUM_4  = 3'b011,
                lpSUM_2 = 3'b100,
                lpFINISH = 3'b101;

    logic [2:0]       					r_state_reg = lpWAIT;
    logic [2:0]       					r_state_next = lpREAD;

    logic [4][4][pIN_DATA_W-1:0]        r_mem_work;
    logic [pIN_DATA_W-1:0]              r_start_pointer;
    logic [pIN_DATA_W-1:0]              r_addr_read;

    logic [1:0]                         r_mem_i = 2'b00;
    logic [1:0]                         r_mem_j = 2'b00;
    logic [7:0][pIN_DATA_W:0]           r_mean_8;   
    logic [3:0][pIN_DATA_W:0]           r_mean_4; 
    logic [1:0][pIN_DATA_W:0]           r_mean_2;              

     always @* begin
            case(r_state_reg)
                lpWAIT:     	        r_state_next <= lpREAD;
                lpREAD:     	        r_state_next <= lpSUM_8;
                lpSUM_8:      	        r_state_next <= lpSUM_4;
                lpSUM_4:       	        r_state_next <= lpSUM_2;
                lpSUM_2:       	        r_state_next <= lpFINISH;
                lpFINISH:     	        r_state_next <= lpWAIT;
            endcase  
        end  


    always_ff @( posedge iclk ) begin               //: ReadInMem
        case (r_state_reg) begin
            (lpWAIT):   begin
                        omodule_done_f <= 1'b0;
                        if (istart_work == 1'b1) begin
                                r_state_reg <= r_state_next;
                                omodule_work_f <= 1'b1;
                                r_start_pointer <= idata_start_ptr;
                        end
                        end
            (lpREAD):   begin
                            case (r_mem_i) begin
                                (2'b00): begin case (r_mem_j) begin
                                            (2'b00): begin 
                                                        r_mem_work [0] [0] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                        r_addr_read <= r_start_pointer + 1'b1;
                                                    end
                                            (2'b01):  begin
                                                        if (istart_work == 1'b1) begin
                                                            r_mem_work [0] [1] <= idata_rd;
                                                            r_mem_j <= r_mem_j + 1'b1;
                                                            r_addr_read <= r_addr_read + 1'b1;
                                                        end
                                                    end
                                            (2'b10):  begin
                                                        if (istart_work == 1'b1) begin
                                                            r_mem_work [0] [2] <= idata_rd;
                                                            r_mem_j <= r_mem_j + 1'b1;
                                                            r_addr_read <= r_addr_read + 1'b1;
                                                        end
                                                    end
                                            (2'b11):  begin
                                                        if (istart_work == 1'b1) begin
                                                            r_mem_work [0] [3] <= idata_rd;
                                                            r_mem_j <= r_mem_j + 1'b1;
                                                            r_mem_i <= r_mem_i + 1'b1;
                                                            //r_addr_read <= r_addr_read + 1'b1;
                                                        end
                                                    end
                                        end
                                end
                                (2'b01): begin case (r_mem_j) begin
                                            (2'b00): begin 
                                                        r_mem_work [1] [0] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b01):  begin
                                                        r_mem_work [1] [1] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b10):  begin
                                                        r_mem_work [1] [2] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b11):  begin
                                                        r_mem_work [1] [3] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                        r_mem_i <= r_mem_i + 1'b1;
                                                    end
                                        end
                                end
                                (2'b10): begin case (r_mem_j) begin
                                            (2'b00): begin 
                                                        r_mem_work [2] [0] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b01):  begin
                                                        r_mem_work [2] [1] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b10):  begin
                                                        r_mem_work [2] [2] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b11):  begin
                                                        r_mem_work [2] [3] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                        r_mem_i <= r_mem_i + 1'b1;
                                                    end
                                        end
                                end
                                (2'b11): begin case (r_mem_j) begin
                                            (2'b00): begin 
                                                        r_mem_work [3] [0] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b01):  begin
                                                        r_mem_work [3] [1] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b10):  begin
                                                        r_mem_work [3] [2] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                    end
                                            (2'b11):  begin
                                                        r_mem_work [3] [3] <= idata_rd;
                                                        r_mem_j <= r_mem_j + 1'b1;
                                                        r_mem_i <= r_mem_i + 1'b1;
                                                        r_state_reg <= r_state_next;
                                                    end
                                        end
                                end
                            end
                        end
            (lpSUM_8): begin
                        r_mean_8 [0] <= 1>>(r_mem_work [0] [0] + r_mem_work [0] [1]) ;
                        r_mean_8 [1] <= 1>>(r_mem_work [0] [2] + r_mem_work [0] [3]) ;
                        r_mean_8 [2] <= 1>>(r_mem_work [1] [0] + r_mem_work [1] [1]) ;
                        r_mean_8 [3] <= 1>>(r_mem_work [1] [2] + r_mem_work [1] [3]) ;
                        r_mean_8 [4] <= 1>>(r_mem_work [2] [0] + r_mem_work [2] [1]) ;
                        r_mean_8 [5] <= 1>>(r_mem_work [2] [2] + r_mem_work [2] [3]) ;
                        r_mean_8 [6] <= 1>>(r_mem_work [3] [0] + r_mem_work [3] [1]);
                        r_mean_8 [7] <= 1>>(r_mem_work [3] [2] + r_mem_work [3] [3]);
                        r_state_reg <= r_state_next;
            end
            (lpSUM_4): begin
                        r_mean_4 [0] <= 1>>(r_mean_8 [0] + r_mean_8 [1]) ;
                        r_mean_4 [1] <= 1>>(r_mean_8 [2] + r_mean_8 [3]) ;
                        r_mean_4 [2] <= 1>>(r_mean_8 [4] + r_mean_8 [5]) ;
                        r_mean_4 [3] <= 1>>(r_mean_8 [6] + r_mean_8 [7]) ;
                        r_state_reg <= r_state_next;
            end
            (lpSUM_2):  begin
                        r_mean_2 [0] <= 1>>(r_mean_4 [0] +  r_mean_4 [1]);
                        r_mean_2 [1] <= 1>>(r_mean_4 [2] +  r_mean_4 [3]);
                        r_state_reg <= r_state_next;
            end
            (lpFINISH): begin
                        odata_wr <= 1>>(r_mean_2 [0] + r_mean_2 [1]);
                        r_state_reg <= r_state_next;
                        omodule_work_f <= 1'b0;
                        omodule_done_f <= 1'b1; 
            end
        end
    end

    assign oaddr_rd = r_addr_read;


endmodule