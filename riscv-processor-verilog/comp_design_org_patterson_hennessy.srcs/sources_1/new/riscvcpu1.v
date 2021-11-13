
module riscvcpu1(clk);

    parameter LD = 7'b000_0011, SD = 7'b010_0011, BEQ = 7'b110_0011, NOP = 32'h0000_0013, ALUop = 7'b001_0011;
    input clk;
    
    reg[63:0] PC, Regs[0:31], IDEXA, IDEXB, EXMEMB, EXMEMALUOut, MEMWBValue;
    
    reg[31:0] IMemory[0:1023], DMemory[0:1023], IFIDIR, IDEXIR, EXMEMIR, MEMWBIR; // sep memories and pipelilne 

    wire[4:0] IFIDrs1, IFIDrs2, MEMWBIR; // Access register ALUop
    
    wire[6:0] IDEXop, EXMEMop, MEMWBop; // access opcodes 
    
    wire[63:0] Ain, Bin; // The ALU inputs
 
    // These assignments define fields from pipeline registers 
    assign IFIDrs1 = IFIDIR[19:15];     // rs1 field 
    assign IFIDrs2 = IFIDIR[24:20];
    assign IDEXop = IDEXIR[6:0];        // the opcode
    assign EXMEMop = EXMEMIR[6:0];      // the opcode 
    assign MEMWBop = MEMWBIR[6:0];      // the opcode 
    assign MEMWBrd = MEMWBIR[11:7];     // rd field 
    
    // Set inputs that go to alu to be from id/ex registers 
    assign Ain = IDEXA;
    assign Bin = IDEXB;
    
    integer i;
    initial
    begin
        PC = 0;
        IFIDIR = NOP; IDEXIR = NOP; EXMEMIR = NOP; MEMWBIR = NOP; // initialize with nop 
        for(i = 0; i <= 31; i = i+1) Regs[i] = i; // initialize regs
    end
    
    always @(posedge clk)
    begin 
        // first instruction fetch
        
        IFIDIR <= IMemory[PC >> 2];
        PC <= PC + 4;
        
        // second instruction in piepeline fetches registers 
        IDEXA <= Regs[IFIDrs1]; IDEXB <= Regs[IFIDrs2];
        IDEXIR <= IFIDIR;
        
        // Third instruction does address calculation or alu op 
        if (IDEXop == LD)
            EXMEMALUOut <= IDEXA + {{53{IDEXIR[31]}}, IDEXIR[30:20]};
        else if (IDEXop == SD)
            EXMEMALUOut <= IDEXA + {{53{IDEXIR[31]}}, IDEXIR[30:25], IDEXIR[11:7]};
        else if (IDEXop == ALUop)
            case(IDEXIR[31:25]) //
                0: EXMEMALUOut <= Ain + Bin; // add operation
                default:
            endcase
            EXMEMIR <= IDEXIR; EXMEMB <= IDEXB; // pass along registers
            
        // Mem stage of piepline 
        if (EXMEMop == ALUop) MEMWBValue <= EXMEMALUOut; // pass along alu result 
        else if (EXMEMop == LD) MEMWBValue <= DMemory[EXMEMALUOut >> 2];
        else if (EXMEMop == SD) DMemory[EXMEMALUOut >> 2] <= EXMEMB;
        MEMWBIR <= EXMEMIR; // pass along IR
        
        // WB stage
        if (((MEMWBop == LD) || (MEMWBop == ALUop)) && (MEMWBrd != 0)) Regs[MEMWBrd] <= MEMWBValue;
    end
endmodule