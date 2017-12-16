import sys

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
# lines with Gets
gets_list = []
# lines with GET
get_list = []
# th in Sets...
th_avg_per_run = []
# rt in [RUN #...
rt_per_sec = []
# rt in Sets
rt_avg_per_run = []
# cache miss ratio
misses = []

for line in f:
	if "[RUN #" in line and "ops" in line:
		run_list = line.splitlines()
		for i in range(0, len(run_list)):
			th_per_sec.append(run_list[i].split("ops,")[1].split(" (")[0].replace(" ", ""))
			rt_per_sec.append(run_list[i].split("),")[1].split("(avg")[0].replace(" ", ""))
			
	elif "Gets" in line:
		gets_list.append(line)
	elif "GET" in line:
		get_list.append(line)

for i in range(0, len(th_per_sec)):
	print>>fi, "RUN "+str(i)+" TH: " + th_per_sec[i]
	print>>fi, "RUN "+str(i)+" RT: " + rt_per_sec[i]



temp = []
tmp = ""
for item in gets_list:
	tmp = item.split(" ")
	for i in range(0, len(tmp)):
		if tmp[i] != "":
			temp.append(tmp[i])

	th_avg_per_run.append(temp[1])
	misses.append(temp[3])
	rt_avg_per_run.append(temp[4])
	#print tmp
	print>>fi, "Avg TH: " + temp[1]
	print>>fi, "Cache Misses: " + temp[3]
	print>>fi, "Avg RT: " + temp[4]
	temp = []


th_avg_per_run = map(float, th_avg_per_run)
rt_avg_per_run = map(float, rt_avg_per_run)

n_clients = []
n_clients.append(1*3)

for i in range(1, 9):
	n_clients.append(i*4*3)

print>>plot, "#Clients	Avg Throughput	Avg Response Time"
for i in range(0, len(n_clients)):
	print>>plot, str(n_clients[i]) + "		" + str(th_avg_per_run[i]) + "		" + str(rt_avg_per_run[i])


f.close()
fi.close()
plot.close()

