'''
Written by Ted Goodell for ECE 3710
for Group 3, 'The BLOBs'
This will assemble some CR16 instructions.
'''


'''
TODO:
Add another loop to handle pseudo instructions

'''

'''
                        ImmHi/ ImmLo/
                OP Code Rdest OP Code Ext Rsrc
Mnemonic Operands 15-12 11-8 7-4 3-0 Notes (* is Baseline)
ADD Rsrc, Rdest; 0000 Rdest 0101 Rsrc *
ADDI Imm, Rdest 0101 Rdest ImmHi ImmLo * Sign extended Imm
ADDU Rsrc, Rdest 0000 Rdest 0110 Rsrc
ADDUI Imm, Rdest 0110 Rdest ImmHi ImmLo Sign extended Imm
ADDC Rsrc, Rdest 0000 Rdest 0111 Rsrc
ADDCI Imm, Rdest 0111 Rdest ImmHi ImmLo Sign extended Imm
MUL Rsrc, Rdest 0000 Rdest 1110 Rsrc
MULI Imm, Rdest 1110 Rdest ImmHi ImmLo Sign extended Imm
SUB Rsrc, Rdest 0000 Rdest 1001 Rsrc *
SUBI Imm, Rdest 1001 Rdest ImmHi ImmLo * Sign extended Imm
SUBC Rsrc, Rdest 0000 Rdest 1010 Rsrc
SUBCI Imm, Rdest 1010 Rdest ImmHi ImmLo Sign extended Imm
CMP Rsrc, Rdest 0000 Rdest 1011 Rsrc *
CMPI Imm, Rdest 1011 Rdest ImmHi ImmLo * Sign extended Imm
AND Rsrc, Rdest 0000 Rdest 0001 Rsrc *
ANDI Imm, Rdest 0001 Rdest ImmHi ImmLo * Zero extended Imm
OR Rsrc, Rdest; 0000 Rdest 0010 Rsrc * NOP=OR R0,R0
ORI Imm, Rdest 0010 Rdest ImmHi ImmLo * Zero extended Imm
XOR Rsrc, Rdest 0000 Rdest 0011 Rsrc *
XORI Imm, Rdest 0011 Rdest ImmHi ImmLo * Zero extended Imm
MOV Rsrc, Rdest 0000 Rdest 1101 Rsrc *
MOVI Imm, Rdest; 1101 Rdest ImmHi ImmLo * Zero extended Imm
LSH Ramount, Rdest 1000 Rdest 0100 Ramount * -15 to 15 (2s compl)
LSHI Imm, Rdest 1000 Rdest 000s ImmLo * s = sign (0=left, 2s comp)
ASHU Ramount, Rdest 1000 Rdest 0110 Ramount -15 to 15 (2s comp)
ASHUI Imm, Rdest 1000 Rdest 001s ImmLo s = sign (0=left, 2s comp)
LUI Imm, Rdest 1111 Rdest ImmHi ImmLo * Load & 8 bit Left Shift
LOAD Rdest, Raddr 0100 Rdest 0000 Raddr *
STOR Rsrc, Raddr 0100 Rsrc 0100 Raddr *
SNXB Rsrc, Rdest 0100 Rdest 0010 Rsrc
ZRXB Rsrc, Rdest 0100 Rdest 0110 Rsrc
Scond Rdest 0100 Rdest 1101 cond
Bcond disp 1100 cond DispHi DispLo * 2s comp displacement
Jcond Rtarget 0100 cond 1100 Rtarget *
JAL Rlink, Rtarget 0100 Rlink 1000 Rtarget *
TBIT Roffset, Rsrc 0100 Rsrc 1010 Roffset Offset = 0 to 15
TBITI Imm, Rsrc 0100 Rsrc 1110 Offset Offset = 0 to 15
LPR Rsrc, Rproc 0100 Rsrc 0001 Rproc
SPR Rproc, Rdest 0100 Rproc 0101 Rdest
DI 0100 0000 0011 0000
EI 0100 0000 0111 0000
EXCP vector 0100 0000 1011 vector
RETX 0100 0000 1001 0000
WAIT 0000 0000 0000 0000
'''


