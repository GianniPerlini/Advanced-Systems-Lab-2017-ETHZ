from itertools import izip



workers = [8, 16, 32, 64]
clients = [1,4,8,12,16,20,24,28,32]

for w in workers:				
	for c in clients:
		
		avg = []
		vr = []


		f1 = open("STHWT_avg_parsed_wt"+str(w)+"_c"+str(c)+".txt", "r")
		fi = open("STHWT_visit_ratio_wt"+str(w)+"_c"+str(c)+".txt", "w")

		for line in f1:
			if "WT" not in line:
				avg.append(float(line))

		tot = sum(avg)

		avg = [avg[i:80 + i] for i in xrange(0, len(avg), 80)]
		
		for i in xrange(0, len(avg)):
			vr.append(sum(avg[i])/tot)


		for i in xrange(0, len(vr)):
			print>>fi, "WT " + str(i) + ": " + str(vr[i])
		
		
		f1.close()
		fi.close()







