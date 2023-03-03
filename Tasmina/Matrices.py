import matplotlib.pyplot as plt
import numpy as np
import random
import argparse

# Parameters
parser = argparse.ArgumentParser(description='Pick the dimensions/distributions')
#parser.add_argument('-N', '--num_rings', type=int, help='Number of rings (Default 3)', default = 3)
#parser.add_argument('-R', '--rad_rings', type=int, help='Radius of rings (Default 10)', default = 10)
parser.add_argument('-W', '--width', type=int, help='Width of distribution of points(from the center of leftmost point to center of rightmost point) (Default 60)', default = 60)
parser.add_argument('-H', '--height', type=int, help='Height of distribution (from center of top point to center of bottom point) (Default 80)', default = 80)
parser.add_argument('-D', '--dist', choices=['ordered','random','hyperuniform'], help='Type of distribution (Default hyperuniform)', default='hyperuniform')
parser.add_argument('-C', '--circles', type=int, help='Number of dots placed on grid (Default 1200)', default=1200)
args = parser.parse_args()

# Set-Up
fig = plt.figure(figsize=(7,7))
background = fig.add_subplot()
width = args.width
height = args.height
dots = args.circles

# Distributions
'''
Ordered Lattice:
- Variation occurs along ring's edge
- Variation is proportional to ring's perimeter
- Varies more for large rings than small rings
'''
def orderedlattice():
    spacing = width*height/dots
    for h in np.arange(spacing,height+spacing,spacing):
        for w in np.arange(spacing,width+spacing,spacing):
            dot = plt.Circle((w,h), radius=0.1, color="black")
            background.add_patch(dot)
    rect = plt.Rectangle((0,0),width=width+spacing,height=height+spacing,color="black",fill=False)
    background.add_patch(rect)

'''
Random Distribution:
- Variation occurs throughout ring
- Variation is proportional to ring's area
- Varies more for large on a potentially extreme scale
'''
def randomdistribution():
    i = 0
    for num in range(dots):
        x = random.uniform(0.5, width-0.5)      # This ensures that all dots are placed within 0.5
        y = random.uniform(0.5, height-0.5)     # units away from the perimeter
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
    counter = 0
    last = False
    spacing = ((width*height)/dots) * 5
    begin = (width*height)/dots
    for h in np.arange(0,height,spacing):
        for w in np.arange(0,width,spacing):
            counter += 1
    for h in np.arange(0,height,spacing):
        for w in np.arange(0,width,spacing):
            for i in range(int(dots/counter)):
                if (i == int(dots/counter)-1):
                    last == True
                elif (last == False):
                    x = random.uniform(w, w+spacing)
                    y = random.uniform(h, h+spacing)
                else:
                    x = random.uniform(w, w+spacing-begin)
                    y = random.uniform(h, h+spacing-begin)
                dot = plt.Circle((x,y), radius=0.1, color="black")
                background.add_patch(dot)
    rect = plt.Rectangle((0,0),width=width+begin,height=height+begin,color="black",fill=False)
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

