

rep = [1,2,3]
ks = [1, 3, 6, 9]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]
files = ["SRT", "STH", "TIQS", "TParseS", "TPS", "TSBS", "TSendS"]

for fi in files:
	for r in rep:
		for k in ks:
			f = open(fi+"_mw2_r"+ str(r) + "_k"+str(k)+".txt", "r+b");
			avg = 0
			stats = []

			for line in f:
				stats.append(float(line))
		
		
			for i in range(5, len(stats) - 5):
				avg += stats[i]

			avg /= (len(stats) - 10)

			print>>f, "AVG: " + str(avg)
			f.close()
