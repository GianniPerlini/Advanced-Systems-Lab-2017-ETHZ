
wt = [8,16,32,64]
clients=[1,4,8,12,16,20,24,28,32]


maxes = []

for w in wt:
	mx = 0
	
	for c in clients:
		f = open("sthwt_mws_wt"+str(w)+"_c"+str(c)+".txt", "r")	
		
		for line in f:
			if "WT" not in line and line != '\n':
				if mx < float(line):
					mx = float(line)

	maxes.append(mx)

print maxes
