	

rep = [1,2,3]
wt = [8, 16, 32, 64]
clients = [1, 4, 8, 12, 16, 20, 24, 28, 32]

for r in rep:

	f = open("SL_mw1_r"+str(r)+"_k1.txt", "r")
	fi = open("SL_mw1_r"+str(r)+"_k1_data.txt", "w")

	s1 = []
	s2 = []
	s3 = []

	for line in f:
		line = line.strip()
		if "S1" in line:
			s1.append(line.split(":")[2])

		if "S2" in line:
			s2.append(line.split(":")[2])

		if "S3" in line:
			s3.append(line.split(":")[2])

	avgS1 = 0.0
	avgS2 = 0.0
	avgS3 = 0.0

	for i in range(0, len(s1)):
		avgS1 += float(s1[i])
		avgS2 += float(s2[i])
		avgS3 += float(s3[i])


	avgS1 /= len(s1)
	avgS2 /= len(s2)
	avgS3 /= len(s3)

	#print>>fi, "S1 Load" + "\t" + "S1 AVG Load" + "\t" + "S2 Load" + "\t" + "S2 AVG Load" + "\t" + "S3 Load" + "\t" + "S3 AVG Load"

	print>>fi, "S1 Load" + "\t" + "S2 Load" + "\t" + "S3 Load"
	for i in range(0, len(s1)):
	#	if i == 0:
	#		print>>fi, s1[i] + "\t" + str(avgS1) + "\t" + s2[i] + "\t" + str(avgS2) + "\t" + s3[i] + "\t" + str(avgS3)
	#	else:
		print>>fi, s1[i] + "\t" + s2[i] + "\t" + s3[i]

