import sys
from math import sqrt

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

''' SET histogram
for item in set_list:
	item = item[0:item.index(".")+4].replace(" ", "")
	first = item[0:item.index("T")+1]
	second = item[item.index("T")+1:]
	print>>fi, first + " " + second
'''

th_per_sec = [th_per_sec[i:i+int(test_time)] for i in xrange(0, len(th_per_sec), int(test_time))]
rt_per_sec = [rt_per_sec[i:i+int(test_time)] for i in xrange(0, len(rt_per_sec), int(test_time))]

for i in range(0, len(th_per_sec)):
	del th_per_sec[i][:5]
	del th_per_sec[i][:-5]
	del rt_per_sec[i][:5]
	del rt_per_sec[i][:-5]
	# only one nan in one memtier conf
	rt_per_sec[i] = [x for x in rt_per_sec[i] if x != '-nan']
	th_per_sec[i] = [x for x in th_per_sec[i] if x != '0']

th_avg_per_run = map(float, th_avg_per_run)
rt_avg_per_run = map(float, rt_avg_per_run)


for i in range(0, len(th_per_sec)):
	th_per_sec[i] = map(float, th_per_sec[i])
	rt_per_sec[i] = map(float, rt_per_sec[i])


avg_th = []
avg_rt = []

#avg w/out warm up and cool down
for i in range(0, len(th_per_sec)):
	if len(th_per_sec[i]):	
		avg_th.append(sum(th_per_sec[i])/len(th_per_sec[i]))
	else:
		del th_per_sec[i]
	if len(rt_per_sec[i]):
		avg_rt.append(sum(rt_per_sec[i])/len(rt_per_sec[i]))
	else:
		del rt_per_sec[i]



n_clients = []
n_clients.append(1)

for i in range(1, 9):
	n_clients.append(i*4)

#print n_clients 
print>>plot, "#Clients	Avg Throughput		Avg Response Time"
for i in range(0, len(n_clients)):
	print>>plot, str(2*n_clients[i]) + "		" + str(avg_th[i]) +"		" + str(avg_rt[i]) 


f.close()
fi.close()
plot.close()


