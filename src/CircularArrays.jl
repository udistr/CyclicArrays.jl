module CircularArrays

 include("utils.jl")

 """
     CircularArray
 CircularArray data structure. Available constructors:
 ```
 CircularArray(data::AbstractArray{T,N}, connections::AbstractArray)
 ```
 """
 struct CircularArray{T,N} <: AbstractArray{T,N} #inherits from AbstractArray
     data::AbstractArray{T,N}
     connections::Array{Int,4}
 end

 CircularArray(x::CircularArray)=CircularArray([],x.connections)
 CircularArray(x::AbstractArray,y::CircularArray)=CircularArray(x,y.connections)
 CircularArray(faces::AbstractArray)=CircularArray([],faces)

 Base.ndims(A::CircularArray) = ndims(A.data)
 Base.Dims(A::CircularArray) = Dims(A.data)
 Base.size(A::CircularArray) = size(A.data)
 Base.length(A::CircularArray)=length(A.data)
 Base.axes(A::CircularArray) = axes(A.data)
 Base.findall(A::CircularArray) = findall(A.data)
 Base.findfirst(A::CircularArray) = findfirst(A.data)
 Base.findlast(A::CircularArray) = findlast(A.data)
 Base.findprev(A::CircularArray, I...) = findprev(A.data, I...)
 Base.findnext(A::CircularArray, I...) = findnext(A.data, I...)
 Base.checkbounds(A::CircularArray, I...) = nothing
 Base.CartesianIndices(A::CircularArray) = CartesianIndices(A.data)


 function Base.diff(A::CircularArray, dims=dims::Integer)
  I=size(A.data)
  I1=[UnitRange(1:I[i]) for i in 1:length(I)]
  I2=copy(I1)
  I2[dims]=I1[dims].+1
  B=CircularArray(zeros(size(A.data)),A.connections)
  CI1=CartesianIndices(Tuple(I1))
  CI2=CartesianIndices(Tuple(I2))
  N=length(CI1[1])
  for n in 1:length(CI1)
    I1b=[CI1[n][i]  for i in 1:N]
    I2b=[CI2[n][i]  for i in 1:N]
    B[I1b...]=A[I2b...]-A[I1b...]
  end
  return B
 end

 function stagger(A::CircularArray; dims=1::Integer, frac=0.5::Real)
  I=size(A.data)
  I1=[UnitRange(1:I[i]) for i in 1:length(I)]
  I2=copy(I1)
  I2[dims]=I1[dims].+Int(sign(frac))
  B=CircularArray(zeros(size(A.data)),A.connections)
  CI1=CartesianIndices(Tuple(I1))
  CI2=CartesianIndices(Tuple(I2))
  N=length(CI1[1])
  for n in 1:length(CI1)
    I1b=[CI1[n][i]  for i in 1:N]
    I2b=[CI2[n][i]  for i in 1:N]
    B[I1b...]=(1-frac)*A[I1b...]+frac*A[I2b...]
  end
  return B
 end

 Base.:-(A::CircularArray)=.-(A.data)
 Base.:*(A::CircularArray, B::CircularArray)=CircularArray(.*(A.data,B.data),A.connections)
 Base.:-(A::CircularArray, B::CircularArray)=CircularArray(.-(A.data,B.data),A.connections)
 Base.:+(A::CircularArray, B::CircularArray)=CircularArray(.+(A.data,B.data),A.connections)
 Base.:^(A::CircularArray, B::CircularArray)=CircularArray(.^(A.data,B.data),A.connections)
 Base.:/(A::CircularArray, B::CircularArray)=CircularArray(./(A.data,B.data),A.connections)
 Base.:\(A::CircularArray, B::CircularArray)=CircularArray(.\(A.data,B.data),A.connections)

 function Base.getindex(A::CircularArray, I::Vararg{Int, N}) where N # implements A[I]
   S = size(A)
   faces=A.connections
   if length(S)==1
     nz=1; ny=1; nx=S[N]; N0=4
     I=tuple(tuple(1,1,1)...,I...)
   elseif length(S)==2
     nz=1; ny=S[N-1]; nx=S[N]; N0=4
     I=tuple(tuple(1,1)...,I...)
   elseif length(S)==3
     if (size(nfaces)[1])==1
       nz=S[N-2]; ny=S[N-1]; nx=S[N]; N0=4
       I=tuple(tuple(1)...,I...)
     else
       nz=1; ny=S[N-1]; nx=S[N]; N0=4
       I=tuple(I[1]...,tuple(1)...,I[2:end]...)
     end
   else
     nz=S[N-2]; ny=S[N-1]; nx=S[N]; N0=4
   end
   I1=[i for i in I]

   while (I1[N0]<1 || I1[N0]>nx) || (I1[N0-1]<1 || I1[N0-1]>ny) || (I1[N0-2]<1 || I1[N0-2]>nz)
     I2=I1
     i=I1[N0]
     j=I1[N0-1]
     k=I1[N0-2]
     f=I1[N0-3]

     if I1[N0]<1
       if faces[f,1,1,1]==-1
         return NaN
       else
         f1=faces[f,1,1,1]
         axis=faces[f,1,1,2];
         side=faces[f,1,1,3];
         flip=faces[f,1,1,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                 kd(axis,1) * kd(side,2) * (nx+i) +
                 kd(axis,2) * kd(flip,0) *  j     +
                 kd(axis,2) * kd(flip,1) * (nx+1-j)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                   kd(axis,1) * kd(flip,1) * (ny+1+j) +
                   kd(axis,2) * kd(side,1) * (1-i) +
                   kd(axis,2) * kd(side,2) * (ny+i)
         I2[N0-2] = k
         I1=I2
       end
     end
     if I1[N0]>nx
       if faces[f,1,2,1]==-1
         return NaN
       else
         f1=faces[f,1,2,1];
         axis=faces[f,1,2,2];
         side=faces[f,1,2,3];
         flip=faces[f,1,2,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (i-nx)   +
                 kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx)) +
                 kd(axis,2) * kd(flip,0) *  j     +
                 kd(axis,2) * kd(flip,1) * (nx+1-j)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                   kd(axis,1) * kd(flip,1) * (ny+1+j) +
                   kd(axis,2) * kd(side,1) * (1-ny) +
                   kd(axis,2) * kd(side,2) * ((ny+1)-(i-ny))
         I2[N0-2] = k
         I1=I2
       end
     end

     if I1[N0-1]<1
       if faces[f,2,1,1]==-1
         return NaN
       else
         f1=faces[f,2,1,1]
         axis=faces[f,2,1,2];
         side=faces[f,2,1,3];
         flip=faces[f,2,1,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                 kd(axis,1) * kd(side,2) * (nx-j) +
                 kd(axis,2) * kd(flip,0) *  i     +
                 kd(axis,2) * kd(flip,1) * (nx+1-i)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                   kd(axis,1) * kd(flip,1) * (ny+1-i) +
                   kd(axis,2) * kd(side,1) * (1-j) +
                   kd(axis,2) * kd(side,2) * (ny+j)
         I2[N0-2] = k
         I1=I2
       end
     end
     if I1[N0-1]>ny
       if faces[f,2,2,1]==-1
         return NaN
       else
         f1=faces[f,2,2,1]
         axis=faces[f,2,2,2];
         side=faces[f,2,2,3];
         flip=faces[f,2,2,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (j-ny)   +
                 kd(axis,1) * kd(side,2) * (ny+1-(j-ny)) +
                 kd(axis,2) * kd(flip,0) *  i     +
                 kd(axis,2) * kd(flip,1) * (nx+1-i)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                   kd(axis,1) * kd(flip,1) * (ny+1-i) +
                   kd(axis,2) * kd(side,1) * (j-ny) +
                   kd(axis,2) * kd(side,2) * (ny+1-(ny-j))
         I2[N0-2] = k
         I1=I2
       end
     end

     if I1[N0-2]<1
       if faces[f,3,1,1]==-1
         return NaN
       else
         f1=faces[f,3,1,1]
         axis=faces[f,3,1,2];
         side=faces[f,3,1,3];
         flip=faces[f,3,1,4];
         I2[N0] = i
         I2[N0-1] = k
         I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                   kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
         I1=I2
       end
     end
     if I1[N0-2]>nz
       if faces[f,3,2,1]==-1
         return NaN
       else
         f1=faces[f,3,2,1]
         axis=faces[f,3,2,2];
         side=faces[f,3,2,3];
         flip=faces[f,3,2,4];
         I2[N0] = i
         I2[N0-1] = j
         I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                   kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
         I1=I2
       end
     end
   end
   return Base.getindex(A.data,I1[N0-length(S)+1:N0]...)
 end

 Base.getindex(A::CircularArray, I) = (A[i] for i in I)

 function Base.setindex!(A::CircularArray,value,I::Vararg{Int, N}) where N # A[I] = value
   S = size(A)
   if length(S)==1
     nz=1; ny=1; nx=S[N]; N0=4
     I=tuple(tuple(1,1,1)...,I...)
   elseif length(S)==2
     nz=1; ny=S[N-1]; nx=S[N]; N0=4
     I=tuple(tuple(1,1)...,I...)
   elseif length(S)==3
     if (size(nfaces)[1])==1
       nz=S[N-2]; ny=S[N-1]; nx=S[N]; N0=4
       I=tuple(tuple(1)...,I...)
     else
       nz=1; ny=S[N-1]; nx=S[N]; N0=4
       I=tuple(I[1]...,tuple(1)...,I[2:end]...)
     end
   else
     nz=S[N-2]; ny=S[N-1]; nx=S[N]; N0=4
   end

   faces=A.connections
   I1=[i for i in I]

   while (I1[N0]<1 || I1[N0]>nx) || (I1[N0-1]<1 || I1[N0-1]>ny) || (I1[N0-2]<1 || I1[N0-2]>nz)
     I2=I1
     i=I1[N0]
     j=I1[N0-1]
     k=I1[N0-2]
     f=I1[N0-3]

     if I1[N0]<1
       if faces[f,1,1,1]==-1
         return NaN
       else
         f1=faces[f,1,1,1]
         axis=faces[f,1,1,2];
         side=faces[f,1,1,3];
         flip=faces[f,1,1,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                 kd(axis,1) * kd(side,2) * (nx+i) +
                 kd(axis,2) * kd(flip,0) *  j     +
                 kd(axis,2) * kd(flip,1) * (nx+1-j)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                   kd(axis,1) * kd(flip,1) * (ny+1+j) +
                   kd(axis,2) * kd(side,1) * (1-i) +
                   kd(axis,2) * kd(side,2) * (ny+i)
         I2[N0-2] = k
         I1=I2
       end
     end
     if I1[N0]>nx
       if faces[f,1,2,1]==-1
         return NaN
       else
         f1=faces[f,1,2,1]
         axis=faces[f,1,2,2];
         side=faces[f,1,2,3];
         flip=faces[f,1,2,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (1-nx)   +
                 kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx)) +
                 kd(axis,2) * kd(flip,0) *  j     +
                 kd(axis,2) * kd(flip,1) * (nx+1-j)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                   kd(axis,1) * kd(flip,1) * (ny+1+j) +
                   kd(axis,2) * kd(side,1) * (1-ny) +
                   kd(axis,2) * kd(side,2) * ((ny+1)-(i-ny))
         I2[N0-2] = k
         I1=I2
       end
     end

     if I1[N0-1]<1
       if faces[f,2,1,1]==-1
         return NaN
       else
         f1=faces[f,2,1,1]
         axis=faces[f,2,1,2];
         side=faces[f,2,1,3];
         flip=faces[f,2,1,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                 kd(axis,1) * kd(side,2) * (nx-j) +
                 kd(axis,2) * kd(flip,0) *  i     +
                 kd(axis,2) * kd(flip,1) * (nx+1-i)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                   kd(axis,1) * kd(flip,1) * (ny+1-i) +
                   kd(axis,2) * kd(side,1) * (1-j) +
                   kd(axis,2) * kd(side,2) * (ny+j)
         I2[N0-2] = k
         I1=I2
       end
     end
     if I1[N0-1]>ny
       if faces[f,2,2,1]==-1
         return NaN
       else
         f1=faces[f,2,2,1]
         axis=faces[f,2,2,2];
         side=faces[f,2,2,3];
         flip=faces[f,2,2,4];
         I2[N0] = kd(axis,1) * kd(side,1) * (j-ny)   +
                 kd(axis,1) * kd(side,2) * (ny+1-(j-ny)) +
                 kd(axis,2) * kd(flip,0) *  i     +
                 kd(axis,2) * kd(flip,1) * (nx+1-i)
         I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                   kd(axis,1) * kd(flip,1) * (ny+1-i) +
                   kd(axis,2) * kd(side,1) * (j-ny) +
                   kd(axis,2) * kd(side,2) * (ny+1-(ny-j))
         I2[N0-2] = k
         I1=I2
       end
     end


     if I1[N0-2]<1
       if faces[f,3,1,1]==-1
         return NaN
       else
         f1=faces[f,3,1,1]
         axis=faces[f,3,1,2];
         side=faces[f,3,1,3];
         flip=faces[f,3,1,4];
         I2[N0] = i
         I2[N0-1] = k
         I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                   kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
         I1=I2
       end
     end
     if I1[N0-2]>nz
       if faces[f,3,2,1]==-1
         return NaN
       else
         f1=faces[f,3,2,1]
         axis=faces[f,3,2,2];
         side=faces[f,3,2,3];
         flip=faces[f,3,2,4];
         I2[N0] = i
         I2[N0-1] = j
         I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                   kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
         I1=I2
       end
     end
   end
   return Base.setindex!(A.data,value,I1[N0-length(S)+1:N0]...)
 end
 Base.setindex(A::CircularArray,value, I) = (A[i] for i in I)
 Base.IndexStyle(::Type{CircularArray}) = IndexCartesian()

 function Base.getindex(A::CircularArray,value,I::Vararg{CartesianIndices, N}) where N
  I1=[i for i in I]
 end

end # module
