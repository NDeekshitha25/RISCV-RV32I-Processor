
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_imm_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rd,
    output logic [11:0] imm,
    output logic [4:0] alu_control
);

// Edit the code here begin ---------------------------------------------------

    assign rs1 = instruction_code[19:15];
    assign rd = instruction_code[11:7];
    assign imm = instruction_code[31:20];

    always_comb begin 
        alu_control = `ALU_NOP;

        if(instruction_code[14:12] == 3'h0x0) alu_control = `ADDI;
        if(instruction_code[14:12] == 3'h0x4) alu_control = `XORI;
        if(instruction_code[14:12] == 3'h0x6) alu_control = `ORI;
        if(instruction_code[14:12] == 3'h0x7) alu_control = `ANDI;
        if(instruction_code[14:12] == 3'h0x1 && imm[11:5] == 7'h0x00) alu_control = `SLLI;
        if(instruction_code[14:12] == 3'h0x5 && imm[11:5] == 7'h0x00) alu_control = `SRLI;
        if(instruction_code[14:12] == 3'h0x5 && imm[11:5] == 7'h0x20) alu_control = `SRAI;
        if(instruction_code[14:12] == 3'h0x2) alu_control = `SLTI;
        if(instruction_code[14:12] == 3'h0x3) alu_control = `SLTIU;
    

    end

    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_imm_inst.vcd");
        $dumpvars(0, decode_imm_inst);
    end
`endif

endmodule
