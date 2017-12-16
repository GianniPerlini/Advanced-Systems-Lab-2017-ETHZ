from itertools import izip



workers = [8, 16, 32, 64]
clients = [1,4,8,12,16,20,24,28,32]

for w in workers:				
	for c in clients:
		
		avg = []

		f1 = open("SSTWT_avg_wt"+str(w)+"_c"+str(c)+".txt", "r")
		fi = open("SSTWT_avg_per_wt_wt"+str(w)+"_c"+str(c)+".txt", "w")

		for line in f1:
			if "SEC" not in line:
				avg.append(float(line))

		avg = [avg[i:len(avg) - w + i:w] for i in xrange(0, w)]

		for i in xrange(0, len(avg)):
			avg[i] = sum(avg[i])/len(avg[i])


		for i in xrange(0, len(avg)):
			print>>fi, "WT " + str(i) + ": " + str(avg[i])
		
		
		f1.close()
		fi.close()







