from itertools import izip

rep = [1,2,3]
wt = [8,16, 32, 64]
clients=[1, 4, 8, 12, 16, 20, 24, 28, 32]

for w in wt:
	for c in clients:
		print str(w)+ " "+ str(c)
		avg1 = []
		avg2 = []
		avg3 = []
						
		f1 = open("sthwt_avg_mw2_r1_wt"+str(w)+"_c"+str(c)+".txt", "r")
		f2 = open("sthwt_avg_mw2_r2_wt"+str(w)+"_c"+str(c)+".txt", "r")
		f3 = open("sthwt_avg_mw2_r3_wt"+str(w)+"_c"+str(c)+".txt", "r")

		for line in f1:
			if "WT" not in line:
				avg1.append(float(line))
			else:
				avg1.append(0.0)

		for line in f2:
			if "WT" not in line:
				avg2.append(float(line))
			else:
				avg2.append(0.0)

		for line in f3:
			if "WT" not in line:
				avg3.append(float(line))
			else:
				avg3.append(0.0)
		avg = []

		print len(avg1)
		print len(avg2)
		print len(avg3)





