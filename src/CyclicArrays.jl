module CyclicArrays

 include("utils.jl")
 export CyclicArray,shiftc,stagger,diff

 """
     CyclicArray
 CyclicArray data structure. Available constructors:
 ```
 CyclicArray(data::AbstractArray{T,N}, connections::AbstractArray)
 ```
 To generate a new CyclicArray with the connections of x:
 ```
 CyclicArray(x::CyclicArray)
 ```
 To generate a new CyclicArray with the connections:
 ```
 CyclicArray(connections)
 ```
 To generate a new CyclicArray with the connections of y and data from x:
 ```
 CyclicArray(x::AbstractArray,y::CyclicArray)
 ```
 To generate a new CyclicArray with predifined connections:
 ```
 CyclicArray(x::AbstractArray,str::String)
 ```
 Avilable options:

  "1D" - one dimensional array, one face

  "2D" - two dimensional array, one face

  "3D" - three dimensional array, one face

  "cubed" - cubed sphere, three dimensional array, six faces

  "cubed2D" - cubed sphere, two dimensional array, six faces
 """
 struct CyclicArray{T,N} <: AbstractArray{T,N} #inherits from AbstractArray
    data::AbstractArray{T,N}
    connections::Array{T,4}
    function CyclicArray(data::AbstractArray{T,N},connections) where {T,N} 
      #creates the type only with a vector x
      if ((length(size(data)))<(size(connections)[2]))&(~isempty(data))
        error(string("number of array dimensions should be larger or equal to the spatial dimensions (",size(connections)[2],")"))
      else
        return new{T,N}(data,connections)
      end
    end
 end


 Base.show(io::IO, ::MIME"text/plain", A::CyclicArray{T,1}) where{T} =
           print(io, length(A),"-element CyclicArray{$T,1}:\n   ", A.data)

 Base.size(A::CyclicArray) = size(A.data)
 CyclicArray(x::CyclicArray)=CyclicArray([],x.connections)
 CyclicArray(x::AbstractArray,y::CyclicArray)=CyclicArray(x,y.connections)
 CyclicArray(connections::Array{T,4}) where T =CyclicArray([],connections)
 
 function MakeCyclicArray(x::AbstractArray,str::String)
  if str=="1D"
    nfaces=1;
    faces=zeros(nfaces,1,2,4);
    faces[1,1,1,:]=[1,1,2,0];
    faces[1,1,2,:]=[1,1,1,0];
  elseif str=="1D2F"
      nfaces=2;
      faces=zeros(nfaces,1,2,4);
      faces[1,1,1,:]=[2,1,2,0];
      faces[1,1,2,:]=[2,1,1,0];
      faces[2,1,1,:]=[1,1,2,0];
      faces[2,1,2,:]=[1,1,1,0];
  elseif str=="2D"
    nfaces=1;
    faces=zeros(nfaces,2,2,4);
    faces[1,1,1,:]=[1,1,2,0];
    faces[1,1,2,:]=[1,1,1,0];
    faces[1,2,1,:]=[1,2,2,0];
    faces[1,2,2,:]=[1,2,1,0];
  elseif str=="2DXY"
    nfaces=1;
    faces=zeros(nfaces,2,2,4);
    faces[1,1,1,:]=[1,2,2,0];
    faces[1,1,2,:]=[1,2,1,0];
    faces[1,2,1,:]=[1,1,2,0];
    faces[1,2,2,:]=[1,1,1,0];
  elseif str=="3D"
    nfaces=1;
    faces=zeros(nfaces,3,2,4);
    faces[1,1,1,:]=[1,1,2,0];
    faces[1,1,2,:]=[1,1,1,0];
    faces[1,2,1,:]=[1,2,2,0];
    faces[1,2,2,:]=[1,2,1,0];
    faces[1,3,1,:].=-1;
    faces[1,3,2,:].=-1;
  elseif str=="3DXY"
    nfaces=1;
    faces=zeros(nfaces,3,2,4);
    faces[1,1,1,:]=[1,2,2,0];
    faces[1,1,2,:]=[1,2,1,0];
    faces[1,2,1,:]=[1,1,2,0];
    faces[1,2,2,:]=[1,1,1,0];
    faces[1,3,1,:].=-1;
    faces[1,3,2,:].=-1;
  elseif str=="cubed"
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
  elseif str=="cubed2D"
    nfaces=6
    faces=zeros(Int64,nfaces,2,2,4);

    faces[1,1,1,:]=[4,1,2,0]
    faces[1,1,2,:]=[2,1,1,0]
    faces[1,2,1,:]=[6,2,2,0]
    faces[1,2,2,:]=[5,2,1,0]

    faces[2,1,1,:]=[1,1,2,0]
    faces[2,1,2,:]=[3,1,1,0]
    faces[2,2,1,:]=[6,1,2,1]
    faces[2,2,2,:]=[5,1,2,0]

    faces[3,1,1,:]=[2,1,2,0]
    faces[3,1,2,:]=[4,1,1,0]
    faces[3,2,1,:]=[6,2,1,1]
    faces[3,2,2,:]=[5,2,2,1]

    faces[4,1,1,:]=[3,1,2,0]
    faces[4,1,2,:]=[1,1,1,0]
    faces[4,2,1,:]=[6,1,1,0]
    faces[4,2,2,:]=[5,1,1,1]

    faces[5,1,1,:]=[4,2,2,1]
    faces[5,1,2,:]=[2,2,2,0]
    faces[5,2,1,:]=[1,2,2,0]
    faces[5,2,2,:]=[3,2,2,0]

    faces[6,1,1,:]=[4,2,1,0]
    faces[6,1,2,:]=[2,2,1,1]
    faces[6,2,1,:]=[3,2,1,1]
    faces[6,2,2,:]=[1,2,1,0]
  end
  return CyclicArray(x,faces);
 end
 
 CyclicArray(x::AbstractArray,str::String)=MakeCyclicArray(x,str)
 CyclicArray(str::String)=MakeCyclicArray([],str)


 Base.view(A::CyclicArray) = Base.view(A.data)
 Base.ndims(A::CyclicArray) = ndims(A.data)
 Base.Dims(A::CyclicArray) = Dims(A.data)

 Base.length(A::CyclicArray)=length(A.data)
 Base.similar(A::CyclicArray)=CyclicArray(Array{eltype(A.data)}(undef, size(A.data)),A.connections)
 Base.similar(A::CyclicArray, S::DataType)=CyclicArray(Array{S}(undef, size(A.data)),A.connections)
 Base.similar(A::CyclicArray, dims::Dims)=CyclicArray(similar(A.data,dims),A.connections)
 # The next line produce error, not clear why
 #Base.similar(A::CyclicArray, S::DataType, dims::Dims)=CyclicArray(Array{S}(undef, dims),A.connections)
 Base.axes(A::CyclicArray) = axes(A.data)
 
 Base.findall(A::CyclicArray) = findall(A.data)
 Base.findfirst(A::CyclicArray) = findfirst(A.data)
 Base.findlast(A::CyclicArray) = findlast(A.data)
 Base.findprev(A::CyclicArray, I...) = findprev(A.data, I...)
 Base.findnext(A::CyclicArray, I...) = findnext(A.data, I...)
 Base.checkbounds(A::CyclicArray, I...) = nothing
 Base.CartesianIndices(A::CyclicArray) = CartesianIndices(A.data)
 Base.maximum(A::CyclicArray,dims) = maximum(A.data, dims=dims)
 Base.minimum(A::CyclicArray,dims) = minimum(A.data, dims=dims)

 """
    diff

 ```
 diff(A::CyclicArray)
 diff(A::CyclicArray; dims::Integer)
 ```

 Finite difference operator on a vector or a multidimensional array A. In the latter case the dimension to operate on needs to be
 specified with the dims keyword argument.
 """
 function Base.diff(A::CyclicArray; dims=1::Integer)
  I=size(A.data)
  I1=[UnitRange(1:I[i]) for i in 1:length(I)]
  I2=copy(I1)
  I2[dims]=I1[dims].+1
  B=CyclicArray(zeros(size(A.data)),A.connections)
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

 """
    stagger
 ```
 stagger(A::CyclicArray; dims=1::Integer, frac=0.5::Real)
 ```
 Linear interpolation of the array to intermidiate grid positions
 """
 function stagger(A::CyclicArray; dims=1::Integer, frac=0.5::Real)
  I=size(A.data)
  I1=[UnitRange(1:I[i]) for i in 1:length(I)]
  I2=copy(I1)
  I2[dims]=I1[dims].+Int(sign(frac))
  B=CyclicArray(zeros(size(A.data)),A.connections)
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

