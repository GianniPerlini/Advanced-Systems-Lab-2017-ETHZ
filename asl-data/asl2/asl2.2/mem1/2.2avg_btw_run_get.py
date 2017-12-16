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

thtemp1 = []
thtemp2 = []
thtemp3 = []

rttemp1 = []
rttemp2 = []
rttemp3 = []

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
		
		thtemp1.append(splitx[1])
		thtemp2.append(splity[1])
		thtemp3.append(splitz[1])

		rttemp1.append(splitx[3])
		rttemp2.append(splity[3])
		rttemp3.append(splitz[3])

		avg_th.append((splitx[1]+splity[1]+splitz[1])/3)
		avg_rt.append((splitx[3]+splity[3]+splitz[3])/3)


thstd = []
tht = 0
rtt = 0
rtstd = []

for i in range(0, len(thtemp1)):
	tht = (thtemp1[i] - avg_th[i]) ** 2 + (thtemp2[i] - avg_th[i]) ** 2 + (thtemp3[i] - avg_th[i]) ** 2
	tht = (tht / 2) ** 0.5
	thstd.append(tht)

	rtt = (rttemp1[i] - avg_rt[i]) ** 2 + (rttemp2[i] - avg_rt[i]) ** 2 + (rttemp3[i] - avg_rt[i]) ** 2
	rtt = (rtt / 2) ** 0.5
	rtstd.append(rtt)

	tht = 0
	rtt = 0

print>>fi, "#Clients	Avg Throughput		Th Std Dev		Avg Response Time		Rt Std Dev"
for i in range(0, len(c)):
	print>>fi, str(c[i]) + "		" + str(avg_th[i]) + "		" + str(thstd[i]) + "		" + str(avg_rt[i]) + "				" + str(rtstd[i])


f1.close()
f2.close()
f3.close()
fi.close()
