using CircularArrays
using Plots
using Statistics

# 1d array example

faces=zeros(1,1,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];

grid=CircularArray(faces);
x=[-3:0.5:3;];
rho0=exp.(-(x).^2)
rho0=rho0/sum(rho0);
DT=0.1;
DX=1;
NT=100;
rho1=zeros(length(rho0));

crho0=CircularArray(rho0,grid);
crho1=CircularArray(rho0*0,grid);
for i=1:NT
    crho1=crho0+(shiftc(crho0,dims=1,shift=1) + shiftc(crho0,dims=1,shift=-1) - (2 * crho0))*DT/DX^2
    println(i," = ",(maximum(crho1)))
    global crho0=crho1;
    if rem(i,10)==0;#3600*6/dt
        plt=plot(x,crho1.data,ylims=(0,0.3))
        println(mean(crho1))
        display(plt)
        sleep(1)
    end
end
