#%%
import numpy as np
import matplotlib
import matplotlib.pyplot as plt
from matplotlib.patches import Circle
#matplotlib.use('TkAgg')
import math

'''
fig_args = dict(figsize=(6, 6), dpi=75)  # make figures a bit larger
plt.figure(**fig_args)
plt.plot(x,y, '.')
plt.title('Lattice Structure')
plt.ylabel('X')
plt.xlabel('Y')
plt.show()
'''
#
def variance(a,b):
    mean = np.mean(a)
    mean = np.mean(b)
    total = 0
    for i,j in zip(a,b):
        one =(i-mean)**2
        two =(j-mean)**2
        adder = one+two
        total += adder
    variance = math.sqrt(total/2)
    return variance

def calculating(xpoints, ypoints):
    listing = []
    fig_args = dict(figsize=(10, 10), dpi=75)  # make figures a bit larger
    plt.figure(**fig_args)
    plt.plot(xpoints,ypoints, '.')
    plt.title('Lattice Structure')
    plt.ylabel('X')
    plt.xlabel('Y')
    #plt.show()
    for i in range(50):
        x=np.random.randint(10,40)
        y=np.random.randint(10,40)
        radius = np.random.randint(0,10)
        plt.gca().add_patch(Circle((x,y),radius= radius, color = 'black', fill = False))
        radius, area, perim, numberOfPoints, variance = pointsWithin(x,y,radius,xpoints, ypoints)
        listing.append((radius,area,perim,numberOfPoints, variance))
    plt.show()
    return listing
def pointsWithin(x,y,radius,xpoints, ypoints):
    counter=0
    a=[]
    b=[]
    for i,j in zip(xpoints, ypoints):
        tracker = math.sqrt(((i-x)**2 )+((j-y)**2))
        if(tracker < (radius*radius)):
            counter+=1
            a.append(i)
            b.append(j)
    if counter==0:
        variance_one = 0
    else:
        arr = np.array([a,b])  
        #variance= np.var(arr) #calculates the variance of the points within the circle
        variance_one = variance(a,b)
    perim = 2*math.pi*radius
    area = math.pi*radius*radius
    return radius, area, perim, counter,variance_one
####################################################################        
    
###############################################################################
def lattice(n,m):  #n = defualt img size
        x=[]
        y=[]
        for i in range(n):
            for j in range(m):
                x.append(i)
                y.append(j)
        return x,y
x,y = lattice(50,50)

################################################################################
lister=calculating(x,y)
LatticePerim=[]
LatticeArea=[]
for i in lister:
    LatticePerim.append((i[2],i[4]))
    LatticeArea.append((i[1],i[4]))
def x_and_y(lister):
    x=[]
    y=[]
    for i,j in lister:
        x.append(i)
        y.append(j)
    return x,y

def plot(this,title,color):
    x,y=x_and_y(this)
    plt.plot(x,y,'.',color=color)
    plt.title(title)
    plt.ylabel('Variance')
    plt.show()
    
    
    
        

plot(LatticePerim, "Lattice_Distribution_Based_On_Perimeter",'r')
plot(LatticeArea, "Lattice_Distribution_Based_On_Area",'b')
    

'''
def random(n,m):
    
    #x=[]
    #y=[]
    #for i in range(n):
    #    for j in range(m):
    #        x.append((np.random.random()))
    #        y.append((np.random.random()))
    #return x,y
    
    x = np.random.uniform(np.random.random(), np.random.random(), 1000) 
    y = np.random.uniform(np.random.random(), np.random.random(), 1000) 
    return x,y
x,y = random(20,20)
fig_args = dict(figsize=(6, 6), dpi=75)  # make figures a bit larger
plt.figure(**fig_args)
plt.plot(x,y,'.')
plt.title('Random Distribution')
plt.ylabel('X')
plt.xlabel('Y')
plt.show()



def hyperuniform(n,m):
    x = np.random.uniform(0.01, 0.99, 1000) 
    y = np.random.uniform(0.01, 0.99, 1000)
    return math.sqrt(x),math.sqrt(y)
x,y = random(20,20)
fig_args = dict(figsize=(6, 6), dpi=75)  # make figures a bit larger
plt.figure(**fig_args)
plt.plot(x,y,'.')
plt.title('HyperUniform Distribution')
plt.ylabel('X')
plt.xlabel('Y')
plt.show()


'''

    