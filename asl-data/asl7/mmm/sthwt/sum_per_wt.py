
wt = [8,16,32,64]
clients=[1,4,8,12,16,20,24,28,32]


for w in wt:
	for c in clients:
		f1 = open("sthwt_avg_mw1_wt"+str(w)+"_c"+str(c)+".txt", "r")
		f2 = open("sthwt_avg_mw2_wt"+str(w)+"_c"+str(c)+".txt", "r")
		
		mw1 = []
		mw2 = []
		mws = []		
		
		for line in f1:
			if "WT" not in line and line != '\n':
				mw1.append(abs(float(line)))
			elif "WT" in line:
				mw1.append(0.0)


		for line in f2:
			if "WT" not in line and line != '\n':
				mw2.append(float(line))
			elif "WT" in line:
				mw2.append(0.0)



		print len(mw1)
		print len(mw2)


		for i in xrange(0, min(len(mw1), len(mw2))):
			mws.append(mw1[i]+mw2[i])


		fi = open("sthwt_mws_wt"+str(w)+"_c"+str(c)+".txt", "w")	
		c = 1
		for i in xrange(0, len(mws)):
			if mws[i] == 0.0:
				print>>fi, "WT" + str(c)
				c += 1
			else:
				print>>fi, mws[i]

