module tb_pip_processor;

    reg clk;
    reg reset;
    reg [31:0] instruction;
    wire [31:0] result;

    // Instantiate the pipelined processor
    pip_processor uut (
        .clk(clk),
        .reset(reset),
        .instruction(instruction),
        .result(result)
    );

    // Clock generation: toggles every 5 time units
    always #5 clk = ~clk;

    // Function to generate 32-bit instruction
    function [31:0] make_instr;
        input [3:0] opcode, rd, rs1, rs2;
        begin
            make_instr = {opcode, rd, rs1, rs2, 16'b0};  // Custom instruction format
        end
    endfunction

    initial begin
        $display("Starting Testbench...");
        clk = 0;
        reset = 1;
        instruction = 32'b0;

        // Monitor to display changes dynamically
        $monitor("Time=%0t | clk=%b | instruction=%h | result=%0d",
                  $time, clk, instruction, result);

        // Hold reset for some time
        #10 reset = 0;

        // Initialize registers manually (in DUT)
        uut.regfile[2] = 10;  // R2 = 10
        uut.regfile[3] = 5;   // R3 = 5
        uut.regfile[5] = 20;  // R5 = 20
        uut.regfile[6] = 4;   // R6 = 4
        uut.regfile[8] = 42;  // R8 = 42 (for LOAD)

        // ADD R1 = R2 + R3 => 10 + 5 = 15
        #10 instruction = make_instr(4'b0001, 4'd1, 4'd2, 4'd3);

        // SUB R4 = R5 - R6 => 20 - 4 = 16
        #10 instruction = make_instr(4'b0010, 4'd4, 4'd5, 4'd6);

        // LOAD R7 = R8 => 42
        #10 instruction = make_instr(4'b0011, 4'd7, 4'd8, 4'd0);

        // Wait for pipeline to finish
        #100;

        // Final results in decimal
        $display("\n----------------------------");
        $display("Final Register Values:");
        $display("R1 (ADD Result)  = %0d", uut.regfile[1]);  // Expected: 15
        $display("R4 (SUB Result)  = %0d", uut.regfile[4]);  // Expected: 16
        $display("R7 (LOAD Result) = %0d", uut.regfile[7]);  // Expected: 42
        $display("----------------------------");

        $finish;
    end

endmodule
