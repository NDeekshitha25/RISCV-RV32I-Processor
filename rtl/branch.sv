`ifndef FILE_INCL
    `include "processor_defines.sv"
`endif

module branch(
    input logic i_clk,
    input logic i_rst,
    input logic [31:0] pc_prev,
    input logic [31:0] imm,
    input logic [31:0] rs1_val,
    input logic [31:0] rs2_val,
    input logic [2:0] branch_control,
    output logic pc_update_control,
    output logic [31:0] pc_update_val,
    output logic ignore_curr_inst
);

// Edit the code here begin ---------------------------------------------------

  /*  assign pc_update_control = 'b0;
    assign pc_update_val = 'b0;
    assign ignore_curr_inst = 'b0; */

    

    logic temp;

    always @(*) begin 
        pc_update_control = 1'b0;
        pc_update_val='b0;
        temp =1'b0;

        if(branch_control== `BR_NOP) begin 
    
        pc_update_control ='b0;
        pc_update_val= 'b0;
        temp =1'b0;
        
        
        end
        else if(branch_control==`BEQ) begin
        //    if($signed(rs1_val)==$signed(rs2_val)) begin
             if((rs1_val)==(rs2_val)) begin
            pc_update_control = 1'b1;
            pc_update_val = pc_prev + imm ;
            temp=1'b1;
            end
            else begin 
            pc_update_control = 1'b0; 
            pc_update_val = 'b0;
            temp=1'b0;
             end
        end
        else if(branch_control==`BGE) begin
            if($signed(rs1_val) >= $signed(rs2_val)) begin
            pc_update_control = 1'b1;
            pc_update_val = pc_prev + imm ;
            temp=1'b1;
            end
            else begin pc_update_control = 1'b0; 
            pc_update_val = 'b0; 
            temp= 1'b0;end
        end
        else if(branch_control==`BLT) begin
            if($signed(rs1_val)<$signed(rs2_val)) begin
            pc_update_control = 1'b1;
            pc_update_val = pc_prev + imm ;
            temp=1'b1;
            end
            else begin pc_update_control = 1'b0; 
            pc_update_val = 'b0;
            temp =1'b0; end
        end
        else if(branch_control==`BNE) begin
            if($signed(rs1_val)!=$signed(rs2_val)) begin
            pc_update_control = 1'b1;
            pc_update_val = pc_prev + imm ;
            temp=1'b1;
            end
            else begin pc_update_control = 1'b0; 
            pc_update_val = 'b0; 
            temp =1'b0;end
        end
        else if(branch_control==`BGEU) begin
            if(rs1_val>=rs2_val) begin
            pc_update_control = 1'b1;
            pc_update_val = pc_prev + imm ;
            temp=1'b1;
            end
            else begin pc_update_control = 1'b0; 
            pc_update_val = 'b0;
            temp =1'b0; end
        end
        else if(branch_control==`BLTU) begin
            if(rs1_val<rs2_val) begin
            pc_update_control = 1'b1;
            pc_update_val = pc_prev + imm ;
            temp=1'b1;
            end
            else begin pc_update_control = 1'b0; 
            pc_update_val = 'b0;
            temp =1'b0; end
        end
    end
    always @(posedge i_clk) begin 
        if(!i_rst) ignore_curr_inst <= 1'b0 ;
        
        else if(temp) begin
            ignore_curr_inst<=  1'b1 ;
            
        end
        
        else begin
            ignore_curr_inst <= 1'b0;
        end

        
        
    end
    
    
// Edit the code here end -----------------------------------------------------

/*
	Following section is necessary for dumping waveforms. This is needed for debug and simulations
*/

`ifndef SUBMODULE_DISABLE_WAVES
    initial begin
        $dumpfile("./sim_build/branch.vcd");
        $dumpvars(0, branch);
    end
`endif

endmodule
