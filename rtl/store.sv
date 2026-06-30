
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module store(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [31:0] imm,
    input logic [2:0] store_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr,
    output logic [31:0] mem_write_data,
    output logic [3:0] mem_byte_en
);

// Edit the code here begin ---------------------------------------------------

    always_comb begin
    
        mem_write_data = 32'd1;
        stall_pc = '0;
        mem_rw_mode = '0;
        mem_byte_en = '0;
        mem_addr = rs1_val + imm;

        case(store_control) 

            `SW : begin
                    stall_pc = 1'b1;
                    mem_rw_mode = 1'b0;
                    mem_write_data = rs2_val;
                    mem_byte_en = 4'b1111;
                end
            
            `SH : begin
                    stall_pc = 1'b1;
                    mem_rw_mode = 1'b0;
                    mem_write_data = mem_addr[1] ? {rs2_val[15:0], 16'b0} : {16'b0, rs2_val[15:0]};
                    mem_byte_en = mem_addr[1] ? 4'b1100 : 4'b0011;
                end

            `SB : begin
                    stall_pc = 1'b1;
                    mem_rw_mode = 1'b0;
                    mem_write_data = rs2_val[7:0] << (mem_addr[1:0] * 8);
                    mem_byte_en = 4'b0001 << mem_addr[1:0];
                end

            default : begin
                    stall_pc = 1'b0;
                    mem_rw_mode = 1'b1;
                    mem_addr = '0;
                    mem_write_data = '0;
                    mem_byte_en = '0;
                end

        endcase
        
    end

    always_ff @(posedge i_clk or negedge i_rst) begin
        
        if(!i_rst) begin
            ignore_curr_inst <= 1'b0;
        end
        else begin
            if(store_control == `SW || store_control == `SB || store_control == `SH) ignore_curr_inst <= 1'b1;
            else ignore_curr_inst <= 1'b0;
        end

    end


// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/store.vcd");
        $dumpvars(0, store);
    end
`endif

endmodule
