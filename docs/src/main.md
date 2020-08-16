# CyclicArrays

CyclicArrays allow for the intuitive definition of circular domain composed of one or more faces, and each face has two directions for each dimension. After the definition of the connection between different faces, out-of-boundary indexes will be permitted. The CyclicArray structure includes two fields - data array and connection array. The data array containing the data values and the connection array containing the information on the connections between faces and their sides.

## The connection array

The connection array is a four-dimensional array defining the connections between faces:
1. Face dimension - 1:(number of faces)
2. Spatial dimensions, size up to three - x=1, y=2, z=3
3. Direction, size 2 (negative direction = 1, positive direction = 2)
4. Destiny - four values pointing each (1) face, (2) dimension, and (3) direction to its neighbor. The fourth value (4) indicates whether there is a need to flip the face upside-down (0 - no-flip, 1 - flip).

### 1D, 1 face example
![CyclicArrayExample1D](https://raw.githubusercontent.com/udistr/CyclicArrays.jl/master/docs/images/CyclicArrayExample1D.png)


One face (size N) with one circular x dimention will have a 1x1x2x4 connection array where:  
connections[1,1,:,:]=  
 1  1  2  0  
 1  1  1  0  

 The first row (array indexes [1,1,1,:]) indicates that face one, x dimension, negative direction is pointing to face one, x-direction, positive direction. The second row (array indexes [1,1,2,:]) indicates that face one, x dimension, positive direction is pointing to face one, x-direction, negative direction. Array fliping is not relevant in 1D array and should be set to zero (connection[:,:,:,4]=0).


### 2D, 1 face example

![CyclicArrayExample2D](https://raw.githubusercontent.com/udistr/CyclicArrays.jl//master/docs/images/CyclicArrayExample2D.png)



One face (size NxN) with circular x and y dimentions will have a 1x2x2x4 connection array where:  
connections[1,1,:,:]=  
 1  1  2  0  
 1  1  1  0  
connections[1,2,:,:]=  
 1  2  2  0  
 1  2  1  0  

 connections[1,1,:,:] - The first row (array indexes [1,1,1,:]) indicates that face one, x dimension, negative direction is pointing to face one, x-direction, positive direction. The second row (array indexes [1,1,2,:]) indicates that face one, x dimension, positive direction is pointing to face one, x-direction, negative direction.  
 connections[1,2,:,:] -  The first row (array indexes [1,2,1,:]) indicates that face one, y dimension, negative direction is pointing to face one, y-direction, positive direction. The second row (array indexes [1,2,2,:]) indicates that face one, y dimension, positive direction is pointing to face one, x dimension, negative direction. No array fliping here.




## Use examples

### Diffusion 1D
Example examples/Diffusion_1D.jl will run a simple 1D diffustion equations:

![\frac{\partial \rho}{\partial t} = \frac{\partial^2 \rho}{\partial x^2}](https://render.githubusercontent.com/render/math?math=%5Cfrac%7B%5Cpartial%20%5Crho%7D%7B%5Cpartial%20t%7D%20%3D%20%5Cfrac%7B%5Cpartial%5E2%20%5Crho%7D%7B%5Cpartial%20x%5E2%7D),  
where, ![\rho (x,t)](https://render.githubusercontent.com/render/math?math=%5Crho%20(x%2Ct)) is the density.

Using the embedded function shiftc which which returns a shifted value of the array, this example integrated for 12 seconds results:

![Diffusion1D](https://raw.githubusercontent.com/udistr/CyclicArrays.jl/master/docs/images/Diffusion1D.gif)




### Advection 1D

Example examples/Advection_1D.jl will run a simple 1D Advection equations:

![\frac{\partial ( \rho \cdot \u)}{\partial t} = -u \cdot \frac{\partial ( \rho \cdot \u)}{\partial x}](https://render.githubusercontent.com/render/math?math=%5Cfrac%7B%5Cpartial%20(%20%5Crho%20%5Ccdot%20%5Cu)%7D%7B%5Cpartial%20t%7D%20%3D%20-u%20%5Ccdot%20%5Cfrac%7B%5Cpartial%20(%20%5Crho%20%5Ccdot%20%5Cu)%7D%7B%5Cpartial%20x%7D)  

![\frac{\partial \rho}{\partial t} = -\frac{\partial ( \rho \cdot u)}{\partial x}](https://render.githubusercontent.com/render/math?math=%5Cfrac%7B%5Cpartial%20%5Crho%7D%7B%5Cpartial%20t%7D%20%3D%20-%5Cfrac%7B%5Cpartial%20(%20%5Crho%20%5Ccdot%20u)%7D%7B%5Cpartial%20x%7D)

where, ![\rho (x,t)](https://render.githubusercontent.com/render/math?math=%5Crho%20(x%2Ct)) and ![u (x,t)](https://render.githubusercontent.com/render/math?math=u%20(x%2Ct)) are the density and x-dimension velocity fields.

![Advection1D](https://raw.githubusercontent.com/udistr/CyclicArrays.jl/master/docs/images/Advection1D.gif)



### Random Flow

Example examples/RandomFlow_2D.jl simulates the trajectories of a particle cloud in a randomly generated flow field, given the stream function:

f(y,x) = sin(x) + sin(y)

![Advection1D](https://raw.githubusercontent.com/udistr/CyclicArrays.jl/master/docs/images/RandomFlow_2D.gif)
