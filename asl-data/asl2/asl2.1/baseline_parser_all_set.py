import sys
from math import sqrt
from math import isnan

def std_dev(lst, avg):
	count = 0
	part_std = 0
	for i in range(0, len(lst)):
		if isnan(lst[i]):
			count += 1
		else:
			part_std += (lst[i] - avg)**2

	std = (part_std / (len(lst) - 1 - count)) ** 0.5
	return std



test_time = sys.argv[1]
rep_name = sys.argv[2]
out_name = sys.argv[3]
data_name = sys.argv[4]

f = open(rep_name, "r")
fi = open(out_name, "w")
plot = open(data_name, "w")

# lines with [RUN #...
run_list = []
# th in lines with [RUN #...
th_per_sec = []
# lines with Sets
sets_list = []
# lines with SET
set_list = []
# th in Sets...
th_avg_per_run = []
# rt in [RUN #...
rt_per_sec = []
# rt in Sets
rt_avg_per_run = []

for line in f:
	if "[RUN #" in line and "ops" in line:
		run_list = line.splitlines()
		for i in range(0, len(run_list)):
			if "[RUN #" in line and "ops" in run_list[i]:
				th_per_sec.append(run_list[i].split("ops,")[1].split(" (")[0].replace(" ", ""))
				rt_per_sec.append(run_list[i].split("),")[1].split("(avg")[0].replace(" ", ""))

	elif "Sets" in line:
		sets_list.append(line)
	elif "SET" in line:
		set_list.append(line)


temp = []
tmp = ""
for item in sets_list:
	# in set cases, split based on --- of hits/misses
	th_avg_per_run.append(item.split("-")[0].replace(" ", "").replace("Sets", ""))
	temp = (item.split("---")[2].split(" "))
	for itm in temp:
		if itm != "":
			rt_avg_per_run.append(itm)
			tmp = itm
			break
	#print tmp
	print>>fi, item.split("-")[0].replace(" ", "").replace("Sets", "Avg TH: ")
	print>>fi, "Avg RT: " + tmp


th_avg_per_run = map(float, th_avg_per_run)
rt_avg_per_run = map(float, rt_avg_per_run)


n_clients = []
n_clients.append(1*3)

for i in range(1, 9):
	n_clients.append(i*4*3)

#print n_clients 
print>>plot, "#Clients	Avg Throughput	Avg Response Time"
for i in range(0, len(n_clients)):
	print>>plot, str(n_clients[i]) + "		" + str(th_avg_per_run[i]) + "		" + str(rt_avg_per_run[i])


f.close()
fi.close()
plot.close()


