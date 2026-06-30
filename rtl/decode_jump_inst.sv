
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_jump_inst(
    input logic [31:0] instruction_code,
    output logic [4:0] rd,
    output logic [4:0] rs1,
    output logic [31:0] imm,
    output logic [1:0] jump_control
);

// Edit the code here begin ---------------------------------------------------

    assign rd = instruction_code[11:7];
    

    always_comb begin
        
        jump_control = `JMP_NOP;
        imm = '0;
        rs1 = '0;
        if(instruction_code[6:0] == `OP_JAL) begin
            imm[20:1] =  {instruction_code[31], instruction_code[19:12], instruction_code[20], instruction_code[30:21]}; 
            imm[31:21] = {11{instruction_code[31]}};
            jump_control = `JAL;
        end

        if(instruction_code[6:0] == `OP_JALR && instruction_code[14:12] == 3'b0) begin
            rs1 = instruction_code[19:15];
            imm[11:0] = instruction_code[31:20];
            imm[31:12] = {20{instruction_code[31]}};
            jump_control = `JALR;
        end

    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_jump_inst.vcd");
        $dumpvars(0, decode_jump_inst);
    end
`endif

endmodule