#my regex exists at https://regex101.com/r/PykLIR/1

import re
import sys
from ctypes import *

regexStr = r"(\w+:)?\s*(\S+)"
assem_regex = re.compile(regexStr, re.MULTILINE | re.VERBOSE)
#regex for finding hexidecimal can be found at https://regex101.com/r/zaY1m1/1

def getOperand(assem_line: str, operand: int):
    search_results = assem_regex.finditer(assem_line)
    first_match = next(search_results)
    rsrc_match = next(search_results)
    first_opstr = first_match.group(2).lower()
    if first_opstr[0] != 'j':
        try:
            operand_1 = re.search(r"(r\d{1,2})|(0x[A-F0-9]+)|(-?\d{1,3})", rsrc_match.group(2), re.MULTILINE|re.IGNORECASE).group(0)
        except:
            operand_1 = rsrc_match.group(2)
    else:
        operand_1 = rsrc_match.group(2)

    if (re.match(r'(j[a-z]*)|(b[a-z]+)', first_match.group(2).lower()) is None or
        first_match.group(2).lower() == 'jal') and operand == 2:
        rdest_match = next(search_results)
        operand_2 = re.search(r"-?\d{1,2}", rdest_match.group(2), re.MULTILINE).group(0)

    if operand == 1:
        return operand_1
    elif operand == 2:
        return operand_2


def getLabel(assem_line: str):
    assem_line = assem_line.split('#')
    _label = assem_regex.search(assem_line[0]).group(1);
    if _label is not None:
        return _label + " "
    else:
        return ""
def getOpcode(assem_line: str):
    assem_line = assem_line.split('#')
    search_results = assem_regex.finditer(assem_line[0])
    first_match = next(search_results)
    op_code = first_match.group(2).lower()
    return op_code


def hasRegOperand(assem_line: str):
    if re.search(r'r\d{1,2}', getOperand(assem_line, 1).lower()) is not None:
        return True
    else:
        return False



MEM_SIZE = 65000 # 16 bit words
mem_list = []

for i in range(0,MEM_SIZE):
    mem_list.append(0)
inpath = 'explode.asm'
outpath = 'explode.dat'


jumpReg = 'r15'
linkReg = 'r14'

if len(sys.argv) > 1:
    inpath = sys.argv[1]

lines = list(open(inpath))

program_counter = 0
labelDict = {'pgm_begin' : 0}

'''
WARNING: This was copied from Hari's email and the operands are flipped.
to jump to 0x02FF
MOVi r1, FF
LUI r1, 02
JEQ r1
'''

#LOOP 1: Translate pseudo instructions.
i = 0
label = ''
lastJ = ''
for line in lines:
    if line[0] == '#' or line == lastJ or line.isspace() or line == 'movpc':
        i += 1
        continue
    comment_sep = line.split('#')
    if comment_sep[0] != "": # and not re.match(r"^\s+$",comment_sep[0]):
        searchResults = assem_regex.finditer(comment_sep[0])
        firstMatch = next(searchResults)
        opcode = firstMatch.group(2).lower()
        if opcode != "nope" and opcode != "noperope":
            Rsrc_match = next(searchResults)


        line_label = getLabel(line) # This label corresponds to the label at the beginning a line (example: )

        if (re.match(r'(j[a-z]*)', opcode.lower()) is not None) and not hasRegOperand(line):
            #if opcode == 'jal':
                # These are commented out since JAL will use a label now
                #Rdest_match = next(searchResults)
                #label = re.search(r'\w+',Rdest_match.group(2)).group(0)
            #else:
            #    label = re.search(r'\w+',Rsrc_match.group(2)).group(0)

            label = re.search(r'\w+', Rsrc_match.group(2)).group(0)
            '''
            #to jump to 0x02FF
            MOVi r1, FF
            LUI r1, 02
            JEQ r1
            '''

            # remember: in immediate instructions, Immediate comes first.
            lines.remove(line)
            lines.insert(i, line_label + 'lui ' + label + ', ' + jumpReg)
            lines.insert(i+1, 'ori ' + label + ', ' + jumpReg)

            if opcode.lower() == 'jal':
                lastJ = opcode + ' ' + linkReg + ', ' + jumpReg
                # movpc is a special opcode that only the assembler knows about. It puts the program counter + 2
                # into R14
                lines.insert(i + 2, 'movpc r0, r0')
                lines.insert(i + 3, lastJ)
            else:
                lastJ = opcode + ' ' + jumpReg
                lines.insert(i + 2, lastJ)

            '''
            // move immediate word
            moviw 0xAABB, r3 translates to:
            lui 0xAA, r3
            ori 0xBB, r3
            '''
        elif opcode.lower() == 'moviw':
            immediate = getOperand(line, 1)
            immediate = int(immediate, 0)
            reg = getOperand(line, 2)

            lines.insert(i, line_label + 'lui ' + str(immediate >> 8) + ' ' + reg)
            lines.insert(i+1, 'ori ' + str(immediate & 0x00FF) + ' ' + reg)
            lines.remove(line)

            '''
            make a no-op with NOPE
            translates to:
            ori r0, r0
            '''

        elif opcode.lower() == 'nope':
            lines.insert(i, line_label + 'ori r0, r0')
            lines.remove(line)

        elif opcode.lower() == 'noperope':
            for ind in range(1, int(getOperand(line, 1))):
                lines.insert(ind, line_label + 'ori r0, r0')
            lines.remove(line)

    i += 1



