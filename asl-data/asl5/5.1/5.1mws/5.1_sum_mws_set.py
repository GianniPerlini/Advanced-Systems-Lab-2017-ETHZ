from math import sqrt
from itertools import izip

files = ["TPS"]

ks = [1, 3, 6, 9]

sums_run = []
avgs_wt = []
std_wt = []

avg_mw1 = []
avg_mw2 = []

for f in files:
	fi = open(f+"_data.txt", "w")
	print>>fi, "Key Size\tAvg\tStd Dev"

	for k in ks:
		name1 = f+"_mw1_k"+str(k)+"_tot.txt"
		name2 = f+"_mw2_k"+str(k)+"_tot.txt"

		fmw1 = open(name1, "r")
		fmw2 = open(name2, "r")

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
				if f == "STH":
					sums_run.append(avg_mw1[i] + avg_mw2[i])
				else:
					sums_run.append((avg_mw1[i] + avg_mw2[i])/2)

			else:
				if f == "STH":
					sums_run.append(avg_mw2[i] + avg_mw2[i])
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
