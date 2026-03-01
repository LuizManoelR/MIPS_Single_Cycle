/*====================================================
  Module: alu_ctrl
  Description:
    Controlador da ALU: Indica qual será a operação da ALU
 
   Inputs:
    aluOp        : Determina o tipo da instrução
    funct        : Caso a instrução seja do Rtype define a operação
  
   Outputs:
    entrada_ctrl : Informa a ALU qual será a operação
=======================================================*/

module alu_ctrl(

    input [1:0] aluOp,
    input [5:0] funct,

    output reg [3:0] entrada_ctrl

);

    //Paramentros locais do Opcode e funct

    localparam and_op = 4'b0000; //and
    localparam or_op  = 4'b0001;//or
    localparam add_op = 4'b0010;//add
    localparam sub_op = 4'b0110;//sub
    localparam slt_op = 4'b0111;//slt
    localparam nor_op = 4'b1100;//nor

    localparam ADD_F = 6'b100000 ;
    localparam SUB_F = 6'b100010 ;
    localparam AND_F = 6'b100100 ;
    localparam OR_F  = 6'b100101 ;
    localparam NOR_F = 6'b100111 ;
    localparam SLT_F = 6'b101010 ;

// Define a entrada_ctrl
// aluOp = 00 a operação sera de add
// aluOp = 01 a operação sera de sub
// aluOp = 11 a operação sera de slt
// aluOp = 10 a instrução é Rtype e sua operação depende do funct
    always @(*) begin

        case (aluOp)
            2'b00: begin

                entrada_ctrl = add_op;
                
            end
            2'b01: begin

                entrada_ctrl = sub_op;
                
            end
            2'b11: begin

                entrada_ctrl = slt_op;
                
            end
            2'b10: begin

                case (funct)
                    
                    ADD_F: begin
                        entrada_ctrl = add_op;
                    end
                    
                    SUB_F: begin
                        entrada_ctrl = sub_op;
                    end
                    
                    AND_F: begin
                        entrada_ctrl = and_op;
                    end
                    
                    OR_F: begin
                        entrada_ctrl = or_op;
                    end
                    
                    NOR_F: begin
                        entrada_ctrl = nor_op;
                    end
                    
                    SLT_F: begin
                        entrada_ctrl = slt_op;
                    end

                    default: begin
                        entrada_ctrl = and_op;
                    end
            
                endcase
                
            end
            
        endcase
        
    end



endmodule 