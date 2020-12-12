using Test
using CyclicArrays

#=
face: 1:nfaces
direction:X=1 / Y=2 / Z=3,
side: - = 1 / + = 2
destiny:
1  face: 1:nfaces
2  direction:X=1 / Y=2 / Z=3,
3  side: - = 1 / + = 2
4  flip 1 / no flip 0
=#

# 3d array example

nx=4
ny=4
nz=1
nfaces=1;

faces=zeros(nfaces,3,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];
faces[1,2,1,:]=[1,2,2,0];
faces[1,2,2,:]=[1,2,1,0];
faces[1,3,1,:].=-1;
faces[1,3,2,:].=-1;

grid=CyclicArray(faces);

x0=reshape(collect(0:15).%4 .+1,(4,4))

x=reshape(x0,(1,4,4));
y=reshape(x0',(1,4,4));

x1=CyclicArray(x,grid)
y1=CyclicArray(y,grid)

i=5;j=1;k=1;
x1[k,j,i],y1[k,j,i]

x1[k,j,i]=2

@test x1[1,5,1]==2
@test [x1[1,2,2],y1[1,2,2]]==[2,2]
@test [x1[1,3,2],y1[1,3,2]]==[3,2]
@test [x1[1,5,2],y1[1,5,2]]==[1,2]
@test [x1[1,2,5],y1[1,2,5]]==[2,1]


# 2d array example

nx=5
ny=5
nfaces=1;

faces=zeros(nfaces,2,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];
faces[1,2,1,:]=[1,2,2,0];
faces[1,2,2,:]=[1,2,1,0];

grid=CyclicArray(faces);

x=reshape(collect(0:15).%4 .+1,(4,4));
y=x'

x1=CyclicArray(x,grid)
y1=CyclicArray(y,grid)

i=5;j=1;
x1[i,j],y1[i,j]

x1[i,j]=2

@test x1[5,1]==2
@test [x1[2,2],y1[2,2]]==[2,2]
@test [x1[3,2],y1[3,2]]==[3,2]
@test [x1[5,2],y1[5,2]]==[1,2]
@test [x1[2,5],y1[2,5]]==[2,1]

z1=CyclicArray(ones(1,4,4),grid)

@test z1.data==(z1*z1.data).data
@test z1.data==(z1+z1.data).data/2
@test z1.data==(z1-z1.data).data.+1
@test z1.data==(z1^z1.data).data
@test z1.data==(z1/z1.data).data
@test z1.data==(z1\z1.data).data


# 1d array example

faces=zeros(1,1,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];

grid=CyclicArray(faces);
x=[0:3;]
x1=CyclicArray(x,grid)

@test x1[5]==0
@test x1[0]==3


# cubed sphere example

nfaces=6
faces=zeros(Int64,nfaces,3,2,4);

faces[1,1,1,:]=[4,1,2,0]
faces[1,1,2,:]=[2,1,1,0]
faces[1,2,1,:]=[6,2,2,0]
faces[1,2,2,:]=[5,2,1,0]
faces[1,3,1,:].=-1
faces[1,3,2,:].=-1

faces[2,1,1,:]=[1,1,2,0]
faces[2,1,2,:]=[3,1,1,0]
faces[2,2,1,:]=[6,1,2,1]
faces[2,2,2,:]=[5,1,2,0]
faces[2,3,1,:].=-1
faces[2,3,2,:].=-1

faces[3,1,1,:]=[2,1,2,0]
faces[3,1,2,:]=[4,1,1,0]
faces[3,2,1,:]=[6,2,1,1]
faces[3,2,2,:]=[5,2,2,1]
faces[3,3,1,:].=-1
faces[3,3,2,:].=-1

faces[4,1,1,:]=[3,1,2,0]
faces[4,1,2,:]=[1,1,1,0]
faces[4,2,1,:]=[6,1,1,0]
faces[4,2,2,:]=[5,1,1,1]
faces[4,3,1,:].=-1
faces[4,3,2,:].=-1

faces[5,1,1,:]=[4,2,2,1]
faces[5,1,2,:]=[2,2,2,0]
faces[5,2,1,:]=[1,2,2,0]
faces[5,2,2,:]=[3,2,2,0]
faces[5,3,1,:].=-1
faces[5,3,2,:].=-1

faces[6,1,1,:]=[4,2,1,0]
faces[6,1,2,:]=[2,2,1,1]
faces[6,2,1,:]=[3,2,1,1]
faces[6,2,2,:]=[1,2,1,0]
faces[6,3,1,:].=-1
faces[6,3,2,:].=-1

grid=CyclicArray(faces);

x0=repeat(reshape(collect(0:15).%4 .+1,(1,1,4,4)),6,1,1,1)
y0=repeat(permutedims(reshape(collect(0:15).%4 .+1,(1,1,4,4)),(1,2,4,3)),6,1,1,1)
a0=repeat(collect(1:6),1,1,4,4)

x1=CyclicArray(x0,grid)
y1=CyclicArray(y0,grid)
a1=CyclicArray(a0,grid)

f=1;i=5;j=1;k=1;
a1[f,k,j,i],x1[f,k,j,i],y1[f,k,j,i]
@test [a1[f,k,j,i],x1[f,k,j,i],y1[f,k,j,i]]==[2,1,1]
f=1;i=1;j=5;k=1;
@test [a1[f,k,j,i],x1[f,k,j,i],y1[f,k,j,i]]==[5,1,1]
f=1;i=0;j=1;k=1;
@test [a1[f,k,j,i],x1[f,k,j,i],y1[f,k,j,i]]==[4,1,4]
f=1;i=1;j=0;k=1;
@test [a1[f,k,j,i],x1[f,k,j,i],y1[f,k,j,i]]==[6,4,1]

