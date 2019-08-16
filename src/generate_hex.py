#!/usr/bin/python

encrypt = True
#encrypt = False
xor_byte = 0xc2


src = './src.txt'
with open(src) as fd:
    line = fd.readline()
    count = 1
    converted = '0x'
    while line:
        converted += ',0x'.join(hex(ord(x))[2:] for x in line)
        converted += ',0xd,0x'
        line = fd.readline()
        count += 1

converted = converted[:-3]

if (not encrypt):
    print(converted)
    exit()

converted = converted.replace("0xa", "0x0a")
converted = converted.replace("0xd", "0x0d")
converted = converted.replace(",0x", "")
converted = converted[2:]

array = bytearray.fromhex(converted)
array_len = len(array)

for i in range(0,array_len):
    array[i] ^= xor_byte

converted = ""

for i in range(0,array_len):
    converted += hex(array[i])
    converted += ","

converted = converted[:-1]

print(converted)
