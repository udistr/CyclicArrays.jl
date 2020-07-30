using CyclicArrays
using Plots

nx=ny=100
nfaces=1;

faces=zeros(nfaces,2,2,4);
faces[1,1,1,:]=[1,1,2,0];
faces[1,1,2,:]=[1,1,1,0];
faces[1,2,1,:]=[1,2,2,0];
faces[1,2,2,:]=[1,2,1,0];

g=CyclicArray(faces);

ind=range(1, 360, length = 360)
x = y = ind/180*pi
f(y,x) = sin(x) + sin(y)

X = repeat(reshape(x, 1, :), length(y), 1)
Y = repeat(y, 1, length(x))

F=f.(Y,X)

#f = sin.(2*x .+ 10 .* sin.(x)) .+ sin.(3*y)

phi=CyclicArray(F,g)
contourf(phi.data, aspect_ratio=1,xlim=(0,360),ylim=(0,360))
xg=CyclicArray(repeat(ind, 1, length(x))',g)
yg=CyclicArray(repeat(ind, 1, length(x)),g)
u=diff(phi,dims=2)
v=-diff(phi,dims=1)

N=1500
np=25
xi=zeros(N+1,np)
yi=zeros(N+1,np)


x0=collect(0:20:490).%100 .+ 170
y0=reshape(repeat(collect(0:20:80),1,5)',25) .+ 160
xi[1,:]=x0;
yi[1,:]=y0;

dt=100
#for t in 1:N
plt=contourf(yg.data[:,1],xg.data[1,:],phi.data, aspect_ratio=1,xlim=(0,360),ylim=(0,360))
scatter!(xi[1,:],yi[1,:],leg=false)
anim = @animate for t ∈ 1:N
  println(t)
  i=Int.(floor.(xg[1,Int.(floor.(xi[t,:]))]))
  j=Int.(floor.(yg[Int.(floor.(yi[t,:])),1]))
  U=[u[i[ii],j[ii]] for ii in 1:np]
  V=[v[i[ii],j[ii]] for ii in 1:np]
  #println(t,' ',U,' ',V)
  xi[t+1,:]=xi[t,:]+U*dt
  yi[t+1,:]=yi[t,:]+V*dt
  xi[t+1,:]=floor.(xg[1,Int.(sign.(xi[t+1,:]).*floor.(abs.(xi[t+1,:])))])+rem.(xi[t+1,:],1)
  yi[t+1,:]=floor.(yg[Int.(sign.(yi[t+1,:]).*floor.(abs.(yi[t+1,:]))),1])+rem.(yi[t+1,:],1)
  plt=contourf(yg.data[:,1],xg.data[1,:],phi.data, aspect_ratio=1,xlim=(0,360),ylim=(0,360))
  scatter!([-1,xi[t+1,:]],[-1,yi[t+1,:]],leg=false, c=:green)
  #display(plt)
end
gif(anim, "RandomFlow_2D.gif", fps = 30)
