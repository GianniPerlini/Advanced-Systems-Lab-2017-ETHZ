from math import sqrt

stats = ["TSendS"]
workers = [8, 16, 32, 64]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]

avgs_run = []
avgs_wt = []
std_wt = []

for s in stats:
	for w in workers:
		fi = open(s+"_wt"+str(w)+"_data.txt", "w")
		print>>fi, "Clients\tAvg\tStd Dev"
		for c in clients:
			name = s+"_c"+str(c)+"_wt"+str(w)+"_tot.txt"
			f = open(name, "r")
		
			for line in f:
				if "AVG:" in line:
					avgs_run.append(float(line.split(" ")[1]))
			avg = 0
			for a in avgs_run:
				avg += a

			avg /= len(avgs_run)
			avgs_wt.append(avg)
		
			std = 0		
			for a in avgs_run:
				std += (a - avg) ** 2
		
			std /= (len(avgs_run) - 1)
			std = sqrt(std)
			std_wt.append(std)

			print>>fi, str(c) + "\t" + str(avg) + "\t" + str(std)
			f.close()
			del avgs_run[:]

		fi.close
