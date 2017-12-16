from itertools import izip


reps = [1,2,3]
workers = [8, 16, 32, 64]

for r in reps:
	for w in workers:				
		c = []
		sum_th = []
		sum_rt = []

		splitx = []
		splity = []
		splitz = []

		thtemp1 = []
		thtemp2 = []
		thtemp3 = []

		rttemp1 = []
		rttemp2 = []
		rttemp3 = []

		
		f1 = open("mw1_mem1r"+str(r)+"wt"+str(w)+"_data.txt", "r")
		f2 = open("mw2_mem1r"+str(r)+"wt"+str(w)+"_data.txt", "r")
		fi = open("mws_r"+str(r)+"wt"+str(w)+"_tot.txt", "w")

		for x, y in izip(f1, f2):
			if "#" not in x:

				splitx = x.split("\t")
				splity = y.split("\t")

				splitx[:] = [x for x in splitx if x != ""]
				splity[:] = [x for x in splity if x != ""]

				splitx = map(float, splitx)
				splity = map(float, splity)

				c.append(int(splitx[0]))

				thtemp1.append(splitx[1])
				thtemp2.append(splity[1])
				
				rttemp1.append(splitx[2])
				rttemp2.append(splity[2])
	
				sum_th.append((splitx[1]+splity[1]))
				sum_rt.append((splitx[2]+splity[2])/2)
				
	



		print>>fi, "#Clients	Avg Throughput		Avg Response Time"
		for i in range(0, len(c)):
			print>>fi, str(c[i]) + "		" + str(sum_th[i])+ "		" + str(sum_rt[i])
		f1.close()
		f2.close()
		fi.close()







