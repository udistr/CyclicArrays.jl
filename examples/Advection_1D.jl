using CyclicArrays
using Plots
using Statistics
using LaTeXStrings

# 1d array example

faces=zeros(1,1,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];

grid=CyclicArray(faces);
x=[-1:0.01:1;];
u0=exp.(-(x*2).^2)
u0=u0/sum(u0)*100;
DT=0.1;
DX=1;
NT=2400;

rho0=ones(length(u0));

crho0=CyclicArray(rho0,grid);
crho1=CyclicArray(rho0*0,grid);
cu0=CyclicArray(u0,grid);
cu1=CyclicArray(u0*0,grid);
plot_array1 = Any[]
plot_array2 = Any[]
anim = @animate for i ∈ 1:NT
    println(i)
    crho1 = crho0 - crho0 * cu0 * DT/DX + shiftc(crho0 * cu0,dims=1,shift=-1) * DT/DX
    cu1 = (crho0 * cu0 - ( crho0 * cu0^2 -
                          shiftc(crho0 * cu0^2,dims=1,shift=-1) ) * DT / DX) / crho1
    global cu0=cu1;
    global crho0=crho1;
        plt1=plot(x,crho1.data,ylims=(0,20),
                            ylabel=L"\rho~~[kg~m^{-3}]",
                            xlabel="x [m]",
                            xlim=(-1,1))
        plt2=plot(x,cu1.data,ylims=(0,1.2),
                            ylabel=L"u~~[m/s]",
                            xlabel="x [m]",
                            xlim=(-1,1))
        plot(plt1,plt2,legend=false,title=string((i-1)/10," seconds"))
end every 10
gif(anim, "Advection1D.gif", fps = 30)
