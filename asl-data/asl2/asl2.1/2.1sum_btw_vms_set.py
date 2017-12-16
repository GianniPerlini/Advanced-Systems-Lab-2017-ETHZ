from itertools import izip
import sys

rep =sys.argv[1]
f1 = open("bl"+rep+"vm1_set_data.txt", "r")
f2 = open("bl"+rep+"vm2_set_data.txt", "r")
f3 = open("bl"+rep+"vm3_set_data.txt", "r")
fi = open("bl"+rep+"_set_tot.txt", "w")


c = []
sum_th = []
sum_rt = []

splitx = []
splity = []
splitz = []

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
		sum_rt.append((splitx[2]+splity[2]+splitz[2])/3)
	

print>>fi, "#Clients	Avg Throughput		Avg Response Time"
for i in range(0, len(c)):
	print>>fi, str(c[i]) + "		" + str(sum_th[i]) + "		" + str(sum_rt[i])

f1.close()
f2.close()
f3.close()
fi.close()






