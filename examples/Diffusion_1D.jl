using CyclicArrays
using Plots
using Statistics
using LaTeXStrings



# 1d array example

faces=zeros(1,1,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];

grid=CyclicArray(faces);
x=[-3:0.1:3;];
rho0=exp.(-(x).^2)
rho0=10*rho0/sum(rho0);
DT=0.5;
DX=1;
NT=400;
rho1=zeros(length(rho0));

crho0=CyclicArray(rho0,grid);
crho1=CyclicArray(rho0*0,grid);
plot_array = Any[]
anim = @animate for i ∈ 1:NT
    crho1=crho0+(shiftc(crho0,dims=1,shift=1) + shiftc(crho0,dims=1,shift=-1) - (2 * crho0))*DT/DX^2
    println(i," = ",(maximum(crho1)))
    global crho0=crho1;
    plt=plot(x,crho1.data,ylims=(0,0.6),
                          title=string(i/2," seconds"),
                          ylabel=L"\rho~~[kg~m^{-3}]",
                          xlabel="x [m]",
                          leg=false)
    push!(plot_array,plt)
    println(mean(crho1))
end
gif(anim, "Diffusion1D.gif", fps = 30)
