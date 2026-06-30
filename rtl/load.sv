`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module load(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] rs1_val,
    input logic [31:0] imm,
    input logic [31:0] mem_data,
    input logic [4:0] rd_in,
    input logic [2:0] load_control,
    output logic stall_pc,
    output logic ignore_curr_inst,
    output logic rd_write_control,
    output logic [4:0] rd_out,
    output logic [31:0] rd_write_val,
    output logic mem_rw_mode,
    output logic [31:0] mem_addr
);

// Edit the code here begin ---------------------------------------------------

assign mem_rw_mode = 1'b1 ;

logic [2:0] temp;
logic [2:0] test;
logic [31:0] temp_mem ;


    always @(*) begin 

        test = 0;
        stall_pc = 'b0;
        mem_addr = 'b0;
     
        case(load_control) 

            `LD_NOP : begin
                    stall_pc = 'b0;
                    mem_addr = 'b0;
                    end

            `LB :begin
                stall_pc = 'b1;
                mem_addr = rs1_val + imm;
                end   
     
            `LH :begin
                stall_pc = 'b1;
                mem_addr = rs1_val + imm;
                end

            `LW: begin
                stall_pc = 'b1;
                mem_addr = rs1_val + imm;
                end

            `LBU :begin
                stall_pc = 'b1;
                mem_addr = rs1_val + imm;
                end

            `LHU :begin
                stall_pc = 'b1;
                mem_addr = rs1_val + imm;   
                end

            default : begin
                stall_pc = 'b0;
                mem_addr = 'b0;
                end
   
    endcase

        if(rd_write_control == 1'b1)  begin
        
            if(temp ==`LD_NOP )rd_write_val = 'b0; 

            else if(temp ==`LB) begin 

                test = `LB;

                if(temp_mem[1:0] == 2'd0) rd_write_val = {{24{mem_data[7]}},mem_data[7:0]};
                else if(temp_mem[1:0] == 2'd1) rd_write_val = {{24{mem_data[15]}},mem_data[15:8]};
                else if(temp_mem[1:0] == 2'd2) rd_write_val = {{24{mem_data[23]}},mem_data[23:16]};
                else rd_write_val = {{24{mem_data[31]}},mem_data[31:24]};
            end
     

            else if(temp ==`LH) begin

                test = `LH;

                if(temp_mem[1:0] == 2'd1 || temp_mem[1:0] == 2'd0) rd_write_val = {{16{mem_data[15]}},mem_data[15:0]};
                else rd_write_val = {{16{mem_data[31]}},mem_data[31:16]};
            end
     

            else if(temp ==`LW ) begin 
                rd_write_val = mem_data ;
                test = `LW;

            end
     

            else if(temp ==`LBU) begin

                test = `LBU;

                if(temp_mem[1:0] == 2'd0) rd_write_val = {24'd0,mem_data[7:0]};
                else if(temp_mem[1:0] == 2'd1) rd_write_val = {24'd0,mem_data[15:8]};
                else if(temp_mem[1:0] == 2'd2) rd_write_val = {24'd0,mem_data[23:16]};
                else rd_write_val = {24'd0,mem_data[31:24]};
            end
     
            else if (temp ==`LHU) begin

                test = `LHU;

                if(temp_mem[1:0] == 2'd1 || temp_mem[1:0] == 2'd0) rd_write_val = {16'd0,mem_data[15:0]};
                else rd_write_val = {16'd0,mem_data[31:16]};
            end
     
            else rd_write_val = 'b0;
        
        end

        else rd_write_val = 'b0;

    end
    
    always @(posedge i_clk) begin 

        if(!i_rst) begin 

            ignore_curr_inst <= 1'b0 ;
            rd_out <= 'b0;
            rd_write_control <= 'b0;
            temp = 'b0;
            temp_mem <= 'b0;

        end

        else if(load_control != 0 && load_control != 3'd6 && load_control != 3'd7) begin

            ignore_curr_inst <=  1'b1 ;
            rd_out <= rd_in ;
            rd_write_control <= 'b1 ;
            temp <= load_control ;
            temp_mem <= mem_addr;
            
        end
        
        else begin
            
            ignore_curr_inst <= 1'b0;
            rd_out <= 'b0 ;
            rd_write_control <= 'b0;
            temp <= 'b0;
            temp_mem <= 'b0;

        end
        
    end
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/load.vcd");
        $dumpvars(0, load);
    end
`endif

endmodule