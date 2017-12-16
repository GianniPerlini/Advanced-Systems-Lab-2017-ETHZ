

rep = [1,2,3]
wt = [8, 16, 32, 64]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]
files = ["SRT", "STH", "TIQ", "TParseS", "TPS", "TSBS", "TSendS"]

for fi in files:
	for r in rep:
		for w in wt:
			for c in clients:
				f = open(fi+"_mw2_r"+ str(r) + "_wt"+str(w)+"_c"+str(c)+".txt", "r+b");
				avg = 0
				stats = []

				for line in f:
					stats.append(float(line))
			
			
				for i in range(5, len(stats) - 5):
					avg += stats[i]

				avg /= (len(stats) - 10)

				print>>f, "AVG: " + str(avg)
				f.close()
