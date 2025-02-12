import re
import os
import sys

def assemble_instruction(instruction):
    parts = instruction.split()
    opcode_map = {
        'add': '0110011', 'sub': '0110011', 'sll': '0110011', 'slt': '0110011', 'sltu': '0110011',
        'xor': '0110011', 'srl': '0110011', 'sra': '0110011', 'or': '0110011', 'and': '0110011',
        'addi': '0010011', 'slti': '0010011', 'sltiu': '0010011', 'xori': '0010011', 'ori': '0010011',
        'andi': '0010011', 'slli': '0010011', 'srli': '0010011', 'srai': '0010011',
        'lb': '0000011', 'lh': '0000011', 'lw': '0000011', 'lbu': '0000011', 'lhu': '0000011',
        'sb': '0100011', 'sh': '0100011', 'sw': '0100011',
        'beq': '1100011', 'bne': '1100011', 'blt': '1100011', 'bge': '1100011',
        'bltu': '1100011', 'bgeu': '1100011', 'jal': '1101111', 'jalr': '1100111',
        'lui': '0110111', 'auipc': '0010111'
    }
    funct3_map = {
        'add': '000', 'sub': '000', 'sll': '001', 'slt': '010', 'sltu': '011',
        'xor': '100', 'srl': '101', 'sra': '101', 'or': '110', 'and': '111',
        'addi': '000', 'slti': '010', 'sltiu': '011', 'xori': '100', 'ori': '110', 'andi': '111',
        'slli': '001', 'srli': '101', 'srai': '101',
        'lb': '000', 'lh': '001', 'lw': '010', 'lbu': '100', 'lhu': '101',
        'sb': '000', 'sh': '001', 'sw': '010',
        'beq': '000', 'bne': '001', 'blt': '100', 'bge': '101', 'bltu': '110', 'bgeu': '111',
        'jalr': '000'
    }
    funct7_map = {
        'add': '0000000', 'sub': '0100000', 'sll': '0000000', 'slt': '0000000', 'sltu': '0000000',
        'xor': '0000000', 'srl': '0000000', 'sra': '0100000', 'or': '0000000', 'and': '0000000'
    }
    opcode = opcode_map.get(parts[0], None)
    if not opcode:
        return "Invalid instruction"
    
    if opcode == '0110011':  # R-type
        rd = format(int(parts[1][1:]), '05b')
        rs1 = format(int(parts[2][1:]), '05b')
        rs2 = format(int(parts[3][1:]), '05b')
        funct3 = funct3_map[parts[0]]
        funct7 = funct7_map[parts[0]]
        return f"{funct7}{rs2}{rs1}{funct3}{rd}{opcode}"
    
    elif opcode == '0010011' or opcode == '0000011' or opcode == '1100111':  # I-type
        rd = format(int(parts[1][1:]), '05b')
        rs1 = format(int(parts[2][1:]), '05b')
        imm = format(int(parts[3]), '012b')
        funct3 = funct3_map[parts[0]]
        return f"{imm}{rs1}{funct3}{rd}{opcode}"
    
    elif opcode == '0100011':  # S-type
        rs1 = format(int(parts[2][1:]), '05b')
        rs2 = format(int(parts[1][1:]), '05b')
        imm = format(int(parts[3]), '012b')
        funct3 = funct3_map[parts[0]]
        return f"{imm[:7]}{rs2}{rs1}{funct3}{imm[7:]}{opcode}"
    
    elif opcode == '1100011':  # B-type
        rs1 = format(int(parts[1][1:]), '05b')
        rs2 = format(int(parts[2][1:]), '05b')
        imm = format(int(parts[3]), '013b')
        funct3 = funct3_map[parts[0]]
        return f"{imm[0]}{imm[2:8]}{rs2}{rs1}{funct3}{imm[8:12]}{imm[1]}{opcode}"
    
    elif opcode == '1101111':  # J-type
        rd = format(int(parts[1][1:]), '05b')
        imm = format(int(parts[2]), '021b')
        return f"{imm[0]}{imm[10:20]}{imm[9]}{imm[1:9]}{rd}{opcode}"
    
    elif opcode == '0110111' or opcode == '0010111':  # U-type
        rd = format(int(parts[1][1:]), '05b')
        imm = format(int(parts[2]), '020b')
        return f"{imm}{rd}{opcode}"
    
    return "Unsupported instruction"

