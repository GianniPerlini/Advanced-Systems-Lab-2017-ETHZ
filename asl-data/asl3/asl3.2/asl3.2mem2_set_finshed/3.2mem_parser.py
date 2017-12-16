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



'''
for i in range(0, len(th_per_sec)):
	print>>fi, "RUN "+str(i)+" TH: " + th_per_sec[i]
	print>>fi, "RUN "+str(i)+" RT: " + rt_per_sec[i]

'''

#for item in data_list:
	#print>>fi, item
#print run_list
#print run_list[0]
#print sets_list

'''
for i in range(0, len(run_list)):
	#print>>fi, "RUN "+str(i)+" TH: " + run_list[i].split("ops,")[1].split(" (")[0]
	run_string = "".join(run_list[i])
	th_per_sec.append(run_string.split("ops,")[1].split(" (")[0].replace(" ", ""))
	rt_per_sec.append(run_string.split("),")[1].split("(avg")[0].replace(" ", ""))
	print>>fi, "RUN "+str(i)+" TH: " + th_per_sec[i]
	print>>fi, "RUN "+str(i)+" RT: " + rt_per_sec[i]
'''
'''
for i in range(0, len(th_per_sec)):
	th_per_sec[i] = th_per_sec[i].replace(" ", "")
	print>>fi, "RUN "+str(i)+" TH: " + th_per_sec[i]
'''

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

# i+test-time
print len(th_per_sec)
th_per_sec = [th_per_sec[i:i+int(test_time)] for i in xrange(0, len(th_per_sec), int(test_time))]
rt_per_sec = [rt_per_sec[i:i+int(test_time)] for i in xrange(0, len(rt_per_sec), int(test_time))]

for i in range(0, len(th_per_sec)):
	del th_per_sec[i][:5]
	del th_per_sec[i][:-5]
	del rt_per_sec[i][:5]
	del rt_per_sec[i][:-5]
	rt_per_sec[i] = [x for x in rt_per_sec[i] if x != '-nan']
	th_per_sec[i] = [x for x in th_per_sec[i] if x != '0']


th_std_dev = []
th_part_std = 0
rt_std_dev = []
rt_part_std = 0

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

print th_per_sec

for i in range(0, len(th_per_sec)):
	th_std_dev.append(std_dev(th_per_sec[i], avg_th[i]));
	rt_std_dev.append(std_dev(rt_per_sec[i], avg_rt[i]));

'''
for i in range(0, len(th_per_sec)):
	th_std_dev.append(std_dev(th_per_sec[i], th_avg_per_run[i]));
	rt_std_dev.append(std_dev(rt_per_sec[i], rt_avg_per_run[i]));
'''

'''
for i in range(0, len(th_avg_per_run)):
	for j in range(0, len(th_per_sec[i])):
		th_part_std += (float(th_per_sec[i][j]) - float(th_avg_per_run[i]))**2
		rt_part_std += (float(rt_per_sec[i][j]) - float(rt_avg_per_run[i]))**2
	
	th_std_dev.append( (th_part_std / (len(th_avg_per_run) - 1))**0.5 )
	th_part_std = 0
	rt_std_dev.append( (rt_part_std / (len(rt_avg_per_run) - 1))**0.5 )
	rt_part_std = 0
'''
#print th_std_dev
#print rt_std_dev

n_clients = []
n_clients.append(1)

for i in range(1, 9):
	n_clients.append(i*4)

#print n_clients 
print>>plot, "#Clients	Avg Throughput		Avg Response Time"
for i in range(0, len(n_clients)):
	print>>plot, str(2*n_clients[i]) + "		" + str(avg_th[i]) + "		" + str(avg_rt[i])


f.close()
fi.close()
plot.close()


