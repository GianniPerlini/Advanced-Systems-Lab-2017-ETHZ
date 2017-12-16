

rep = [1,2,3]
ks = [1, 3, 6, 9]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]
files = ["AR"]

for fi in files:
	for r in rep:
		for k in ks:
			for c in clients:
				f = open(fi+"_mw1_r"+ str(r) + "_k"+str(k)+".txt", "r");
				

				avgs = f.readlines()
				f.close()

				f = open(fi+"_mw1_r"+ str(r) + "_k"+str(k)+".txt", "w");
				

				for line in avgs:
					if line != '\n' and "AVG: " not in line:
						f.write(line)

				f.close()
				f = open(fi+"_mw1_r"+ str(r) + "_k"+str(k)+".txt", "r+b");
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

