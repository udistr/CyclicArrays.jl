using Test
using CircularArrays: CircularArray,stagger

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

grid=CircularArray(faces);

x0=reshape(collect(0:15).%4 .+1,(4,4))

x=reshape(x0,(1,4,4));
y=reshape(x0',(1,4,4));

x1=CircularArray(x,grid)
y1=CircularArray(y,grid)

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

grid=CircularArray(faces);

x=reshape(collect(0:15).%4 .+1,(4,4));
y=x'

x1=CircularArray(x,grid)
y1=CircularArray(y,grid)

i=5;j=1;
x1[i,j],y1[i,j]

x1[i,j]=2

@test x1[5,1]==2
@test [x1[2,2],y1[2,2]]==[2,2]
@test [x1[3,2],y1[3,2]]==[3,2]
@test [x1[5,2],y1[5,2]]==[1,2]
@test [x1[2,5],y1[2,5]]==[2,1]


# 1d array example

faces=zeros(1,1,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];

grid=CircularArray(faces);

#x02=ones(4,1).*[0:3;]
x=[0:3;]
x1=CircularArray(x,grid)

@test x1[5]==0
@test x1[0]==3
