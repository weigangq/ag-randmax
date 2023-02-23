import matplotlib.pyplot as plt
import random
import argparse

# Parameters
parser = argparse.ArgumentParser(description='Pick the dimensions/distributions')
#parser.add_argument('-N', '--num_rings', type=int, help='Number of rings (Default 3)', default = 3)
#parser.add_argument('-R', '--rad_rings', type=int, help='Radius of rings (Default 10)', default = 10)
parser.add_argument('-W', '--width', type=int, help='Width of distribution (Default 60)', default = 60)
parser.add_argument('-H', '--height', type=int, help='Height of distribution (Default 80)', default = 80)
parser.add_argument('-D', '--dist', choices=['ordered','random','hyperuniform'], help='Type of distribution (Default hyperuniform)', default='hyperuniform')
args = parser.parse_args()

# Set-Up
fig = plt.figure(figsize=(7,7))
background = fig.add_subplot()
width = args.width
height = args.height

# Distributions
'''
Ordered Lattice:
- Variation occurs along ring's edge
- Variation is proportional to ring's perimeter
- Varies more for large rings than small rings
'''
def orderedlattice():
    for h in range(int(height/2)):
        for w in range(int(width/2)):
            if (w!=0 and h!=0):
                dot = plt.Circle((w*2,h*2), radius=0.1, color="black")
                background.add_patch(dot)
    rect = plt.Rectangle((0,0),width=width,height=height,color="black",fill=False)
    background.add_patch(rect)

'''
Random Distribution:
- Variation occurs throughout ring
- Variation is proportional to ring's area
- Varies more for large on a potentially extreme scale
'''
def randomdistribution():
    i = 0
    for h in range(int(height/2)):
        for w in range(int(width/2)):
            i+=1
    for num in range(i):
        x = random.randrange(0, width+1)
        y = random.randrange(0, height+1)
        dot = plt.Circle((x,y), radius=0.1, color="black")
        background.add_patch(dot)
    rect = plt.Rectangle((0,0),width=width,height=height,color="black",fill=False)
    background.add_patch(rect)

'''
Hyperuniform Distribution:
- Variation is similar to random distribution
- Variation is proportional to ring's perimeter
- Variation resembles lattice for large rings
'''
def hyperuniformdistribution():
    x_var = int(width/5)
    y_var = int(height/5)
    for a in range(y_var):
        for b in range(x_var):
            for i in range(20):
                x = random.randrange(5*b, 5*(b+1)+1)
                y = random.randrange(5*a, 5*(a+1)+1)
                dot = plt.Circle((x,y), radius=0.1, color="black")
                background.add_patch(dot)
    rect = plt.Rectangle((0,0),width=width,height=height,color="black",fill=False)
    background.add_patch(rect)

# Ring - this needs to be fixed
'''
circle1 = plt.Circle((10, 10), radius=args.rad_rings, color='blue', fill=False)
background.add_patch(circle1)
'''

# Main
if args.dist == 'ordered':
    orderedlattice()
if args.dist == 'random':
    randomdistribution()
if args.dist == 'hyperuniform':
    hyperuniformdistribution()

'''
To Do:
- Space for variance ???
- Standardize the number of points needed for each distribution
'''

background.axis('equal')
plt.show()

