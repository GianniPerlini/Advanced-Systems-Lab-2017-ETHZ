from itertools import izip

f1 = open("bl1_get_data.txt", "r")
f2 = open("bl2_get_data.txt", "r")
f3 = open("bl3_get_data.txt", "r")
fi = open("bl_get_tot.txt", "w")

c = []
avg_th = []
std_th = []
avg_rt = []
std_rt = []
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

		print splitx
		print splity
		print splitz

		c.append(int(splitx[0]))
		
		avg_th.append((splitx[1]+splity[1]+splitz[1])/3)
		std_th.append((splitx[2]+splity[2]+splitz[2])/3)
		avg_rt.append((splitx[3]+splity[3]+splitz[3])/3)
		std_rt.append((splitx[4]+splity[4]+splitz[4])/3)

print c


print>>fi, "#Clients	Avg Throughput		Th Std Dev		Avg Response Time		Rt Std Dev"
for i in range(0, len(c)):
	print>>fi, str(c[i]) + "		" + str(avg_th[i]) + "		" + str(std_th[i]) + "		" + str(avg_rt[i]) + "				" + str(std_rt[i])


f1.close()
f2.close()
f3.close()
fi.close()
