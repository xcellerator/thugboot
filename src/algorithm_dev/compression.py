#!/usr/bin/python
# This script takes an ASCII string and "compresses" it by counting repeated characters, i.e. aabbbcccc -> a2b3c4, but everything stays in hex to make things simpler. The idea is to generate a sequence of bytes that can be copied into a NASM source and the decompression routine rewritten in x86 Real Mode Assembly.


thugcrowd_logo = "                 ______________     ______      ___" + "\n\r" + "                 \   _    _   /----/     /_____/   \________" + "\n\r" + "                 /___/    /___\  _/     //    /    /   _    \\" + "\n\r" + "                    /    //      \     //    /    /    /    /" + "\n\r" + "                   /_____\       /_____\ _________\_____   /" + "\n\r" + "                          \_____/       \/     \___________\\" + "\n\r\n\r" +  "              _________  ___________ ________ _______   _________" + "\n\r" + "            _/        /_ )   ._    //  __    X      /___\______  \\" + "\n\r" + "            \     |__/  \_   |/  _/     /   //     /      /   /   >" + "\n\r" + "             \    |       /  /    \_   /    /_    /\     /   /   /" + "\n\r" + "              \__________/   \      /______/ /____/\___  X      /" + "\n\r" + "                        \___/ \____/                   \/ \____/" + "\n\r\n\r" + "                              www.thugcrowd.com"

# This is messy. It works, and isn't meant to be efficient. I just didn't want to process the bytes by hand.
def compress(string):
	string = bytearray(string.encode("utf-8"))
	string_array = []
	for i in range(len(string)):
		string_array.append(string[i])
	string_array.append(0x0)

	compressed_array = []
	index = 0
	total = len(string_array) - 1

	while index != (total + 1):
		current_char = string_array[index]
		forward_index = index + 1
		count = 1
		if index == total:
			compressed_array.append(hex(1))
			compressed_array.append(hex(current_char))
			break
		while current_char == string_array[forward_index]:
			forward_index = forward_index + 1
			count = count + 1
		compressed_array.append(hex(count))
		compressed_array.append(hex(current_char))
		index = forward_index

	compressed_string = ""
	for char in compressed_array:
		formatted_char = char[2:]
		if len(formatted_char) != 2:
			formatted_char = "0" + formatted_char
		compressed_string = compressed_string + formatted_char
	
	return compressed_string

# There's probably a much better way to do this, but this works...
def hexToInt(string):
	if len(string) != 2:
		print("ERROR, bailing out...")
		exit()
	first_digit = string[0]
	second_digit = string[1]
	if first_digit == "a":
		first_digit = 10
	elif first_digit == "b":
		first_digit = 11
	elif first_digit == "c":
		first_digit = 12
	elif first_digit == "d":
		first_digit = 13
	elif first_digit == "e":
		first_digit = 14
	elif first_digit == "f":
		first_digit = 15
	elif second_digit == "a":
		second_digit = 10
	elif second_digit == "b":
		second_digit = 11
	elif second_digit == "c":
		second_digit = 12
	elif second_digit == "d":
		second_digit = 13
	elif second_digit == "e":
		second_digit = 14
	elif second_digit == "f":
		second_digit = 15
	result = ( int(first_digit) * 16 ) + int(second_digit)
	return result

# This was only implemented to make sure that the string had been compressed properly.
# The actual algorithm in assembly looks nothing like this.
def uncompress(string):
	index = 0
	compressed_array = []
	uncompressed_bytes = bytearray()
	while index < len(string) - 1:
		new_chunk = [ string[index:index+2] , string[index+2:index+4] ]
		compressed_array.append(new_chunk)
		index = index + 4
	for chunk in compressed_array:
		count = hexToInt(chunk[0])
		char = chunk[1]
		new = bytearray.fromhex(count * char)
		uncompressed_bytes = uncompressed_bytes + new
	uncompressed_string = ""
	for char in uncompressed_bytes:
		uncompressed_string = uncompressed_string + chr(char)
	return uncompressed_string

# Break the bytes up into the format that NASM wants to see.
def formatForNASM(string):
	if len(string) % 2 != 0:
		print("Error! Bailing out....")
		exit()
	formatted = ""
	for i in range(len(string)):
		if i % 2 == 0:
			formatted = formatted + " , 0x"
			formatted = formatted + string[i:i+2]
	return formatted[3:]

compressed = compress(thugcrowd_logo)
formatted = formatForNASM(compressed)
print(formatted)