i = 0
# LOOP 2: collect and store program labels
for line in lines:
    if line[0] == '#' or line.isspace() or line == '':
        continue
    comment_sep = line.split('#')
    #print(line.rstrip())
    if comment_sep[0] != "" and not line.isspace(): # and not re.match(r"^\s+$",comment_sep[0]):
        firstMatch = assem_regex.search(comment_sep[0])
        if firstMatch.group(1) is not None:
            labelDict[firstMatch.group(1)] = program_counter
        program_counter += 1

# LOOP 3: Replace labels in lui and ori
i = 0
for line in lines:
    if line[0] == '#' or line.isspace() or line == '':
        continue
    line = line.split('#')[0]
    newLine = None

    if not hasRegOperand(line):
        if getOpcode(line).lower() == "lui" and re.match(r"lui\s+(\w+), " + jumpReg, line) is not None:
            #label = re.match(r"lui\s+" + '\\' + jumpReg +  r", (\w+)", line).group(1)
            label = re.match(r"lui\s+(\w+), " + jumpReg, line).group(1)
            try:
                addr = labelDict[label + ':']
            except:
                print("ERROR! label " + label + " does not exist!")
                exit(-1)
            addr = addr >> 8
            newLine = line.replace(label, str(addr))
        if getOpcode(line).lower() == "ori" and re.match(r"ori\s+(\w+), " + jumpReg, line) is not None:
            #label = re.match(r"movi\s+" + '\\' + jumpReg + r", (\w+)", line).group(1)
            label = re.match(r"ori\s+(\w+), " + jumpReg, line).group(1)
            try:
                addr = labelDict[label + ':']
            except:
                print("ERROR! label " + label + " does not exist!")
                exit(-1)
            addr = addr & 0x00FF
            newLine = line.replace(label, str(addr))

        if newLine is not None:
            lines.insert(i, newLine)
            lines.remove(line)
    i += 1

for line in lines:
    print(line.rstrip())


