from math import factorial as fact

# 8 16 32 64
m = 64
# 0.896	0.823 0.751 0.663
rho = 0.663


first = 1
sec = pow(m*rho, m)/(fact(m)*(1-rho))

summ = 0
for n in range(1, m):
	summ += pow((m*rho), n)/fact(n)

tempp0 = first + sec + summ
p0 = 1 / tempp0
print p0

e = p0 * pow(m*rho, m)/(fact(m)*(1-rho))
print e

# n < m
pn = 0

for n in range(1, m):
	pn += p0*pow(m*rho, n)/fact(n)

print "pn n < m " + str(pn)
print "pn n >= m " + str(1 - pn)
