import matplotlib.pyplot as plt
import numpy as np
import argparse
import random
from statistics import mean
import math
from scipy.special import gamma

# Get dimensions
parser = argparse.ArgumentParser(description='Pick the dimensions')
parser.add_argument('-S', '--size', type=int, help='Size of one side of the matrix (Default 50)', default = 50)
parser.add_argument('-M', '--matrices', type=int, help="Number of matrices (Default 1000)", default=1000)
args = parser.parse_args()

N = args.size
reps = args.matrices
'''
Changes;
- Not sure why but you have to create multiple matrices instead of relying one one 
 (which is what we've been doing)
- You have to add each matrix to some function of itself (not sure what A.T is) and
  then calculate the eigenvalue for that
- Then calculate the difference between the eigenvalue and eigenvector and that becomes
  the P(s) value
Resources:
https://byjus.com/maths/eigen-values/#:~:text=Eigenvalues%20are%20the%20special%20set,the%20application%20of%20linear%20transformations.
- Found non-binary matrices: I think we can use this on the ospC data but I'm not sure 
  how we'd create the matrices since we've only been creating one
https://www.johndcook.com/blog/2018/07/30/goe-eigenvalues/
- Code for eigenvalues: goe
'''

# Original code from: https://www.johndcook.com/blog/2018/07/30/goe-eigenvalues/
diffs = np.zeros(reps)
for r in range(reps): 
    A = np.random.randint(2, size = N*N).reshape(N,N)
    M = 0.5*(A + A.T)
    w = np.linalg.eigvalsh(M)
    diffs[r] = abs(w[1] - w[0])

plt.hist(diffs, bins=int(reps**0.5))
plt.show()

'''
# Construction of random binary adjacency matrix
N = args.size
arr = np.random.randint(2, size = N*N).reshape(N,N)
#print(arr)

# Construction of eigenvalues
eigenvalues, eigenvectors = np.linalg.eig(arr) # From matt
sorted_eigenvalues = sorted(eigenvalues)
eigenvalues_spacing = []
for i in range(len(eigenvalues)-1):
    eigenvalues_spacing.append(abs(sorted_eigenvalues[i]-sorted_eigenvalues[i+1]))

# Calculation of spacings
eigenvalues_index = []
for ind,val in enumerate(eigenvalues):
    eigenvalues_index.append((ind,float(val)))

spacings_index = []
for i in eigenvalues_index:
    for j in eigenvalues_index:
        if j[0] > i[0]:
            spacings_index.append((j[0]-i[0],j[1]-i[1]))

spacings = []
for num in range(1,len(eigenvalues)):
    temp = []
    for item in spacings_index:
        if item[0] == num:
            temp.append(item[1])
    spacings.append(mean(temp))
#print(spacings)

# P(s) calculation - GOE
beta = 1
a = 2 * pow(gamma((2+beta)/2),beta+1) / pow(gamma((1+beta)/2),beta+2)
b = pow((gamma((2+beta)/2) / gamma((1+beta)/2)),2)

def P(s):
    return a*pow(s,beta)*math.exp(-b*pow(s,2))

power_set = []
for item in spacings:
    power_set.append(P(item))
#print(power_set)

x_coord = []
for item in range(len(eigenvalues)):
    if item != 0:
        x_coord.append(item)

# Plot
plt.hist(power_set, bins=int(100**0.5), color="maroon", width=0.5)
plt.ylabel("Spacings")
plt.xlabel("P(S)")
plt.show()
'''