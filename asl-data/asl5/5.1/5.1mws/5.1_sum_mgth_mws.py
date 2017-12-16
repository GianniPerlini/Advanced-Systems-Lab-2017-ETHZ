from math import sqrt
from itertools import izip


files = ["MGTH"]
ks = [3, 6, 9]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]

sums_run = []
avgs_wt = []
std_wt = []

avg_mw1 = []
avg_mw2 = []

fi = open("MGTH_data.txt", "w")
print>>fi, "Key Size\tAvg\tStd Dev"

name1 = "GTH_mw1_k1_tot.txt"
name2 = "GTH_mw2_k1_tot.txt"

fmw1 = open(name1, "r")
fmw2 = open(name2, "r")

for line in fmw1:
	if "AVG:" in line:
		avg_mw1.append(float(line.split(" ")[1]))

for line in fmw2:
	if "AVG:" in line:
		avg_mw2.append(float(line.split(" ")[1]))			

print len(avg_mw1)
print len(avg_mw2)

for i in range(0, len(avg_mw2)):

	if(len(avg_mw1) == len(avg_mw2)):
		sums_run.append(avg_mw1[i] + avg_mw2[i])

	else:
		sums_run.append(avg_mw2[i] + avg_mw2[i])

avg = 0

for s in sums_run:
	avg += s

avg /= len(sums_run)
avgs_wt.append(avg)

std = 0		
for s in sums_run:
	std += (s - avg) ** 2

std /= (len(sums_run) - 1)
std = sqrt(std)
std_wt.append(std)

print>>fi, "1\t" + str(avg) + "\t" + str(std)
fmw1.close()
fmw2.close()

del sums_run[:]
del avg_mw1[:]
del avg_mw2[:]


for k in ks:
	fmw1 = open("MGTH_mw1_k"+str(k)+"_tot.txt", "r")
	fmw2 = open("MGTH_mw2_k"+str(k)+"_tot.txt", "r")

	for line in fmw1:
		if "AVG:" in line:
			avg_mw1.append(float(line.split(" ")[1]))

	for line in fmw2:
		if "AVG:" in line:
			avg_mw2.append(float(line.split(" ")[1]))			

	print len(avg_mw1)
	print len(avg_mw2)

	for i in range(0, len(avg_mw2)):

		if(len(avg_mw1) == len(avg_mw2)):
			sums_run.append(avg_mw1[i] + avg_mw2[i])

		else:
			sums_run.append(avg_mw2[i] + avg_mw2[i])
	
	avg = 0

	for s in sums_run:
		avg += s

	avg /= len(sums_run)
	avgs_wt.append(avg)

	std = 0		
	for s in sums_run:
		std += (s - avg) ** 2

	std /= (len(sums_run) - 1)
	std = sqrt(std)
	std_wt.append(std)

	print>>fi, str(k) + "\t" + str(avg) + "\t" + str(std)
	fmw1.close()
	fmw2.close()

	del sums_run[:]
	del avg_mw1[:]
	del avg_mw2[:]

fi.close()








