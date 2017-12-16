

rep = [1,2,3]
wt = [8, 32]
files = ["GRT", "GTH"]

for fi in files:
	for r in rep:
		for w in wt:

			f = open(fi+"_mw2_r"+ str(r) + "_wt"+str(w)+".txt", "r+b")
				
			avg = 0
			stats = []

			for line in f:
				stats.append(float(line))
		
		
			for i in range(5, len(stats) - 5):
				avg += stats[i]

			avg /= (len(stats) - 10)

			print>>f, "AVG: " + str(avg)
			f.close()
