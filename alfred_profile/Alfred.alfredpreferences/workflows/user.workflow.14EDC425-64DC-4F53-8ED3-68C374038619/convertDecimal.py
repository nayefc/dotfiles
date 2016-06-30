#!/usr/bin/env python

import sys
import alp

# calculate binary number
binary = bin(int(sys.argv[1]))[2:].zfill(8)
# create associative array and create xml from it
binaryDic = dict(title=str(binary), subtitle="Binary", uid="binary", valid=True, arg=str(binary), icon="icons/binary.png")
b = alp.Item(**binaryDic)

# calculate hex number
hexadec = hex(int(sys.argv[1]))[2:].upper()
# create associative array and create xml from it
hexDic = dict(title=str(hexadec), subtitle="Hexadecimal", uid="hex", valid=True, arg=str(hexadec), icon="icons/hex.png")
h = alp.Item(**hexDic)

itemsList = [b, h]
alp.feedback(itemsList)
