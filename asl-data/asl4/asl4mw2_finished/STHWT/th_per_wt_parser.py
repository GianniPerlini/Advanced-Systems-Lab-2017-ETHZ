
rep = [1,2,3]
wt = [8,16, 32, 64]
clients=[1, 4, 8, 12, 16, 20, 24, 28, 32]


for r in rep:
	for w in wt:
		for c in clients:
			print str(r) + " " + str(w) + " " + str(c)
			f = open("STHWT_mw2_r"+str(r)+"_wt"+str(w)+"_c"+str(c)+".txt", "r")
			ls = []

			for line in f:
				if ":" in line:
					ls.append(float(line.split(":")[1]))


			ls = [ls[i:len(ls)- w + i:w] for i in xrange(0, w)]

			head = 0
						
			for i in xrange(0, len(ls)):
				head = ls[i][0]
				ls[i] = [abs(y - x) for x,y in zip(ls[i],ls[i][1:])]
				ls[i].insert(0, head)


			lst = []

			#lst = [lst[i:len(ls)- 80 + i:80] for i in xrange(0, 80)]

			fi = open("sthwt_avg_mw2_r"+str(r)+"_wt"+str(w)+"_c"+str(c)+".txt","w")
			for i in xrange(0, len(ls)):
				print>>fi, "WT "+str(i)
				for j in xrange(0, len(ls[i])):
					print>>fi, ls[i][j]

