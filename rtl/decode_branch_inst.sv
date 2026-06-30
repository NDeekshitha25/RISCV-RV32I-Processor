
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_branch_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [12:0] imm,
    output logic [2:0] branch_control
);

// Edit the code here begin ---------------------------------------------------

    assign rs1 = instruction_code[19:15];
    assign rs2 = instruction_code[24:20];
    assign {imm[12], imm[10:5]} = instruction_code[31:25];
    assign {imm[4:1], imm[11]} = instruction_code[11:7];
    assign imm[0]    = 1'b0;
    
    always_comb begin 

        branch_control = `BR_NOP;

        if(instruction_code[14:12] == 3'h0x0) branch_control = `BEQ;
        if(instruction_code[14:12] == 3'h0x1) branch_control = `BNE;
        if(instruction_code[14:12] == 3'h0x4) branch_control = `BLT;
        if(instruction_code[14:12] == 3'h0x5) branch_control = `BGE;
        if(instruction_code[14:12] == 3'h0x6) branch_control = `BLTU;
        if(instruction_code[14:12] == 3'h0x7) branch_control = `BGEU;

    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_branch_inst.vcd");
        $dumpvars(0, decode_branch_inst);
    end
`endif

endmodule
