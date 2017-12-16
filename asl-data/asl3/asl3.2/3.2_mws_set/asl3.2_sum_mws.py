from math import sqrt
from itertools import izip
#"SRT", "STH", "TIQ_set", "TParseS", "TPS", "TSBS", "TSendS"

#files = ["AR_set"]
#files = ["STH"]
files = ["SRT", "TIQ_set", "TParseS", "TPS", "TSBS", "TSendS"]
#files = ["QL_set"]
workers = [8, 16, 32, 64]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]

sums_run = []
avgs_wt = []
std_wt = []

avg_mw1 = []
avg_mw2 = []

for f in files:
	for w in workers:
		fi = open(f+"_wt"+str(w)+"_avg_data.txt", "w")
		print>>fi, "Clients\tAvg\tStd Dev"
		for c in clients:
			name1 = f+"_mw1_c"+str(c)+"_wt"+str(w)+"_tot.txt"
			name2 = f+"_mw2_c"+str(c)+"_wt"+str(w)+"_tot.txt"

			fmw1 = open(name1, "r")
			fmw2 = open(name2, "r")
			
			if f == "QL_set":
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
					# for th, ql and ar, do sum instead avg
					sums_run.append((avg_mw1[i] + avg_mw2[i])/2)

				else:
					sums_run.append((avg_mw1[i] + avg_mw2[i])/2)
			
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

			print>>fi, str(2*c) + "\t" + str(avg) + "\t" + str(std)
			fmw1.close()
			fmw2.close()

			del sums_run[:]
			del avg_mw1[:]
			del avg_mw2[:]

		fi.close
