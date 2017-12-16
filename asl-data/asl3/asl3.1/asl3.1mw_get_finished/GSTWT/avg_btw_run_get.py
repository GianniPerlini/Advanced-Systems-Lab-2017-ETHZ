from itertools import izip



workers = [8, 16, 32, 64]
clients = [1,4,8,12,16,20,24,28,32]

for w in workers:				
	for c in clients:
		
		avg = []


		f1 = open("GSTWT_r1_wt"+str(w)+"_c"+str(c)+".txt", "r")
		f2 = open("GSTWT_r2_wt"+str(w)+"_c"+str(c)+".txt", "r")
		f3 = open("GSTWT_r3_wt"+str(w)+"_c"+str(c)+".txt", "r")
		fi = open("GSTWT_avg_wt"+str(w)+"_c"+str(c)+".txt", "w")

		for x, y, z in izip(f1, f2, f3):
			if x != "SEC 81":
				if "SEC" not in x and x != '\n':

					avgx = float(x.split(":")[1])
					avgy = float(y.split(":")[1])
					avgz = float(z.split(":")[1])

					avg.append((avgx+avgy+avgz)/3000000)

		print>>fi, "SEC 1"
		for i in xrange(0, len(avg)):
			if i != 0 and i % w == 0:
				print>>fi, "SEC " + str(i/w+1)
			print>>fi, avg[i]
		
		
		f1.close()
		f2.close()
		f3.close()
		fi.close()