"""
    shiftc
```
shiftc(A::CyclicArray; dims=1::Integer, shift=1::Real)
```
Shifts array by an integer
"""
 function shiftc(A::CyclicArray; dims=1::Integer, shift=1::Real)
   I=size(A.data)
   I1=[UnitRange(1:I[i]) for i in 1:length(I)]
   I2=copy(I1)
   I2[dims]=I1[dims].-shift
   B=CyclicArray(zeros(size(A.data)),A.connections)
   CI1=CartesianIndices(Tuple(I1))
   CI2=CartesianIndices(Tuple(I2))
   N=length(CI1[1])
   for n in 1:length(CI1)
     I1b=[CI1[n][i]  for i in 1:N]
     I2b=[CI2[n][i]  for i in 1:N]
     B[I1b...]=A[I2b...]
   end
   return B
  end

 Base.:-(A::CyclicArray)=CyclicArray(.-A.data,A.connections)

 Base.:*(A::CyclicArray, B::CyclicArray)=CyclicArray(.*(A.data,B.data),A.connections)
 Base.:*(A::Array, B::CyclicArray)=CyclicArray(.*(A,B.data),B.connections)
 Base.:*(A::CyclicArray, B::Array)=CyclicArray(.*(A.data,B),A.connections)
 Base.:*(A::Number, B::CyclicArray)=CyclicArray(.*(A,B.data),B.connections)
 Base.:*(A::CyclicArray, B::Number)=CyclicArray(.*(A.data,B),A.connections)

 Base.:-(A::CyclicArray, B::CyclicArray)=CyclicArray(.-(A.data,B.data),A.connections)
 Base.:-(A::Number, B::CyclicArray)=CyclicArray(.-(A,B.data),B.connections)
 Base.:-(A::CyclicArray, B::Number)=CyclicArray(.-(A.data,B),A.connections)
 Base.:-(A::Array, B::CyclicArray)=CyclicArray(.-(A,B.data),B.connections)
 Base.:-(A::CyclicArray, B::Array)=CyclicArray(.-(A.data,B),A.connections)

 Base.:+(A::CyclicArray, B::CyclicArray)=CyclicArray(.+(A.data,B.data),A.connections)
 Base.:+(A::Number, B::CyclicArray)=CyclicArray(.+(A,B.data),B.connections)
 Base.:+(A::CyclicArray, B::Number)=CyclicArray(.+(A.data,B),A.connections)
 Base.:+(A::Array, B::CyclicArray)=CyclicArray(.+(A,B.data),B.connections)
 Base.:+(A::CyclicArray, B::Array)=CyclicArray(.+(A.data,B),A.connections)

 Base.:^(A::CyclicArray, B::CyclicArray)=CyclicArray(.^(A.data,B.data),A.connections)
 Base.:^(A::Number, B::CyclicArray)=CyclicArray(.^(A,B.data),B.connections)
 Base.:^(A::CyclicArray, B::Number)=CyclicArray(.^(A.data,B),A.connections)
 Base.:^(A::Array, B::CyclicArray)=CyclicArray(.^(A,B.data),B.connections)
 Base.:^(A::CyclicArray, B::Array)=CyclicArray(.^(A.data,B),A.connections)

 Base.:/(A::CyclicArray, B::CyclicArray)=CyclicArray(./(A.data,B.data),A.connections)
 Base.:/(A::Number, B::CyclicArray)=CyclicArray(./(A,B.data),B.connections)
 Base.:/(A::CyclicArray, B::Number)=CyclicArray(./(A.data,B),A.connections)
 Base.:/(A::Array, B::CyclicArray)=CyclicArray(./(A,B.data),B.connections)
 Base.:/(A::CyclicArray, B::Array)=CyclicArray(./(A.data,B),A.connections)

 Base.:\(A::CyclicArray, B::CyclicArray)=CyclicArray(.\(A.data,B.data),A.connections)
 Base.:\(A::Number, B::CyclicArray)=CyclicArray(.\(A,B.data),B.connections)
 Base.:\(A::CyclicArray, B::Number)=CyclicArray(.\(A.data,B),A.connections)
 Base.:\(A::Array, B::CyclicArray)=CyclicArray(.\(A,B.data),B.connections)
 Base.:\(A::CyclicArray, B::Array)=CyclicArray(.\(A.data,B),A.connections)

 Base.:>=(A::CyclicArray, B::CyclicArray)=CyclicArray(Array{Int}(.>=(A.data,B.data)),A.connections)
 Base.:>=(A::Number, B::CyclicArray)=CyclicArray(Array{Int}(.>=(A,B.data)),B.connections)
 Base.:>=(A::CyclicArray, B::Number)=CyclicArray(Array{Int}(.>=(A.data,B)),A.connections)
 Base.:>=(A::Array, B::CyclicArray)=CyclicArray(Array{Int}(.>=(A,B.data)),B.connections)
 Base.:>=(A::CyclicArray, B::Array)=CyclicArray(Array{Int}(.>=(A.data,B)),A.connections)

 Base.:<=(A::CyclicArray, B::CyclicArray)=CyclicArray(Array{Int}(.<=(A.data,B.data)),A.connections)
 Base.:<=(A::Number, B::CyclicArray)=CyclicArray(Array{Int}(.<=(A,B.data)),B.connections)
 Base.:<=(A::CyclicArray, B::Number)=CyclicArray(Array{Int}(.<=(A.data,B)),A.connections)
 Base.:<=(A::Array, B::CyclicArray)=CyclicArray(Array{Int}(.<=(A,B.data)),B.connections)
 Base.:<=(A::CyclicArray, B::Array)=CyclicArray(Array{Int}(.<=(A.data,B)),A.connections)

 Base.:>(A::CyclicArray, B::CyclicArray)=CyclicArray(Array{Int}(.>(A.data,B.data)),A.connections)
 Base.:>(A::Number, B::CyclicArray)=CyclicArray(Array{Int}(.>(A,B.data)),B.connections)
 Base.:>(A::CyclicArray, B::Number)=CyclicArray(Array{Int}(.>(A.data,B)),A.connections)
 Base.:>(A::Array, B::CyclicArray)=CyclicArray(Array{Int}(.>(A,B.data)),B.connections)
 Base.:>(A::CyclicArray, B::Array)=CyclicArray(Array{Int}(.>(A.data,B)),A.connections)

 Base.:<(A::CyclicArray, B::CyclicArray)=CyclicArray(Array{Int}(.<(A.data,B.data)),A.connections)
 Base.:<(A::Number, B::CyclicArray)=CyclicArray(Array{Int}(.<(A,B.data)),B.connections)
 Base.:<(A::CyclicArray, B::Number)=CyclicArray(Array{Int}(.<(A.data,B)),A.connections)
 Base.:<(A::Array, B::CyclicArray)=CyclicArray(Array{Int}(.<(A,B.data)),B.connections)
 Base.:<(A::CyclicArray, B::Array)=CyclicArray(Array{Int}(.<(A.data,B)),A.connections)

 Base.:(==)(A::CyclicArray, B::CyclicArray)=CyclicArray(Array{Int}(.==(A.data,B.data)),A.connections)
 Base.:(==)(A::Number, B::CyclicArray)=CyclicArray(Array{Int}(.==(A,B.data)),B.connections)
 Base.:(==)(A::CyclicArray, B::Number)=CyclicArray(Array{Int}(.==(A.data,B)),A.connections)
 Base.:(==)(A::Array, B::CyclicArray)=CyclicArray(Array{Int}(.==(A,B.data)),B.connections)
 Base.:(==)(A::CyclicArray, B::Array)=CyclicArray(Array{Int}(.==(A.data,B)),A.connections)



 function Base.getindex(A::CyclicArray, I::Vararg{Int, N}) where N # implements A[I]
  connections=A.connections
  nfaces=size(A.connections)[1]
  nspatial=size(A.connections)[2]
  I1=[i for i in I]
  N0=length(I1)
  S=size(A)
  if nspatial==3
    nx=S[N0];ny=S[N0-1];nz=S[N0-2];
    while (I1[N0]<1 || I1[N0]>nx) || (I1[N0-1]<1 || I1[N0-1]>ny) || (I1[N0-2]<1 || I1[N0-2]>nz)
      I2=I1
      i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
      if nfaces>1
        f=I1[N0-3]
      else
        f=1
      end
      if I1[N0]<1
        if connections[f,1,1,1]==-1
          return NaN
        else
          f1=connections[f,1,1,1]
          axis=connections[f,1,1,2];
          side=connections[f,1,1,3];
          flip=connections[f,1,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx+i) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (1-i) +
                    kd(axis,2) * kd(side,2) * (ny+i)
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
      if I1[N0]>nx
        if connections[f,1,2,1]==-1
          return NaN
        else
          f1=connections[f,1,2,1];
          axis=connections[f,1,2,2];
          side=connections[f,1,2,3];
          flip=connections[f,1,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (i-nx)   +
                  kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx)) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (i-ny) +
                    kd(axis,2) * kd(side,2) * ((ny+1)-(i-ny))
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end

      if I1[N0-1]<1
        if connections[f,2,1,1]==-1
          return NaN
        else
          f1=connections[f,2,1,1]
          axis=connections[f,2,1,2];
          side=connections[f,2,1,3];
          flip=connections[f,2,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx-j) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (1-j) +
                    kd(axis,2) * kd(side,2) * (ny+j)
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
      if I1[N0-1]>ny
        if connections[f,2,2,1]==-1
          return NaN
        else
          f1=connections[f,2,2,1]
          axis=connections[f,2,2,2];
          side=connections[f,2,2,3];
          flip=connections[f,2,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (j-ny)   +
                  kd(axis,1) * kd(side,2) * (ny+1-(j-ny)) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (j-ny) +
                    kd(axis,2) * kd(side,2) * (ny+1-(ny-j))
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end

      if I1[N0-2]<1
        if connections[f,3,1,1]==-1
          return NaN
        else
          f1=connections[f,3,1,1]
          axis=connections[f,3,1,2];
          side=connections[f,3,1,3];
          flip=connections[f,3,1,4];
          I2[N0] = i
          I2[N0-1] = k
          I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                    kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
      if I1[N0-2]>nz
        if connections[f,3,2,1]==-1
          return NaN
        else
          f1=connections[f,3,2,1]
          axis=connections[f,3,2,2];
          side=connections[f,3,2,3];
          flip=connections[f,3,2,4];
          I2[N0] = i
          I2[N0-1] = j
          I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                    kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
    end
  # 2d array
  elseif nspatial==2
    nx=S[N0];ny=S[N0-1]
    while (I1[N0]<1 || I1[N0]>nx) || (I1[N0-1]<1 || I1[N0-1]>ny)
      I2=I1
      i=I1[N0]; j=I1[N0-1]
      if nfaces>1
        f=I1[N0-2]
      else
        f=1
      end
      if I1[N0]<1
        if connections[f,1,1,1]==-1
          return NaN
        else
          f1=connections[f,1,1,1]
          axis=connections[f,1,1,2];
          side=connections[f,1,1,3];
          flip=connections[f,1,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx+i) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (1-i) +
                    kd(axis,2) * kd(side,2) * (ny+i)
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end
      if I1[N0]>nx
        if connections[f,1,2,1]==-1
          return NaN
        else
          f1=connections[f,1,2,1];
          axis=connections[f,1,2,2];
          side=connections[f,1,2,3];
          flip=connections[f,1,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (i-nx)   +
                  kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx)) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (i-ny) +
                    kd(axis,2) * kd(side,2) * ((ny+1)-(i-ny))
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end

      if I1[N0-1]<1
        if connections[f,2,1,1]==-1
          return NaN
        else
          f1=connections[f,2,1,1]
          axis=connections[f,2,1,2];
          side=connections[f,2,1,3];
          flip=connections[f,2,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx-j) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (1-j) +
                    kd(axis,2) * kd(side,2) * (ny+j)
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end
      if I1[N0-1]>ny
        if connections[f,2,2,1]==-1
          return NaN
        else
          f1=connections[f,2,2,1]
          axis=connections[f,2,2,2];
          side=connections[f,2,2,3];
          flip=connections[f,2,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (j-ny)   +
                  kd(axis,1) * kd(side,2) * (ny+1-(j-ny)) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (j-ny) +
                    kd(axis,2) * kd(side,2) * (ny+1-(ny-j))
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end
    end
# 1d array
  elseif nspatial==1
    nx=size(A)[N0];
    while (I1[N0]<1 || I1[N0]>nx)
      I2=I1
      i=I1[N0]
      if nfaces>1
        f=I1[N0-1]
      else
        f=1
      end
      if I1[N0]<1
        if connections[f,1,1,1]==-1
          return NaN
        else
          f1=connections[f,1,1,1]
          axis=connections[f,1,1,2];
          side=connections[f,1,1,3];
          flip=connections[f,1,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i) +
                   kd(axis,1) * kd(side,2) * (nx+i)
          if nfaces>1; I2[N0-1]=f1 end
          I1=I2
          i=I1[N0]
        end
      end
      if I1[N0]>nx
        if connections[f,1,2,1]==-1
          return NaN
        else
          f1=connections[f,1,2,1];
          axis=connections[f,1,2,2];
          side=connections[f,1,2,3];
          flip=connections[f,1,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (i-nx)   +
                  kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx))
          if nfaces>1; I2[N0-1]=f1 end
          I1=I2
          i=I1[N0]
        end
      end
    end
  end
  return Base.getindex(A.data,I1[N0-length(S)+1:N0]...)