#LOOP 4: begin parsing codes
program_counter = 0
for line in lines:
    if line[0] == '#' or line.isspace():
        continue
    comment_sep = line.split('#')
    if comment_sep[0] != "" and not line.isspace(): # and not re.match(r"^\s+$",comment_sep[0]):
      #  print(comment_sep[0])

        searchResults = assem_regex.finditer(comment_sep[0])
        firstMatch = next(searchResults)
        Rsrc_match = next(searchResults)
        if firstMatch.group(2).lower() != 'j':
            operand1 = re.search(r"(0x[A-F0-9]+)|(-?\d{1,3})", Rsrc_match.group(2), re.MULTILINE).group(0)
            operand1 = c_ubyte(int(operand1, 0))
        else:
            operand1 = Rsrc_match.group(2)

        if (re.match(r'(j[a-z]*)|(b[a-z]+)', firstMatch.group(2).lower()) is None or
                firstMatch.group(2).lower() == 'jal' ):
            Rdest_match = next(searchResults)
            operand2 = re.search(r"-?\d{1,2}", Rdest_match.group(2), re.MULTILINE).group(0)
            operand2 = c_ubyte(int(operand2))

        temp_op = 0
        if searchResults is not None:


            print(firstMatch.group(2) + ' ' + str(operand1.value) + ' ' + str(operand2.value))
            #temp_op = c_ushort(0)
            # ADD Rsrc, Rdest; 0000 Rdest 0101 Rsrc
            if firstMatch.group(2).lower() == 'add':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0101
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

            elif firstMatch.group(2).lower() == 'addi':
                temp_op = 0b0101
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # ADDU Rsrc, Rdest: 0000 Rdest 0110 Rsrc
            elif firstMatch.group(2).lower() == 'addu':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0110
                temp_op = temp_op << 4
                mem_list[program_counter] = temp_op

        # ADDUI Imm, Rdest; 0110 Rdest ImmHi ImmLo ;Signextended Imm
            elif firstMatch.group(2).lower() == 'addui':
                temp_op = 0b0110
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # SUB Rsrc, Rdest; 0000 Rdest 1001 Rsrc
            elif firstMatch.group(2).lower() == 'sub':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b1001
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        #SUBI Imm, Rdest; 1001 Rdest ImmHi ImmLo
            elif firstMatch.group(2).lower() == 'subi':
                temp_op = 0b1001
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        #CMP Rsrc, Rdest; 0000 Rdest 1011 Rsrc
            elif firstMatch.group(2).lower() == 'cmp':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b1011
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        #CMPI Imm, Rdest; 1011 Rdest ImmHi ImmLo
            elif firstMatch.group(2).lower() == 'cmpi':
                temp_op = 0b1011
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        #AND Rsrc, Rdest; 0000 Rdest 0001 Rsrc
            elif firstMatch.group(2).lower() == 'and':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0001
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        #ANDI Imm, Rdest; 0001 Rdest ImmHi ImmLo
            elif firstMatch.group(2).lower() == 'andi':
                temp_op = 0b0001
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        #OR Rsrc, Rdest; 0000 Rdest 0010 Rsrc
            elif firstMatch.group(2).lower() == 'or':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0010
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        #ORI Imm, Rdest 0010 Rdest ImmHi ImmLo
            elif firstMatch.group(2).lower() == 'ori':
                temp_op = 0b0010
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # XOR Rsrc, Rdest; 0000 Rdest 0011 Rsrc *
            elif firstMatch.group(2).lower() == 'xor':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0011
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # XORI Imm, Rdest; 0011 Rdest ImmHi ImmLo
            elif firstMatch.group(2).lower() == 'xori':
                temp_op = 0b0011
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # MOV Rsrc, Rdest; 0000 Rdest 1101 Rsrc *
            elif firstMatch.group(2).lower() == 'mov':
                temp_op = operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b1101
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # MOVI Imm, Rdest; 1101 Rdest ImmHi ImmLo
            elif firstMatch.group(2).lower() == 'movi':
                temp_op = 0b1101
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # LSH Ramount, Rdest; 1000 Rdest 0100 Ramount
            elif firstMatch.group(2).lower() == 'lsh':
                temp_op = 0b1000
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0100
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # LSHI Imm, Rdest; 1000 Rdest 000s ImmLo
            elif firstMatch.group(2).lower() == 'lshi':
                temp_op = 0b1000
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 4
                # check if the operand is negative
                if (operand1.value & 0b10000000) != 0:
                    op1value = operand1.value & 0b00001111
                    op1value -= 1
                    op1value = ~op1value
                    temp_op = temp_op | 0b0001
                    temp_op = temp_op << 4
                    temp_op = temp_op | op1value
                else:
                    temp_op = temp_op | 0b0000
                    temp_op = temp_op << 4
                    temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # LUI Imm, Rdest; 1111 Rdest ImmHi ImmLo
            elif firstMatch.group(2).lower() == 'lui':
                temp_op = 0b1111
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                temp_op = temp_op << 8
                temp_op = temp_op | operand1.value
                mem_list[program_counter] = temp_op

        # LOAD Rdest, Raddr; 0100 Rdest 0000 Raddr *
            elif firstMatch.group(2).lower() == 'load':
                temp_op = 0b0100
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0000
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                mem_list[program_counter] = temp_op

        # STOR Rsrc, Raddr; 0100 Rsrc 0100 Raddr
            elif firstMatch.group(2).lower() == 'stor':
                temp_op = 0b0100
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0100
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                mem_list[program_counter] = temp_op

        # JAL Rlink, Rtarget; 0100 Rlink 1000 Rtarget
            elif firstMatch.group(2).lower() == 'jal':
                temp_op = 0b0100
                temp_op = temp_op << 4
                temp_op = temp_op | operand1.value
                temp_op = temp_op << 4
                temp_op = temp_op | 0b1000
                temp_op = temp_op << 4
                temp_op = temp_op | operand2.value
                mem_list[program_counter] = temp_op

        # MOVPC the fancy one that just puts the program counter into r14
            elif firstMatch.group(2).lower() == 'movpc':
                temp_op = 0x40F0
                mem_list[program_counter] = temp_op

        # RETX; 0100 0000 1001 0000
            elif firstMatch.group(2).lower() == 'retx':
                temp_op = 0x4090
                mem_list[program_counter] = temp_op


        # Bcond and Jcond
            elif re.search(r'(j[a-z]+)|(b[a-z]+)', firstMatch.group(2).lower()) is not None:
                cond = 0
                borjmatch = re.search(r'(j[a-z]+)|(b[a-z]+)', firstMatch.group(2).lower())
                opstr = firstMatch.group(2).lower()
                if opstr[1:] == 'eq':
                    cond = 0
                elif opstr[1:] == 'ne':
                    cond = 1
                elif opstr[1:] == 'ge':
                    cond = 0b1101
                elif opstr[1:] == 'cs':
                    cond = 0b0010
                elif opstr[1:] == 'cc':
                    cond = 0b0011
                elif opstr[1:] == 'hi':
                    cond = 0b0100
                elif opstr[1:] == 'ls':
                    cond = 0b0101
                elif opstr[1:] == 'lo':
                    cond = 0b1010
                elif opstr[1:] == 'hs':
                    cond = 0b1011
                elif opstr[1:] == 'gt':
                    cond = 0b0110
                elif opstr[1:] == 'le':
                    cond = 0b0111
                elif opstr[1:] == 'fs':
                    cond = 0b1000
                elif opstr[1:] == 'fc':
                    cond = 0b1001
                elif opstr[1:] == 'lt':
                    cond = 0b1100
                elif opstr[1:] == 'uc':
                    cond = 0b1110

                # now check for b or j
                # Jcond Rtarget; 0100 cond 1100 Rtarget
                if borjmatch.group(1) is not None:
                    temp_op = 0b0100
                    temp_op = temp_op << 4
                    temp_op = temp_op | cond
                    temp_op = temp_op << 4
                    temp_op = temp_op | 0b1100
                    temp_op = temp_op << 4
                    temp_op = temp_op | operand1.value
                    mem_list[program_counter] = temp_op
                # Bcond disp; 1100 cond DispHi DispLo
                elif borjmatch.group(2) is not None:
                    temp_op = 0b1100
                    temp_op = temp_op << 4
                    temp_op = temp_op | cond
                    temp_op = temp_op << 8
                    temp_op = temp_op | operand1.value
                    mem_list[program_counter] = temp_op
                else:
                    print('FAIL: improperly parsed cond instruction')
                    print(line)

            # j label; 1010 0000 Immhi immlo
            elif firstMatch.group(2).lower() == 'lui':
                temp_op = 0b1010
                temp_op = temp_op << 4
                temp_op = temp_op | 0b0000
                temp_op = temp_op << 8
                temp_op = temp_op | labelDict[operand1]
                mem_list[program_counter] = temp_op
            else:
                print('Unknown: ' + line)

            program_counter += 1

fout = open(outpath, "w")

# LOOP 5: writeout codes to file
for code in mem_list:
    fout.write("{:04x}".format(code) + '\n')

fout.close()
#merph
print("end")









