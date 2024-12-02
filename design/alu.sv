`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Yifan Xu
// 
// Create Date: 01/07/2018 10:23:43 PM
// Design Name: 
// Module Name: alu
// Project Name: 112L_Single_Path
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
//
// Revision: 0.07 - A better Shift Expression
// Revision: 0.06 - Re-write Output Zero to be the 0 digits of AluResult
// Revision: 0.05 - Add Support for >>>, modify comparation
// Revision: 0.04 - Add More Operations
// Revision: 0.03 - Add support for Jump
// Revision: 0.02 - Add support for Branch, no debug made, see note 2/23 03:31
// Revision: 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )
        (
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult
        );
    
        always_comb
        begin
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0001:        // OR
                    ALUResult = SrcA | SrcB;
            4'b0010:        // ADD
                    ALUResult = $signed(SrcA) + $signed(SrcB);
            4'b0011:        // XOR
                    ALUResult = SrcA ^ SrcB;
            4'b0100:        // Left Shift
                    ALUResult = SrcA << SrcB[4:0];
            4'b0101:        // Right Shift
                    ALUResult = SrcA >> SrcB[4:0];
            4'b0110:        // Subtract
                    ALUResult = $signed(SrcA) - $signed(SrcB);
            4'b0111:        // Right Shift Arithm
                    ALUResult = $signed(SrcA) >>> SrcB[4:0];

            4'b1000:        // Equal
                    ALUResult = (SrcA == SrcB) ? 1 : 0;
            4'b1001:        // Not Equal
                    ALUResult = (SrcA != SrcB) ? 1 : 0;
            4'b1100:        // Less Than
                    ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 1 : 0;
            4'b1101:        // Greater/Equal Than
                    ALUResult = ($signed(SrcA) >= $signed(SrcB)) ? 1 : 0;
            4'b1110:        // Unsigned Less Than
                    ALUResult = (SrcA < SrcB) ? 1 : 0;
            4'b1111:        // Unsigned Greater/Equal Than
                    ALUResult = (SrcA >= SrcB) ? 1 : 0;
            4'b1010:        // Always True, for jal
                    ALUResult = 1;
            default:
                    ALUResult = 0;
            endcase
        end

assert property (  //AND
    (Operation == 4'b0000) |-> (ALUResult == (SrcA & SrcB))
) else $error("ALU AND operation failed: ALUResult does not match SrcA & SrcB");

assert property (  //OR
    (Operation == 4'b0001) |-> (ALUResult == (SrcA | SrcB))
) else $error("ALU OR operation failed: ALUResult does not match SrcA | SrcB");

assert property (  //ADD
    (Operation == 4'b0010) |-> (ALUResult == ($signed(SrcA) + $signed(SrcB)))
) else $error("ALU ADD operation failed: ALUResult does not match SrcA + SrcB");

assert property (  //XOR
    (Operation == 4'b0011) |-> (ALUResult == (SrcA ^ SrcB))
) else $error("ALU XOR operation failed: ALUResult does not match SrcA ^ SrcB");

assert property (  //Left Shift
    (Operation == 4'b0100) |-> (ALUResult == (SrcA << SrcB[4:0]))
) else $error("ALU Left Shift operation failed: ALUResult does not match SrcA << SrcB[4:0]");

assert property (  //Right Shift
    (Operation == 4'b0101) |-> (ALUResult == (SrcA >> SrcB[4:0]))
) else $error("ALU Right Shift operation failed: ALUResult does not match SrcA >> SrcB[4:0]");

assert property (  //Subtract
    (Operation == 4'b0110) |-> (ALUResult == ($signed(SrcA) - $signed(SrcB)))
) else $error("ALU Subtract operation failed: ALUResult does not match SrcA - SrcB");

//assert property (  //Right Shift Arithm
    //(Operation == 4'b0111) |-> (ALUResult == ($signed(SrcA) >>> SrcB[4:0]))
//) else $error("ALU Right Shift Arithm operation failed: ALUResult does not match $signed(SrcA) >>> SrcB[4:0]");


assert property (  //Equal
    (Operation == 4'b1000) |-> (ALUResult == ((SrcA == SrcB) ? 1 : 0))
) else $error("ALU Equal operation failed: ALUResult does not match (SrcA == SrcB) ? 1 : 0");

assert property (  //Not Equal
    (Operation == 4'b1001) |-> (ALUResult == ((SrcA !== SrcB) ? 1 : 0))
) else $error("ALU Not Equal operation failed: ALUResult does not match (SrcA !== SrcB) ? 1 : 0");

assert property (  //Less Than
    (Operation == 4'b1100) |-> (ALUResult == (($signed(SrcA) < $signed(SrcB)) ? 1 : 0))
) else $error("ALU Less Than operation failed: ALUResult does not match ($signed(SrcA) < $signed(SrcB)) ? 1 : 0");

assert property (  //Greater/Equal Than
    (Operation == 4'b1101) |-> (ALUResult == (($signed(SrcA) >= $signed(SrcB)) ? 1 : 0))
) else $error("ALU Greater/Equal Than operation failed: ALUResult does not match ($signed(SrcA) >= $signed(SrcB)) ? 1 : 0");

assert property (  //Unsigned Less Than
    (Operation == 4'b1110) |-> (ALUResult == ((SrcA < SrcB) ? 1 : 0))
) else $error("ALU Unsigned Less Than operation failed: ALUResult does not match (SrcA < SrcB) ? 1 : 0");

assert property (  //Unsigned Greater/Equal Than
    (Operation == 4'b1111) |-> (ALUResult == ((SrcA >= SrcB) ? 1 : 0))
) else $error("ALU Unsigned Greater/Equal Than operation failed: ALUResult does not match (SrcA >= SrcB) ? 1 : 0");

assert property (  //jal
    (Operation == 4'b1010) |-> (ALUResult == 1)
) else $error("ALU jal operation failed: ALUResult does not match 1");

assert property (  //default
    (Operation == 4'b1011) |-> (ALUResult == 0)
) else $error("ALU default operation failed: ALUResult does not match 0");

endmodule

























