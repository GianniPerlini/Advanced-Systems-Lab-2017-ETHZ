from math import sqrt
from itertools import izip

stats = ["STH", "SRT"]
workers = [8, 32]

sums_run = []
avgs_wt = []
std_wt = []

avg_mw1 = []
avg_mw2 = []

for st in stats:
	for w in workers:
		name1 = str(st)+"_mw1_wt"+str(w)+"_tot.txt"
		name2 = str(st)+"_mw2_wt"+str(w)+"_tot.txt"

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
			if st == "STH":
				sums_run.append(avg_mw1[i] + avg_mw2[i])
			else:
				sums_run.append((avg_mw1[i] + avg_mw2[i])/2)
		
		fi = open(str(st)+"_wt"+str(w)+"_avg_per_run.txt", "w")
		print>>fi, "Config\trun1\trun2\trun3"
		print>>fi, "2s2mw"+str(w)+"wt\t"+str(sums_run[0])+"\t"+str(sums_run[1])+"\t"+str(sums_run[2	])
		fi.close()

		del sums_run[:]
		del avg_mw1[:]
		del avg_mw2[:]

