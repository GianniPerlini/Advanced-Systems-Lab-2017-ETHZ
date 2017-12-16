
wt = [8,16,32,64]
clients=[1,4,8,12,16,20,24,28,32]


for w in wt:
	for c in clients:
		f1 = open("sthwt_mws_wt"+str(w)+"_c"+str(c)+".txt", "r")
		
		mw1 = []
		mws = []
		avg = []	
		
		for line in f1:
			if "WT" not in line and line != '\n':
				mw1.append(abs(float(line)))
			elif "WT" in line:
				mw1.append(0.0)


		for i in xrange(0, len(mw1)):
			if i != 0 and i != len(mw1) - 1:
				if mw1[i] == 0.0:
					avg.append(sum(mws)/len(mws))
					mws = []
				else:
					mws.append(mw1[i])
			elif i == len(mw1) - 1:
					mws.append(mw1[i])
					avg.append(sum(mws)/len(mws))				


		fi = open("sthwt_avg_mws_wt"+str(w)+"_c"+str(c)+".txt", "w")	
		c = 1
		for i in xrange(0, len(avg)):
			print>>fi, str(avg[i])

