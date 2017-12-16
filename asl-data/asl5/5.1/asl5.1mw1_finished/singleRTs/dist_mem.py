
f = open("memk6get.txt", "r")

fi = open("prova.txt", "w")

b = [0] * 26
c = 0.0
for line in f:
	c += 1
	if float(line) < 1/2:
		 b[0] += 1
	elif float(line) < 2/2:
		 b[1] += 1
	elif float(line) < 3/2:
		 b[2] += 1
	elif float(line) < 4/2:
		 b[3] += 1
	elif float(line) < 5/2:
		 b[4] += 1
	elif float(line) < 6/2:
		 b[5] += 1
	elif float(line) < 7/2:
		 b[6] += 1
	elif float(line) < 8/2:
		 b[7] += 1
	elif float(line) < 9/2:
		 b[8] += 1
	elif float(line) < 10/2:
		 b[9] += 1

	elif float(line) < 11/2:
		 b[10] += 1

	elif float(line) < 12/2:
		 b[11] += 1

	elif float(line) < 13/2:
		 b[12] += 1

	elif float(line) < 14/2:
		 b[13] += 1

	elif float(line) < 30/4:
		 b[14] += 1

	elif float(line) < 32/4:
		 b[15] += 1

	elif float(line) < 34/4:
		 b[16] += 1

	elif float(line) < 36/4:
		 b[17] += 1

	elif float(line) < 38/4:
		 b[18] += 1

	elif float(line) < 40/4:
		 b[19] += 1

	elif float(line) < 42/4:
		 b[20] += 1

	elif float(line) < 44/4:
		 b[21] += 1

	elif float(line) < 46/4:
		 b[22] += 1

	elif float(line) < 48/4:
		 b[23] += 1

	elif float(line) < 50/4:
		 b[24] += 1

	else:
		b[25] += 1


'''
for x in b:
	if x != 0:
		print>>fi, x/c*100

'''
for x in range(0, len(b)):
		print>>fi, str(b[x]/c*100)



