using CyclicArrays
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
NT=120;
rho1=zeros(length(rho0));

crho0=CircularArray(rho0,grid);
crho1=CircularArray(rho0*0,grid);
plot_array = Any[]
for i=1:NT
    crho1=crho0+(shiftc(crho0,dims=1,shift=1) + shiftc(crho0,dims=1,shift=-1) - (2 * crho0))*DT/DX^2
    println(i," = ",(maximum(crho1)))
    global crho0=crho1;
    if rem(i,10)==0;
        plt=plot(x,crho1.data,ylims=(0,0.3),
                              title=string(i/10," seconds"))
        push!(plot_array,plt)
        println(mean(crho1))
    end
end
plt=plot(plot_array...,legend=false,
                   titlefontsize=6,
                   ylabel=L"\rho~~[kg~m^{-3}]",
                   xlabel="x [m]",
                   xtickfontsize=6,
                   xguidefontsize=6,
                   ytickfontsize=6,
                   yguidefontsize=6, dpi=200)
png(plt,"Diffusion_1D.png")
