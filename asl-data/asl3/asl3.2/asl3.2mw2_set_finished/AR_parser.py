

rep = [1,2,3]
wt = [8, 16, 32, 64]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]
files = ["AR_set"]

for fi in files:
	for r in rep:
		for w in wt:
			for c in clients:
				f = open(fi+"_mw2_r"+ str(r) + "_wt"+str(w)+"_c"+str(c)+".txt", "r");
				

				avgs = f.readlines()
				f.close()

				f = open(fi+"_mw2_r"+ str(r) + "_wt"+str(w)+"_c"+str(c)+".txt", "w");
				

				for line in avgs:
					if line != '\n' and "AVG: " not in line:
						f.write(line)

				f.close()
				f = open(fi+"_mw2_r"+ str(r) + "_wt"+str(w)+"_c"+str(c)+".txt", "r+b")
				stats = []
				avg = 0
				for line in f:
					if float(line) < 10000:
						stats.append(float(line))
			
				for i in range(5, len(stats) - 5):
					avg += stats[i]

				avg /= (len(stats) - 10)

				print>>f, "AVG: " + str(avg)
				f.close()

