module pip_processor (
    input clk,
    input reset,
    input [31:0] instruction,  // format: [31:28] opcode, [27:24] rd, [23:20] rs1, [19:16] rs2/immediate
    output reg [31:0] result
);

// Register file (16 registers)
reg [31:0] regfile [0:15];

// Pipeline registers
reg [31:0] IF_instr, ID_instr;
reg [31:0] EX_result;
reg [31:0] MEM_result;

// Instruction fields
reg [3:0] opcode, rd, rs1, rs2;
reg [31:0] op1, op2;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        IF_instr <= 32'b0;
        ID_instr <= 32'b0;
        EX_result <= 32'b0;
        MEM_result <= 32'b0;
        result <= 32'b0;
    end else begin
        // Fetch Stage (IF)
        IF_instr <= instruction;

        // Decode Stage (ID)
        ID_instr <= IF_instr;
        opcode <= IF_instr[31:28];
        rd     <= IF_instr[27:24];
        rs1    <= IF_instr[23:20];
        rs2    <= IF_instr[19:16];
        
        // Execute Stage (EX)
        case (opcode)
            4'b0001: EX_result <= regfile[rs1] + regfile[rs2];  // ADD
            4'b0010: EX_result <= regfile[rs1] - regfile[rs2];  // SUB
            4'b0011: EX_result <= regfile[rs1];                 // LOAD (simulate loading from reg)
            default: EX_result <= 32'b0;
        endcase

        // Memory Stage (MEM)
        MEM_result <= EX_result;

        // Write Back Stage (WB)
        regfile[rd] <= MEM_result;
        result <= MEM_result;
    end
end

endmodule
