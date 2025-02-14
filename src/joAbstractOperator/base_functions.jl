############################################################
## joAbstractOperator - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractOperator) = jo_method_error(A,"eltype(jo) not implemented")

# deltype(jo)
deltype(A::joAbstractOperator) = jo_method_error(A,"deltype(jo) not implemented")

# reltype(jo)
reltype(A::joAbstractOperator) = jo_method_error(A,"reltype(jo) not implemented")

# show(jo)
show(A::joAbstractOperator) = jo_method_error(A,"show(jo) not implemented")

# display(jo)
display(A::joAbstractOperator) = jo_method_error(A,"display(jo) not implemented")

# size(jo)
size(A::joAbstractOperator) = jo_method_error(A,"size(jo) not implemented")

# size(jo,1/2)
size(A::joAbstractOperator,ind) = jo_method_error(A,"size(jo,1/2) not implemented")

# length(jo)
length(A::joAbstractOperator) = jo_method_error(A,"length(jo) not implemented")

# jo_full(jo)
jo_full(A::joAbstractOperator) = jo_method_error(A,"jo_full(jo) not implemented")

# norm(jo)
norm(A::joAbstractOperator,p) = jo_method_error(A,"norm(jo) not implemented")

# real(jo)
real(A::joAbstractOperator) = jo_method_error(A,"real(jo) not implemented")

# imag(jo)
imag(A::joAbstractOperator) = jo_method_error(A,"imag(jo) not implemented")

# conj(jo)
conj(A::joAbstractOperator) = jo_method_error(A,"conj(jo) not implemented")

# transpose(jo)
transpose(A::joAbstractOperator) = jo_method_error(A,"transpose(jo) not implemented")

# adjoint(jo)
adjoint(A::joAbstractOperator) = jo_method_error(A,"adjoint(jo) not implemented")

# isreal(jo)
isreal(A::joAbstractOperator) = jo_method_error(A,"isreal(jo) not implemented")

# issymmetric(jo)
issymmetric(A::joAbstractOperator) = jo_method_error(A,"issymmetric(jo) not implemented")

# ishermitian(jo)
ishermitian(A::joAbstractOperator) = jo_method_error(A,"ishermitian(jo) not implemented")

# isequal(jo,jo)
isequal(A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,"isequal(jo,jo) not implemented or type mismatch")

# isapprox(jo,jo)
isapprox(A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,"isapprox(jo,jo) not implemented or type mismatch")

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)
*(A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,"*(jo,jo) not implemented or type mismatch")

# *(jo,mvec)
*(A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,"*(jo,mvec) not implemented or type mismatch")

# *(mvec,jo)
*(mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,"*(mvec,jo) not implemented or type mismatch")

# *(jo,vec)
*(A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,"*(jo,vec) not implemented or type mismatch")

# *(vec,jo)
*(v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,"*(vec,jo) not implemented or type mismatch")

# *(num,jo)
*(a,A::joAbstractOperator) = jo_method_error(a,A,"*(any,jo) not implemented or type mismatch")

# *(jo,num)
*(A::joAbstractOperator,a) = jo_method_error(A,a,"*(jo,any) not implemented or type mismatch")

############################################################
## overloaded Base \(...jo...)

# \(jo,jo)
\(A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,"\\(jo,jo) not implemented or type mismatch")

# \(jo,mvec)
\(A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,"\\(jo,mvec) not implemented or type mismatch")

# \(mvec,jo)
\(mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,"\\(mvec,jo) not implemented or type mismatch")

# \(jo,vec)
\(A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,"\\(jo,vec) not implemented or type mismatch")

# \(vec,jo)
\(v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,"\\(vec,jo) not implemented or type mismatch")

# \(num,jo)
\(a,A::joAbstractOperator) = jo_method_error(a,A,"\\(any,jo) not implemented or type mismatch")

# \(jo,num)
\(A::joAbstractOperator,a) = jo_method_error(A,a,"\\(jo,any) not implemented or type mismatch")

############################################################
## overloaded Base +(...jo...)

# +(jo)
+(A::joAbstractOperator) = jo_method_error(A,"+(jo) not implemented")

# +(jo,jo)
+(A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,"+(jo,jo) not implemented or type mismatch")

# +(jo,mvec)
+(A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,"+(jo,mvec) not implemented or type mismatch")

# +(mvec,jo)
+(mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,"+(mvec,jo) not implemented or type mismatch")

# +(jo,vec)
+(A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,"+(jo,vec) not implemented or type mismatch")

# +(vec,jo)
+(v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,"+(vec,jo) not implemented or type mismatch")

# +(jo,num)
+(A::joAbstractOperator,b) = jo_method_error(A,b,"+(jo,any) not implemented or type mismatch")

# +(num,jo)
+(b,A::joAbstractOperator) = jo_method_error(b,A,"+(any,jo) not implemented or type mismatch")

############################################################
## overloaded Base -(...jo...)

# -(jo)
-(A::joAbstractOperator) = jo_method_error(A,"-(jo) not implemented")

# -(jo,jo)
-(A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,"-(jo,jo) not implemented or type mismatch")

# -(jo,mvec)
-(A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,"-(jo,mvec) not implemented or type mismatch")

# -(mvec,jo)
-(mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,"-(mvec,jo) not implemented or type mismatch")

# -(jo,vec)
-(A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,"-(jo,vec) not implemented or type mismatch")

# -(vec,jo)
-(v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,"-(vec,jo) not implemented or type mismatch")

# -(jo,num)
-(A::joAbstractOperator,b) = jo_method_error(A,b,"-(jo,any) not implemented or type mismatch")

# -(num,jo)
-(b,A::joAbstractOperator) = jo_method_error(b,A,"-(any,jo) not implemented or type mismatch")

