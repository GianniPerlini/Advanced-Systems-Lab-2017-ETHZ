from math import sqrt
from itertools import izip

workers = [8, 32]

avgs_set = []
avgs_get = []
avgs_wt = []
std_wt = []
sums_run = []

for w in workers:
		fi = open("TH_wt"+str(w)+"_data.txt", "w")
		print>>fi, "Configuration\tAvg"

		name1 = "GTH_wt"+str(w)+"_tot.txt"
		name2 = "STH_wt"+str(w)+"_tot.txt"

		f1 = open(name1, "r")
		f2 = open(name2, "r")

		for line in f1:
			if "AVG:" in line:
				avgs_get.append(float(line.split(" ")[1]))


		for line in f2:
			if "AVG:" in line:
				avgs_set.append(float(line.split(" ")[1]))

		for i in range(0, len(avgs_get)):
			sums_run.append(avgs_get[i] + avgs_set[i])


		avg = 0
		for s in sums_run:
			avg += s

		avg /= len(sums_run)

		print>>fi, "1mw2s"+str(w)+"wt\t" + str(avg)
		f1.close()
		f2.close()
		del avgs_set[:]
		del avgs_get[:]
		del sums_run[:]

fi.close


for w in workers:
		fi = open("RT_wt"+str(w)+"_data.txt", "w")
		print>>fi, "Configuration\tAvg"

		name1 = "GRT_wt"+str(w)+"_tot.txt"
		name2 = "SRT_wt"+str(w)+"_tot.txt"

		f1 = open(name1, "r")
		f2 = open(name2, "r")

		for line in f1:
			if "AVG:" in line:
				avgs_get.append(float(line.split(" ")[1]))


		for line in f2:
			if "AVG:" in line:
				avgs_set.append(float(line.split(" ")[1]))

		for i in range(0, len(avgs_get)):
			sums_run.append((avgs_get[i] + avgs_set[i])/2)


		avg = 0
		for s in sums_run:
			avg += s

		avg /= len(sums_run)

		print>>fi, "1mw2s"+str(w)+"wt\t" + str(avg/1000000)
		f1.close()
		f2.close()
		del avgs_set[:]
		del avgs_get[:]
		del sums_run[:]

fi.close
