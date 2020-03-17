include("cgrid.jl")
using .cgrid: CircularArray,stagger

nx=5
ny=5
nz=1
nfaces=1;

faces=zeros(nfaces,3,2,4);

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

faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];
faces[1,2,1,:]=[1,2,2,0];
faces[1,2,2,:]=[1,2,1,0];
faces[1,3,1,:].=-1;
faces[1,3,2,:].=-1;

grid=CircularArray(faces);

x=repeat(reshape(collect(0.:1.:nx-1.),(1,1,1,nx)),outer=[nfaces,nz,ny,1])*1000;
y=repeat(reshape(collect(0.:1.:ny-1.),(nfaces,1,ny,1)),outer=[nfaces,nz,1,nx]);
z=repeat(reshape(collect(0.:1.:nz),(nfaces,nz+1,1,1)),outer=[nfaces,1,ny,nx]);

xf=CircularArray(ones((nfaces,nz,ny,nx)),grid);
yf=CircularArray(ones((nfaces,nz,ny,nx)),grid);
zf=CircularArray(ones((nfaces,nz+1,ny,nx)),grid);

#dx=diff(xf,dims=4)
#dy=ones((nfaces,nz,ny,nx))
#dz=ones((nfaces,nz,ny,nx))


#=
#rho_init=CircularArray(ones((nfaces,nz,ny,nx))*1000,grid);

#rho_init*rho_init;
#rho_init[1,1,1,1]=1

x=CircularArray(ones((1,1,4,4))*1000,grid);
x[1,1,2,1]=3
x[1,1,1,2]=2
x[1,1,1,1]=1

x[1,1,5:6,1].=2

x[1,1,:,:]
=#
