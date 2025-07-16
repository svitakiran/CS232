# Template by Bruce A. Maxwell, 2015
#
# implements a simple assembler for the following assembly language
# 
# - One instruction or label per line.
#
# - Blank lines are ignored.
#
# - Comments start with a # as the first character and all subsequent
# - characters on the line are ignored.
#
# - Spaces delimit instruction elements.
#
# - A label ends with a colon and must be a single symbol on its own line.
#
# - A label can be any single continuous sequence of printable
# - characters; a colon or space terminates the symbol.
#
# - All immediate and address values are given in decimal.
#
# - Address values must be positive
#
# - Negative immediate values must have a preceeding '-' with no space
# - between it and the number.
#

# Language definition:
#
# LOAD D A   - load from address A to destination D
# LOADA D A  - load using the address register from address A + RE to destination D
# STORE S A  - store value in S to address A
# STOREA S A - store using the address register the value in S to address A + RE
# BRA L      - branch to label A
# BRAZ L     - branch to label A if the CR zero flag is set
# BRAN L     - branch to label L if the CR negative flag is set
# BRAO L     - branch to label L if the CR overflow flag is set
# BRAC L     - branch to label L if the CR carry flag is set
# CALL L     - call the routine at label L
# RETURN     - return from a routine
# HALT       - execute the halt/exit instruction
# PUSH S     - push source value S to the stack
# POP D      - pop form the stack and put in destination D
# OPORT S    - output to the global port from source S
# IPORT D    - input from the global port to destination D
# ADD A B C  - execute C <= A + B
# SUB A B C  - execute C <= A - B
# AND A B C  - execute C <= A and B  bitwise
# OR  A B C  - execute C <= A or B   bitwise
# XOR A B C  - execute C <= A xor B  bitwise
# SHIFTL A C - execute C <= A shift left by 1
# SHIFTR A C - execute C <= A shift right by 1
# ROTL A C   - execute C <= A rotate left by 1
# ROTR A C   - execute C <= A rotate right by 1
# MOVE A C   - execute C <= A where A is a source register
# MOVEI V C  - execute C <= value V
#

# 2-pass assembler
# pass 1: read through the instructions and put numbers on each instruction location
#         calculate the label values
#
# pass 2: read through the instructions and build the machine instructions
#

import sys

# converts d to an 8-bit 2-s complement binary value
def dec2comp8(d, linenum):
    if d > 0:
        l = d.bit_length()
        v = "00000000"
        v = v[0:8-l] + format(d, 'b')
    elif d == 0:
        v = "00000000"
    else:
        print('Invalid address on line {}: value is negative'.format(linenum))
        exit()
    return v

# converts d to an 8-bit unsigned binary value
def dec2bin8(d, linenum):
    if d >= 0:
        l = d.bit_length()
        v = "00000000"
        v = v[0:8-l] + format(d, 'b')
    else:
        print('Invalid address on line {}: value is negative'.format(linenum))
        exit()
    return v

# Tokenizes the input data, discarding white space and comments
# returns the tokens as a list of lists, one list for each line.
#
# The tokenizer also converts each character to lower case.
def tokenize(fp):
    tokens = []

    # start of the file
    fp.seek(0)

    lines = fp.readlines()

    # strip white space and comments from each line
    for line in lines:
        ls = line.strip()
        uls = ''
        for c in ls:
            if c != '#':  # Ignore comments
                uls = uls + c
            else:
                break

        # skip blank lines
        if len(uls) == 0:
            continue

        # split on white space
        words = uls.split()
        
        newwords = [word.lower() for word in words]
        tokens.append(newwords)

    return tokens

# reads through the file and returns a dictionary of all location
# labels with their line numbers
def pass1(tokens):
    label_dict = {}
    line_number = 0
    new_tokens = []

    for line in tokens:
        if len(line) == 1 and line[0].endswith(':'):
            label = line[0][:-1]
            if label in label_dict:
                raise ValueError("Duplicate label found: {}".format(label))
            label_dict[label] = line_number
        else:
            new_tokens.append(line)
            line_number += 1

    return new_tokens, label_dict

register_map = {
    "ra": 0,
    "rb": 1,
    "rc": 2,
    "rd": 3,
    "re": 4,
    "rf": 5,
    "rg": 6,
    "rh": 7,
}

def pass2(tokens, labels):
    machine_code = []

    for line in tokens:
        instruction = line[0]

        if instruction == 'movei':
            V = dec2bin8(int(line[1]), 0)
            C = dec2bin8(register_map[line[2]], 0)
            machine_code.append("1000{}{}".format(V, C))

        elif instruction == 'add':
            A = dec2bin8(register_map[line[1]], 0)
            B = dec2bin8(register_map[line[2]], 0)
            C = dec2bin8(register_map[line[3]], 0)
            machine_code.append("1110{}{}{}".format(A, B, C))

        elif instruction == 'sub':
            A = dec2bin8(register_map[line[1]], 0)
            B = dec2bin8(register_map[line[2]], 0)
            C = dec2bin8(register_map[line[3]], 0)
            machine_code.append("1111{}{}{}".format(A, B, C))

        elif instruction == 'move':
            A = dec2bin8(register_map[line[1]], 0)
            C = dec2bin8(register_map[line[2]], 0)
            machine_code.append("1010{}{}".format(A, C))

        elif instruction == 'halt':
            machine_code.append("1111000000000000")

        elif instruction == 'bra':
            label = line[1]
            address = labels[label]
            machine_code.append("0101{}".format(dec2bin8(address, 0)))

        elif instruction == 'braz':
            label = line[1]
            address = labels[label]
            machine_code.append("0110{}".format(dec2bin8(address, 0)))

        elif instruction == 'bran':
            label = line[1]
            address = labels[label]
            machine_code.append("0111{}".format(dec2bin8(address, 0)))

        elif instruction == 'call':
            label = line[1]
            address = labels[label]
            machine_code.append("1000{}".format(dec2bin8(address, 0)))

        elif instruction == 'return':
            machine_code.append("1001000000000000")

        elif instruction == 'push':
            S = dec2bin8(int(line[1]), 0)
            machine_code.append("1100{}".format(S))

        elif instruction == 'pop':
            D = dec2bin8(int(line[1]), 0)
            machine_code.append("1101{}".format(D))

        elif instruction == 'oport':
            S = dec2bin8(int(line[1]), 0)
            machine_code.append("1110{}".format(S))

        elif instruction == 'iport':
            D = dec2bin8(int(line[1]), 0)
            machine_code.append("1111{}".format(D))

    return machine_code

def main(argv):
    if len(argv) < 2:
        print('Usage: python {} <filename.txt>'.format(argv[0]))
        exit()

    # execute pass1 and pass2 then print it out as an MIF file

    with open(argv[1], 'r') as fp:
        tokens = tokenize(fp)

    cleaned_tokens, label_dict = pass1(tokens)
    machine_code = pass2(cleaned_tokens, label_dict)

    print("-- program memory file for", argv[1])
    print("DEPTH = 256;")
    print("WIDTH = 16;")
    print("ADDRESS_RADIX = HEX;")
    print("DATA_RADIX = BIN;")
    print("CONTENT")
    print("BEGIN")

    for i, instr in enumerate(machine_code):
        print("{:02X} : {};".format(i, instr))

    print("[{:02X}..FF] : 1111111111111111;".format(len(machine_code)))
    print("END")

if __name__ == "__main__":
    main(sys.argv)