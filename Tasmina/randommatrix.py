import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
import argparse
import random
from statistics import mean
import math
from scipy.special import gamma

# Get dimensions
parser = argparse.ArgumentParser(description='Pick the dimensions')
parser.add_argument('-S', '--size', type=int, help='Size of one side of the matrix (Default 50)', default = 50)
args = parser.parse_args()

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
#print("The eigenvalues are : \n", eigenvalues)
#print("The spacings between each eigenvalue are: \n", eigenvalues_spacing)

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
plt.bar(x_coord, power_set, color="maroon", width=0.5)
plt.xlabel("Spacings")
plt.ylabel("P(S)")
plt.show()