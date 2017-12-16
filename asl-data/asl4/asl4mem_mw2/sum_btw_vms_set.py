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

		
		f1 = open("mw2_mem1r"+str(r)+"wt"+str(w)+"_data.txt", "r")
		f2 = open("mw2_mem2r"+str(r)+"wt"+str(w)+"_data.txt", "r")
		f3 = open("mw2_mem3r"+str(r)+"wt"+str(w)+"_data.txt", "r")
		fi = open("mw2_r"+str(r)+"wt"+str(w)+"_tot.txt", "w")

		for x, y, z in izip(f1, f2, f3):
			if "#" not in x:

				splitx = x.split("\t")
				splity = y.split("\t")
				splitz = z.split("\t")

				splitx[:] = [x for x in splitx if x != ""]
				splity[:] = [x for x in splity if x != ""]
				splitz[:] = [x for x in splitz if x != ""]

				splitx = map(float, splitx)
				splity = map(float, splity)
				splitz = map(float, splitz)

				c.append(int(splitx[0]))
		
				sum_th.append((splitx[1]+splity[1]+splitz[1]))
				sum_rt.append((splitx[3]+splity[3]+splitz[3])/3)
	

		print>>fi, "#Clients	Avg Throughput		Avg Response Time"
		for i in range(0, len(c)):
			print>>fi, str(c[i]) + "		" + str(sum_th[i])+ "		" + str(sum_rt[i])
		f1.close()
		f2.close()
		f3.close()
		fi.close()






