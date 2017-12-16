from itertools import izip



workers = [8, 16, 32, 64]
clients = [1,4,8,12,16,20,24,28,32]

for w in workers:				
	for c in clients:
		
		avg = []
		th_avg = []


		f1 = open("GTHWT_avg_parsed_wt"+str(w)+"_c"+str(c)+".txt", "r")
		fi = open("GTHWT_avg_th_per_wt"+str(w)+"_c"+str(c)+".txt", "w")

		for line in f1:
			if "WT" not in line:
				avg.append(float(line))

		tot = sum(avg)

		avg = [avg[i:80 + i] for i in xrange(0, len(avg), 80)]
		
		for i in xrange(0, len(avg)):
			th_avg.append(sum(avg[i])/len(avg[i]))


		for i in xrange(0, len(th_avg)):
			print>>fi, "WT " + str(i) + ": " + str(th_avg[i])
		
		
		f1.close()
		fi.close()







