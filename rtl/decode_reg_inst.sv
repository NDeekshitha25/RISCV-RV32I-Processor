`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module decode_reg_inst(
    input logic [31:7] instruction_code,
    output logic [4:0] rs1,
    output logic [4:0] rs2,
    output logic [4:0] rd,
    output logic [4:0] alu_control
);

// Edit the code here begin ---------------------------------------------------

    assign rs1 = instruction_code[19:15];
    assign rs2 = instruction_code[24:20];
    assign rd = instruction_code[11:7];

always_comb begin
    alu_control = `ALU_NOP;

    if(instruction_code[14:12] == 3'h0x0 && instruction_code[31:25] == 7'h0x00) alu_control = `ADD;
    if(instruction_code[14:12] == 3'h0x0 && instruction_code[31:25] == 7'h0x20) alu_control = `SUB;
    if(instruction_code[14:12] == 3'h0x4 && instruction_code[31:25] == 7'h0x00) alu_control = `XOR;
    if(instruction_code[14:12] == 3'h0x6 && instruction_code[31:25] == 7'h0x00) alu_control = `OR;
    if(instruction_code[14:12] == 3'h0x7 && instruction_code[31:25] == 7'h0x00) alu_control = `AND;
    if(instruction_code[14:12] == 3'h0x1 && instruction_code[31:25] == 7'h0x00) alu_control = `SLL;
    if(instruction_code[14:12] == 3'h0x5 && instruction_code[31:25] == 7'h0x00) alu_control = `SRL;
    if(instruction_code[14:12] == 3'h0x5 && instruction_code[31:25] == 7'h0x20) alu_control = `SRA;
    if(instruction_code[14:12] == 3'h0x2 && instruction_code[31:25] == 7'h0x00) alu_control = `SLT;
    if(instruction_code[14:12] == 3'h0x3 && instruction_code[31:25] == 7'h0x00) alu_control = `SLTU;

end

// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/decode_reg_inst.vcd");
        $dumpvars(0, decode_reg_inst);
    end
`endif

endmodule
