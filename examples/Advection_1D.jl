using CyclicArrays
using Plots
using Statistics

# 1d array example

faces=zeros(1,1,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];

grid=CircularArray(faces);
x=[-1:0.01:1;];
u0=exp.(-(x*2).^2)
u0=u0/sum(u0)*100;
DT=0.1;
DX=1;
NT=2400;

rho0=ones(length(u0));

crho0=CircularArray(rho0,grid);
crho1=CircularArray(rho0*0,grid);
cu0=CircularArray(u0,grid);
cu1=CircularArray(u0*0,grid);
plot_array1 = Any[]
plot_array2 = Any[]
for i=1:NT
    crho1 = crho0 - crho0 * cu0 * DT/DX + shiftc(crho0 * cu0,dims=1,shift=-1) * DT/DX
    cu1 = (crho0 * cu0 - ( crho0 * cu0^2 -
                          shiftc(crho0 * cu0^2,dims=1,shift=-1) ) * DT / DX) / crho1
    #println(i," = ",(maximum(cu1)))
    global cu0=cu1;
    global crho0=crho1;
    if rem(i,200)==0;
        plt1=plot(x,crho1.data,ylims=(0,20),
                              title=string(i/10," seconds"))
        plt2=plot(x,cu1.data,ylims=(0,1.2),
                              title=string(i/10," seconds"))
        push!(plot_array1,plt1)
        push!(plot_array2,plt2)
        #println(mean(crho1 * cu1)) - conservation of momentum
        #println(mean(cu1))
    end
end
plt=plot(plot_array1...,legend=false,
                   titlefontsize=6,
                   ylabel=L"\rho~~[kg~m^{-3}]",
                   xlabel="x [m]",
                   xtickfontsize=6,
                   xguidefontsize=6,
                   ytickfontsize=6,
                   yguidefontsize=6, dpi=200)
png(plt,"Advection_1D_rho.png")
plt=plot(plot_array2...,legend=false,
                   titlefontsize=6,
                   ylabel=L"u~~[m/s]",
                   xlabel="x [m]",
                   xtickfontsize=6,
                   xguidefontsize=6,
                   ytickfontsize=6,
                   yguidefontsize=6, dpi=200)
png(plt,"Advection_1D_u.png")
