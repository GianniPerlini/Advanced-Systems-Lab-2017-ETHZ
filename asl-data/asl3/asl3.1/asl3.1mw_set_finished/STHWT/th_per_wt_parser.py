
wt = [8,16,32,64]
clients=[1,4,8,12,16,20,24,28,32]


for w in wt:
	for c in clients:
		print str(w) + " " + str(c)
		f = open("STHWT_avg_wt"+str(w)+"_c"+str(c)+".txt", "r")
		ls = []

		for line in f:
			if "SEC" not in line:
				ls.append(float(line))


		ls = [ls[i:len(ls)- w + i:w] for i in xrange(0, w)]

		head = 0

		for i in range(0, len(ls)):
			head = ls[i][0]
			ls[i] = [abs(y-x) for x,y in zip(ls[i],ls[i][1:])]
			ls[i].insert(0, head)
		
		fi = open("STHWT_avg_parsed_wt"+str(w)+"_c"+str(c)+".txt", "w")

		for i in range(0, len(ls)):
			print>>fi, "WT"+str(i)

			for j in range(0, len(ls[i])):
				print>>fi, ls[i][j]


