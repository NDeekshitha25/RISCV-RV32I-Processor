
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_upperimm_inst(
    input logic [31:0] instruction_code,
    output logic [4:0] rd,
    output logic [31:0] imm,
    output logic [4:0] alu_control
);

// Edit the code here begin ---------------------------------------------------

    assign rd = instruction_code[11:7];
    assign imm = {instruction_code[31:12], 12'b0};

    always_comb begin 

        alu_control = `ALU_NOP;

        if(instruction_code[6:0] == `OP_LUI) alu_control = `LUI;

        if(instruction_code[6:0] == `OP_AUIPC) alu_control = `AUIPC;
    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_upperimm_inst.vcd");
        $dumpvars(0, decode_upperimm_inst);
    end
`endif

endmodule