############################################################
## overloaded Base .*(...jo...)
## function Base.Broadcast.broadcasted(::typeof(*), ...)

# .*(jo,jo)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,".*(jo,jo) not implemented")

# .*(jo,mvec)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,".*(jo,mvec) not implemented")

# .*(mvec,jo)
Base.Broadcast.broadcasted(::typeof(*),mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,".*(mvec,jo) not implemented")

# .*(jo,vec)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,".*(jo,vec) not implemented")

# .*(vec,jo)
Base.Broadcast.broadcasted(::typeof(*),v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,".*(vec,jo) not implemented")

# .*(num,jo)
Base.Broadcast.broadcasted(::typeof(*),a,A::joAbstractOperator) = jo_method_error(a,A,".*(any,jo) not implemented")

# .*(jo,num)
Base.Broadcast.broadcasted(::typeof(*),A::joAbstractOperator,a) = jo_method_error(A,a,".*(jo,any) not implemented")

############################################################
## overloaded Base .\(...jo...)
## function Base.Broadcast.broadcasted(::typeof(\), ...)

# .\(jo,jo)
Base.Broadcast.broadcasted(::typeof(\),A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,".(jo,jo) not implemented")

# .\(jo,mvec)
Base.Broadcast.broadcasted(::typeof(\),A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,".(jo,mvec) not implemented")

# .\(mvec,jo)
Base.Broadcast.broadcasted(::typeof(\),mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,".(mvec,jo) not implemented")

# .\(jo,vec)
Base.Broadcast.broadcasted(::typeof(\),A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,".(jo,vec) not implemented")

# .\(vec,jo)
Base.Broadcast.broadcasted(::typeof(\),v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,".(vec,jo) not implemented")

# .\(num,jo)
Base.Broadcast.broadcasted(::typeof(\),a,A::joAbstractOperator) = jo_method_error(a,A,".(any,jo) not implemented")

# .\(jo,num)
Base.Broadcast.broadcasted(::typeof(\),A::joAbstractOperator,a) = jo_method_error(A,a,".(jo,any) not implemented")

############################################################
## overloaded Base .+(...jo...)
## function Base.Broadcast.broadcasted(::typeof(+), ...)

# .+(jo,jo)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,".+(jo,jo) not implemented")

# .+(jo,mvec)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,".+(jo,mvec) not implemented")

# .+(mvec,jo)
Base.Broadcast.broadcasted(::typeof(+),mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,".+(mvec,jo) not implemented")

# .+(jo,vec)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,".+(jo,vec) not implemented")

# .+(vec,jo)
Base.Broadcast.broadcasted(::typeof(+),v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,".+(vec,jo) not implemented")

# .+(jo,num)
Base.Broadcast.broadcasted(::typeof(+),A::joAbstractOperator,b) = jo_method_error(A,b,".+(jo,any) not implemented")

# .+(num,jo)
Base.Broadcast.broadcasted(::typeof(+),b,A::joAbstractOperator) = jo_method_error(b,A,".+(any,jo) not implemented")

############################################################
## overloaded Base .-(...jo...)
## function Base.Broadcast.broadcasted(::typeof(-), ...)

# .-(jo,jo)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractOperator,B::joAbstractOperator) = jo_method_error(A,B,".-(jo,jo) not implemented")

# .-(jo,mvec)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractOperator,mv::AbstractMatrix) = jo_method_error(A,mv,".-(jo,mvec) not implemented")

# .-(mvec,jo)
Base.Broadcast.broadcasted(::typeof(-),mv::AbstractMatrix,A::joAbstractOperator) = jo_method_error(mv,A,".-(mvec,jo) not implemented")

# .-(jo,vec)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractOperator,v::AbstractVector) = jo_method_error(A,v,".-(jo,vec) not implemented")

# .-(vec,jo)
Base.Broadcast.broadcasted(::typeof(-),v::AbstractVector,A::joAbstractOperator) = jo_method_error(v,A,".-(vec,jo) not implemented")

# .-(jo,num)
Base.Broadcast.broadcasted(::typeof(-),A::joAbstractOperator,b) = jo_method_error(A,b,".-(jo,any) not implemented")

# .-(num,jo)
Base.Broadcast.broadcasted(::typeof(-),b,A::joAbstractOperator) = jo_method_error(b,A,".-(any,jo) not implemented")

############################################################
## overloaded Base block methods

# hcat(...jo...)
hcat(ops::joAbstractOperator...) = jo_method_error(ops[1],"hcat(jo...) not implemented")


# vcat(...jo...)
vcat(ops::joAbstractOperator...) = jo_method_error(ops[1],"vcat(jo...) not implemented")

# hvcat(...jo...)
hvcat(rows::Tuple{Vararg{Int}}, ops::joAbstractOperator...) = jo_method_error(ops[1],"hvcat(jo...) not implemented")

############################################################
## overloaded LinearAlgebra functions

# mul!(...,jo,...)
mul!(y::AbstractVector,A::joAbstractOperator,x::AbstractVector)=jo_method_error(y,A,x,"mul!(vec,jo,vec) not implemented or type mismatch")
mul!(y::AbstractMatrix,A::joAbstractOperator,x::AbstractMatrix)=jo_method_error(y,A,x,"mul!(mat,jo,mat) not implemented or type mismatch")

# ldiv!(...,jo,...)
ldiv!(y::AbstractVector,A::joAbstractOperator,x::AbstractVector)=jo_method_error(y,A,x,"ldiv!(vec,jo,vec) not implemented or type mismatch")
ldiv!(y::AbstractMatrix,A::joAbstractOperator,x::AbstractMatrix)=jo_method_error(y,A,x,"ldiv!(mat,jo,mat) not implemented or type mismatch")

