

f = open("singleSRt_mw2_r3_k6.txt", "r")

fi = open("prova_mw.txt", "w")

b = [0] * 14
c = 0.0
for line in f:
	c += 1
	if float(line)/1000000.0 < 0.9:
		 b[0] += 1
	elif float(line)/1000000.0 < 1:
		 b[1] += 1
	elif float(line)/1000000.0 < 1.13:
		 b[2] += 1
	elif float(line)/1000000.0 < 1.79:
		 b[3] += 1
	elif float(line)/1000000.0 < 2:
		 b[4] += 1
	elif float(line)/1000000.0 < 3:
		 b[5] += 1
	elif float(line)/1000000.0 < 4:
		 b[6] += 1
	elif float(line)/1000000.0 < 5:
		 b[7] += 1
	elif float(line)/1000000.0 < 6:
		 b[8] += 1

	elif float(line)/1000000.0 < 7:
		 b[9] += 1

	elif float(line)/1000000.0 < 7.06:
		 b[10] += 1

	elif float(line)/1000000.0 < 8:
		 b[11] += 1

	elif float(line)/1000000.0 < 9:
		 b[12] += 1
	else:
		b[13] += 1

'''
for x in b:
	if x != 0:
		print>>fi, x/c*100

'''
for x in range(0, len(b)):
		print>>fi, str(b[x]/c*100)


'''

	elif float(line)/1000000.0 < 10:
		 b[9] += 1

	elif float(line)/1000000.0 < 11:
		 b[10] += 1

	elif float(line)/1000000.0 < 12:
		 b[11] += 1

	elif float(line)/1000000.0 < 13:
		 b[12] += 1

	elif float(line)/1000000.0 < 14:
		 b[13] += 1

	elif float(line)/1000000.0 < 30:
		 b[14] += 1

	elif float(line)/1000000.0 < 32:
		 b[15] += 1

	elif float(line)/1000000.0 < 34:
		 b[16] += 1

	elif float(line)/1000000.0 < 36:
		 b[17] += 1

	elif float(line)/1000000.0 < 38:
		 b[18] += 1

	elif float(line)/1000000.0 < 40:
		 b[19] += 1

	elif float(line)/1000000.0 < 42:
		 b[20] += 1

	elif float(line)/1000000.0 < 44:
		 b[21] += 1

	elif float(line)/1000000.0 < 46:
		 b[22] += 1

	elif float(line)/1000000.0 < 48:
		 b[23] += 1

	elif float(line)/1000000.0 < 50:
		 b[24] += 1

	elif float(line)/1000000.0 < 13:
		 b[25] += 1
'''