end

Base.getindex(A::CyclicArray, I) = [ Base.getindex(A::CyclicArray, i) for i in I]

function Base.setindex!(A::CyclicArray,value,I::Vararg{Int, N}) where N # A[I] = value
  connections=A.connections
  nfaces=size(A.connections)[1]
  nspatial=size(A.connections)[2]
  I1=[i for i in I]
  N0=length(I1)
  S=size(A)
  if nspatial==3
    nx=S[N0];ny=S[N0-1];nz=S[N0-2];
    while (I1[N0]<1 || I1[N0]>nx) || (I1[N0-1]<1 || I1[N0-1]>ny) || (I1[N0-2]<1 || I1[N0-2]>nz)
      I2=I1
      i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
      if nfaces>1
        f=I1[N0-3]
      else
        f=1
      end
      if I1[N0]<1
        if connections[f,1,1,1]==-1
          return NaN
        else
          f1=connections[f,1,1,1]
          axis=connections[f,1,1,2];
          side=connections[f,1,1,3];
          flip=connections[f,1,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx+i) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (1-i) +
                    kd(axis,2) * kd(side,2) * (ny+i)
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
      if I1[N0]>nx
        if connections[f,1,2,1]==-1
          return NaN
        else
          f1=connections[f,1,2,1];
          axis=connections[f,1,2,2];
          side=connections[f,1,2,3];
          flip=connections[f,1,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (i-nx)   +
                  kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx)) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (i-ny) +
                    kd(axis,2) * kd(side,2) * ((ny+1)-(i-ny))
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end

      if I1[N0-1]<1
        if connections[f,2,1,1]==-1
          return NaN
        else
          f1=connections[f,2,1,1]
          axis=connections[f,2,1,2];
          side=connections[f,2,1,3];
          flip=connections[f,2,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx-j) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (1-j) +
                    kd(axis,2) * kd(side,2) * (ny+j)
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
      if I1[N0-1]>ny
        if connections[f,2,2,1]==-1
          return NaN
        else
          f1=connections[f,2,2,1]
          axis=connections[f,2,2,2];
          side=connections[f,2,2,3];
          flip=connections[f,2,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (j-ny)   +
                  kd(axis,1) * kd(side,2) * (ny+1-(j-ny)) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (j-ny) +
                    kd(axis,2) * kd(side,2) * (ny+1-(ny-j))
          I2[N0-2] = k
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end

      if I1[N0-2]<1
        if connections[f,3,1,1]==-1
          return NaN
        else
          f1=connections[f,3,1,1]
          axis=connections[f,3,1,2];
          side=connections[f,3,1,3];
          flip=connections[f,3,1,4];
          I2[N0] = i
          I2[N0-1] = k
          I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                    kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
      if I1[N0-2]>nz
        if connections[f,3,2,1]==-1
          return NaN
        else
          f1=connections[f,3,2,1]
          axis=connections[f,3,2,2];
          side=connections[f,3,2,3];
          flip=connections[f,3,2,4];
          I2[N0] = i
          I2[N0-1] = j
          I2[N0-2] = kd(axis,3) * kd(side,1) * (k-nz)   +
                    kd(axis,3) * kd(side,2) * (nz+1-(k-nz))
          if nfaces>1; I2[N0-3]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]; k=I1[N0-2]
        end
      end
    end
  # 2d array
  elseif nspatial==2
    nx=S[N0];ny=S[N0-1]
    while (I1[N0]<1 || I1[N0]>nx) || (I1[N0-1]<1 || I1[N0-1]>ny)
      I2=I1
      i=I1[N0]; j=I1[N0-1]
      if nfaces>1
        f=I1[N0-2]
      else
        f=1
      end
      if I1[N0]<1
        if connections[f,1,1,1]==-1
          return NaN
        else
          f1=connections[f,1,1,1]
          axis=connections[f,1,1,2];
          side=connections[f,1,1,3];
          flip=connections[f,1,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx+i) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (1-i) +
                    kd(axis,2) * kd(side,2) * (ny+i)
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end
      if I1[N0]>nx
        if connections[f,1,2,1]==-1
          return NaN
        else
          f1=connections[f,1,2,1];
          axis=connections[f,1,2,2];
          side=connections[f,1,2,3];
          flip=connections[f,1,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (i-nx)   +
                  kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx)) +
                  kd(axis,2) * kd(flip,0) *  j     +
                  kd(axis,2) * kd(flip,1) * (nx+1-j)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  j +
                    kd(axis,1) * kd(flip,1) * (ny+1+j) +
                    kd(axis,2) * kd(side,1) * (i-ny) +
                    kd(axis,2) * kd(side,2) * ((ny+1)-(i-ny))
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end

      if I1[N0-1]<1
        if connections[f,2,1,1]==-1
          return NaN
        else
          f1=connections[f,2,1,1]
          axis=connections[f,2,1,2];
          side=connections[f,2,1,3];
          flip=connections[f,2,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i)   +
                  kd(axis,1) * kd(side,2) * (nx-j) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (1-j) +
                    kd(axis,2) * kd(side,2) * (ny+j)
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end
      if I1[N0-1]>ny
        if connections[f,2,2,1]==-1
          return NaN
        else
          f1=connections[f,2,2,1]
          axis=connections[f,2,2,2];
          side=connections[f,2,2,3];
          flip=connections[f,2,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (j-ny)   +
                  kd(axis,1) * kd(side,2) * (ny+1-(j-ny)) +
                  kd(axis,2) * kd(flip,0) *  i     +
                  kd(axis,2) * kd(flip,1) * (nx+1-i)
          I2[N0-1] = kd(axis,1) * kd(flip,0) *  i +
                    kd(axis,1) * kd(flip,1) * (ny+1-i) +
                    kd(axis,2) * kd(side,1) * (j-ny) +
                    kd(axis,2) * kd(side,2) * (ny+1-(ny-j))
          if nfaces>1; I2[N0-2]=f1 end
          I1=I2
          i=I1[N0]; j=I1[N0-1]
        end
      end
    end
# 1d array
  elseif nspatial==1
    nx=size(A)[N0];
    while (I1[N0]<1 || I1[N0]>nx)
      I2=I1
      i=I1[N0]
      if nfaces>1
        f=I1[N0-1]
      else
        f=1
      end
      if I1[N0]<1
        if connections[f,1,1,1]==-1
          return NaN
        else
          f1=connections[f,1,1,1]
          axis=connections[f,1,1,2];
          side=connections[f,1,1,3];
          flip=connections[f,1,1,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (1-i) +
                   kd(axis,1) * kd(side,2) * (nx+i)
          if nfaces>1; I2[N0-1]=f1 end
          I1=I2
          i=I1[N0]
        end
      end
      if I1[N0]>nx
        if connections[f,1,2,1]==-1
          return NaN
        else
          f1=connections[f,1,2,1];
          axis=connections[f,1,2,2];
          side=connections[f,1,2,3];
          flip=connections[f,1,2,4];
          I2[N0] = kd(axis,1) * kd(side,1) * (i-nx)   +
                  kd(axis,1) * kd(side,2) * ((nx+1)-(i-nx))
          if nfaces>1; I2[N0-1]=f1 end
          I1=I2
          i=I1[N0]
        end
      end
    end
  end
  return Base.setindex!(A.data,value,I1[N0-length(S)+1:N0]...)
end
Base.setindex(A::CyclicArray,value, I) = [Base.setindex(A::CyclicArray,value, I) for i in I]
Base.IndexStyle(::Type{CyclicArray}) = IndexCartesian()

# function Base.getindex(A::CyclicArray,value,I::Vararg{CartesianIndices, N}) where N
#  I1=[i for i in I]
# end

end # module
