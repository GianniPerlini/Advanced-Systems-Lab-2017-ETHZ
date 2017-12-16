from math import sqrt
from itertools import izip

stats = ["STH"]
workers = [8, 16, 32, 64]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]

sums_run = []
avgs_wt = []
std_wt = []

for s in stats:
	for w in workers:
		fi = open(s+"_wt"+str(w)+"_data.txt", "w")
		print>>fi, "Clients\tAvg\tStd Dev"
		for c in clients:
			name1 = s+"_mw1_c"+str(c)+"_wt"+str(w)+"_tot.txt"
			name2 = s+"_mw2_c"+str(c)+"_wt"+str(w)+"_tot.txt"

			fmw1 = open(name1, "r")
			fmw2 = open(name2, "r")
		
			for x,y in izip(fmw1, fmw2):
				if "AVG:" in x:

			for s in sums_run:
				avg += s

			avg /= len(sums_run)
			avgs_wt.append(avg)
		
			for s in sums_run:
				std += (s - avg) ** 2
		
			std /= (len(sums_run) - 1)
			std = sqrt(std)
			std_wt.append(std)

			print>>fi, str(c) + "\t" + str(avg) + "\t" + str(std)
			fmw1.close()
			fmw2.close()
			del sums_run[:]

		fi.close
