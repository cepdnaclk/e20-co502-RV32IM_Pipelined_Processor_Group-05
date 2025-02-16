import sys

# Opcode, funct3, and funct7 mappings for RISC-V instructions
opcode_map = {
    'add': '0110011', 'sub': '0110011', 'sll': '0110011', 'slt': '0110011', 'sltu': '0110011',
    'xor': '0110011', 'srl': '0110011', 'sra': '0110011', 'or': '0110011', 'and': '0110011',
    'mul': '0110011', 'mulh': '0110011', 'mulhsu': '0110011', 'mulhu': '0110011',
    'div': '0110011', 'rem': '0110011', 'remu': '0110011',
    'addi': '0010011', 'slti': '0010011', 'sltiu': '0010011', 'xori': '0010011', 
    'ori': '0010011', 'andi': '0010011', 'slli': '0010011', 'srli': '0010011', 'srai': '0010011',
    'lb': '0000011', 'lh': '0000011', 'lw': '0000011', 'lbu': '0000011', 'lhu': '0000011',
    'sb': '0100011', 'sh': '0100011', 'sw': '0100011',
    'beq': '1100011', 'bne': '1100011', 'blt': '1100011', 'bge': '1100011',
    'bltu': '1100011', 'bgeu': '1100011', 'jal': '1101111', 'jalr': '1100111',
    'lui': '0110111', 'auipc': '0010111'
}

funct3_map = {
    'add': '000', 'sub': '000', 'sll': '001', 'slt': '010', 'sltu': '011',
    'xor': '100', 'srl': '101', 'sra': '101', 'or': '110', 'and': '111',
    'mul': '000', 'mulh': '001', 'mulhsu': '010', 'mulhu': '011',
    'div': '100', 'rem': '110', 'remu': '111',
    'addi': '000', 'slti': '010', 'sltiu': '011', 'xori': '100', 
    'ori': '110', 'andi': '111', 'slli': '001', 'srli': '101', 'srai': '101',
    'lb': '000', 'lh': '001', 'lw': '010', 'lbu': '100', 'lhu': '101',
    'sb': '000', 'sh': '001', 'sw': '010',
    'beq': '000', 'bne': '001', 'blt': '100', 'bge': '101', 'bltu': '110', 'bgeu': '111',
    'jalr': '000'
}

funct7_map = {
    'add': '0000000', 'sub': '0100000', 'sll': '0000000', 'slt': '0000000', 'sltu': '0000000',
    'xor': '0000000', 'srl': '0000000', 'sra': '0100000', 'or': '0000000', 'and': '0000000',
    'mul': '0000001', 'mulh': '0000001', 'mulhsu': '0000001', 'mulhu': '0000001',
    'div': '0000001', 'rem': '0000001', 'remu': '0000001'
}

def register_to_binary(reg):
    """Convert register (x0-x31) to a 5-bit binary string"""
    reg = reg.replace(',', '')  # Remove any trailing commas
    return format(int(reg[1:]), '05b')


def immediate_to_binary(imm, bits):
    """Convert immediate to a binary string with the given bit size (handles negative values)"""
    return format(imm & ((1 << bits) - 1), f'0{bits}b')

def assemble_instruction(line):
    """Convert a single assembly instruction into binary machine code"""
    parts = line.split()
    if len(parts) == 0 or parts[0].startswith("#"):
        return None

    instr = parts[0]
    opcode = opcode_map.get(instr, None)
    if not opcode:
        return None

    if opcode == '0110011':  # R-type
        rd = register_to_binary(parts[1])
        rs1 = register_to_binary(parts[2])
        rs2 = register_to_binary(parts[3])
        funct3 = funct3_map[instr]
        funct7 = funct7_map[instr]
        return f"{funct7}{rs2}{rs1}{funct3}{rd}{opcode}"

    elif opcode in ['0010011', '1100111']:  # I-type
        rd = register_to_binary(parts[1])
        rs1 = register_to_binary(parts[2])
        imm = immediate_to_binary(int(parts[3]), 12)
        funct3 = funct3_map[instr]
        return f"{imm}{rs1}{funct3}{rd}{opcode}"
    
    elif opcode in ['0000011']:  # I-type (Load instructions: lb, lh, lw, lbu, lhu)
        rd = register_to_binary(parts[1])

        # Handle imm(rs1) format correctly
        imm_rs1 = parts[2]  # Example: "0(x10)"
        imm_val, rs1_reg = imm_rs1.split('(')  # Extract immediate and register
        rs1 = register_to_binary(rs1_reg.strip(')'))  # Remove ')'
        imm = immediate_to_binary(int(imm_val), 12)  # Convert immediate

        funct3 = funct3_map[instr]
        return f"{imm}{rs1}{funct3}{rd}{opcode}"


    elif opcode == '0100011':  # S-type
        rs1 = register_to_binary(parts[2])
        rs2 = register_to_binary(parts[1])
        imm = immediate_to_binary(int(parts[3]), 12)
        funct3 = funct3_map[instr]
        return f"{imm[:7]}{rs2}{rs1}{funct3}{imm[7:]}{opcode}"

    elif opcode == '1100011':  # B-type
        rs1 = register_to_binary(parts[1])
        rs2 = register_to_binary(parts[2])
        imm = immediate_to_binary(int(parts[3]), 13)
        funct3 = funct3_map[instr]
        return f"{imm[0]}{imm[2:8]}{rs2}{rs1}{funct3}{imm[8:12]}{imm[1]}{opcode}"

    elif opcode == '1101111':  # J-type
        rd = register_to_binary(parts[1])
        imm = immediate_to_binary(int(parts[2]), 21)
        return f"{imm[0]}{imm[10:20]}{imm[9]}{imm[1:9]}{rd}{opcode}"

    elif opcode in ['0110111', '0010111']:  # U-type
        rd = register_to_binary(parts[1])
        imm = immediate_to_binary(int(parts[2]), 20)
        return f"{imm}{rd}{opcode}"

    return None

def assemble_file(input_file, bin_file, hex_file):
    """Assemble a RISC-V assembly file into binary and hex files"""
    with open(input_file, 'r') as f, open(bin_file, 'w') as bin_out, open(hex_file, 'w') as hex_out:
        for line in f:
            machine_code = assemble_instruction(line.strip())
            if machine_code:
                bin_out.write(machine_code + "\n")
                hex_out.write(f"{int(machine_code, 2):08X}\n")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python assembler.py input.s output.bin output.hex")
        sys.exit(1)

    input_file = sys.argv[1]
    bin_file = sys.argv[2]
    hex_file = sys.argv[3]
    
    assemble_file(input_file, bin_file, hex_file)
    print(f"Assembly completed: {bin_file} and {hex_file}")
