from math import sqrt
from itertools import izip

files = ["GRT", "TParseG", "TPG", "TSBG", "TSendG", "TIQG"]
#files = ["QL"]

sums_run = []
avgs_wt = []
std_wt = []

avg_mw1 = []
avg_mw2 = []

for f in files:
	fi = open(f+"_data.txt", "w")
	print>>fi, "Key Size\tAvg\tStd Dev"
	name1 = f+"_mw1_k1_tot.txt"
	name2 = f+"_mw2_k1_tot.txt"

	fmw1 = open(name1, "r")
	fmw2 = open(name2, "r")
	
	if f == "QL":
		for line in fmw1:
			if "r" not in line and line != '\n':
				avg_mw1.append(float(line))

		for line in fmw2:
			if "r" not in line and line != '\n':
				avg_mw2.append(float(line))

	else:	
		for line in fmw1:
			if "AVG:" in line:
				avg_mw1.append(float(line.split(" ")[1]))

		for line in fmw2:
			if "AVG:" in line:
				avg_mw2.append(float(line.split(" ")[1]))			

	print len(avg_mw1)
	print len(avg_mw2)

	for i in range(0, len(avg_mw2)):

		if(len(avg_mw1) == len(avg_mw2)):
			sums_run.append((avg_mw1[i] + avg_mw2[i])/2)

		else:
			sums_run.append((avg_mw2[i] + avg_mw2[i])/2)
	
	avg = 0

	for s in sums_run:
		avg += s

	avg /= len(sums_run)
	avgs_wt.append(avg)

	std = 0		
	for s in sums_run:
		std += (s - avg) ** 2

	std /= (len(sums_run) - 1)
	std = sqrt(std)
	std_wt.append(std)

	print>>fi, "1\t" + str(avg) + "\t" + str(std)
	fmw1.close()
	fmw2.close()

	del sums_run[:]
	del avg_mw1[:]
	del avg_mw2[:]

fi.close()


files = ["RTMG", "TParseMG", "TPMG", "TSRBMG", "TSendMG", "TIQG"]
ks = [3, 6, 9]

for f in files:
	fi = open(f+"_data.txt", "w")
	print>>fi, "Key Size\tAvg\tStd Dev"
	for k in ks:

		name1 = f+"_mw1_k"+str(k)+"_tot.txt"
		name2 = f+"_mw2_k"+str(k)+"_tot.txt"

		fmw1 = open(name1, "r")
		fmw2 = open(name2, "r")
		
		if f == "QL_get":
			for line in fmw1:
				if "r" not in line and line != '\n':
					avg_mw1.append(float(line))

			for line in fmw2:
				if "r" not in line and line != '\n':
					avg_mw2.append(float(line))

		else:	
			for line in fmw1:
				if "AVG:" in line:
					avg_mw1.append(float(line.split(" ")[1]))
	
			for line in fmw2:
				if "AVG:" in line:
					avg_mw2.append(float(line.split(" ")[1]))			

		print len(avg_mw1)
		print len(avg_mw2)

		for i in range(0, len(avg_mw2)):

			if(len(avg_mw1) == len(avg_mw2)):
				sums_run.append((avg_mw1[i] + avg_mw2[i])/2)

			else:
				sums_run.append((avg_mw2[i] + avg_mw2[i])/2)
		
		avg = 0

		for s in sums_run:
			avg += s

		avg /= len(sums_run)
		avgs_wt.append(avg)
	
		std = 0		
		for s in sums_run:
			std += (s - avg) ** 2
	
		std /= (len(sums_run) - 1)
		std = sqrt(std)
		std_wt.append(std)

		print>>fi, str(k) + "\t" + str(avg) + "\t" + str(std)
		fmw1.close()
		fmw2.close()

		del sums_run[:]
		del avg_mw1[:]
		del avg_mw2[:]

	fi.close()
