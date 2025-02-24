################################
# Author: 	D.B.S. Ariyarathna #
################################

import sys

# Opcode, funct3, and funct7 mappings remain the same
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
    'div': '0000001', 'rem': '0000001', 'remu': '0000001',
    'slli': '0000000', 'srli': '0000000', 'srai': '0100000'  # Added shift immediates
    
}

def register_to_binary(reg):
    """Convert register (x0-x31) to a 5-bit binary string"""
    reg = reg.replace(',', '')  # Remove any trailing commas
    if '(' in reg:  # Handle cases like "5(x0)"
        reg = reg.split('(')[1].strip(')')
    return format(int(reg[1:]), '05b')
    
def immediate_to_binary(imm, bits):
    """Convert immediate to a binary string with the given bit size (handles negative values)"""
    try:
        # If imm is already an integer, convert it to string
        if isinstance(imm, int):
            imm_val = imm
        else:
            # Remove any commas and whitespace
            imm = imm.replace(',', '').strip()
            
            # Handle hex values
            if imm.startswith('0x'):
                imm_val = int(imm, 16)
            else:
                imm_val = int(imm)
            
        # Handle negative numbers
        if imm_val < 0:
            imm_val = imm_val & ((1 << bits) - 1)
            
        return format(imm_val & ((1 << bits) - 1), f'0{bits}b')
    except ValueError:
        raise ValueError(f"Invalid immediate value: {imm}")


def clean_instruction(line):
    """Remove comments and clean up the instruction"""
    # Remove comments and leading/trailing whitespace
    line = line.split('#')[0].strip()
    if not line:
        return None
        
    # Split instruction into parts and remove empty strings
    parts = [part.strip() for part in line.split() if part.strip()]
    return parts

def assemble_instruction(line):
    """Convert a single assembly instruction into binary machine code"""
    parts = clean_instruction(line)
    if not parts:
        return None

    instr = parts[0]
    opcode = opcode_map.get(instr, None)
    if not opcode:
        return None
    
    if opcode in ['0110111', '0010111']:  # U-type (lui, auipc)
        rd = register_to_binary(parts[1])
        imm = immediate_to_binary(parts[2], 20)
        return f"{imm}{rd}{opcode}"

    if opcode == '0110011':  # R-type
        rd = register_to_binary(parts[1])
        rs1 = register_to_binary(parts[2])
        rs2 = register_to_binary(parts[3])
        funct3 = funct3_map[instr]
        funct7 = funct7_map[instr]
        return f"{funct7}{rs2}{rs1}{funct3}{rd}{opcode}"

    elif opcode == '0010011':  # I-type ALU
        rd = register_to_binary(parts[1])
        rs1 = register_to_binary(parts[2])
        imm_str = parts[3].replace(',', '')
        
        if instr in ['slli', 'srli', 'srai']:
            # For shift instructions, immediate is only 5 bits
            shift_amount = int(imm_str) & 0x1F
            # Create proper immediate field with funct7 in upper bits
            if instr == 'srai':
                imm = '0100000' + format(shift_amount, '05b')
            else:
                imm = '0000000' + format(shift_amount, '05b')
        else:
            # Other I-type instructions use full 12-bit immediate
            imm = immediate_to_binary(int(imm_str), 12)
        
        funct3 = funct3_map[instr]
        return f"{imm}{rs1}{funct3}{rd}{opcode}"
    
    elif opcode == '0000011':  # Load instructions
        rd = register_to_binary(parts[1])
        # Parse offset and base register from format: "offset(rs1)"
        offset_base = parts[2].split('(')
        offset = int(offset_base[0])
        rs1 = register_to_binary(offset_base[1].rstrip(')'))
        imm = immediate_to_binary(offset, 12)
        funct3 = funct3_map[instr]
        return f"{imm}{rs1}{funct3}{rd}{opcode}"
    
    
    elif opcode == '1100111':  # JALR
        rd = register_to_binary(parts[1])
        offset_base = parts[2].split('(')
        offset = int(offset_base[0])
        rs1 = register_to_binary(offset_base[1].rstrip(')'))
        imm = immediate_to_binary(offset, 12)
        return f"{imm}{rs1}000{rd}{opcode}"

    elif opcode == '0100011':  # Store instructions
        # Format: sw rs2, offset(rs1)
        rs2 = register_to_binary(parts[1])
        offset_base = parts[2].split('(')
        offset = int(offset_base[0])
        rs1 = register_to_binary(offset_base[1].rstrip(')'))
        imm = immediate_to_binary(offset, 12)  # Convert immediate to 12-bit binary
        funct3 = funct3_map[instr]

        # Correctly split immediate into upper (imm[11:5]) and lower (imm[4:0])
        imm_upper = imm[:7]   # Bits 11-5
        imm_lower = imm[-5:]  # Bits 4-0

        return f"{imm_upper}{rs2}{rs1}{funct3}{imm_lower}{opcode}"

    # Other instruction types remain the same...
    return None

    if opcode == '1101111':  # J-type (jal)
        rd = register_to_binary(parts[1])
        imm_str = parts[2].replace(',', '')
        
        # Convert immediate to 21-bit value
        imm_val = int(imm_str, 0) if imm_str.startswith('0x') else int(imm_str)
        
        # J-type immediate encoding is complex:
        # bits[20|10:1|11|19:12] from 21-bit immediate
        imm = immediate_to_binary(imm_val, 21)
        
        # Reorder the bits according to J-type format
        imm_reordered = imm[0] + imm[10:20] + imm[9] + imm[1:9]
        
        return f"{imm_reordered}{rd}{opcode}"

def assemble_file(input_file, bin_file, hex_file):
    """Assemble a RISC-V assembly file into binary and hex files"""
    with open(input_file, 'r') as f, open(bin_file, 'w') as bin_out, open(hex_file, 'w') as hex_out:
        for line in f:
            try:
                machine_code = assemble_instruction(line.strip())
                if machine_code:
                    bin_out.write(machine_code + "\n")
                    hex_out.write(f"{int(machine_code, 2):08X}\n")
            except Exception as e:
                print(f"Error processing line: {line.strip()}")
                print(f"Error message: {str(e)}")
                raise

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python assembler.py input.s output.bin output.hex")
        sys.exit(1)

    input_file = sys.argv[1]
    bin_file = sys.argv[2]
    hex_file = sys.argv[3]
    
    assemble_file(input_file, bin_file, hex_file)
    print(f"Assembly completed: {bin_file} and {hex_file}")