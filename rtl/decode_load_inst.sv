
`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_load_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rd,
    output logic [11:0] imm,
    output logic [2:0] load_control
);

// Edit the code here begin ---------------------------------------------------

    assign rs1 = instruction_code[19:15];
    assign rd = instruction_code[11:7];
    assign imm = instruction_code[31:20];
    
    always_comb begin 

        load_control = `LD_NOP;

        if(instruction_code[14:12] == 3'h0x0) load_control = `LB;
        if(instruction_code[14:12] == 3'h0x1) load_control = `LH;
        if(instruction_code[14:12] == 3'h0x2) load_control = `LW;
        if(instruction_code[14:12] == 3'h0x4) load_control = `LBU;
        if(instruction_code[14:12] == 3'h0x5) load_control = `LHU;

    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_load_inst.vcd");
        $dumpvars(0, decode_load_inst);
    end
`endif

endmodule
