############################################################
# joKron ###################################################
############################################################

##################
## type definition

export joKron, joKronException

immutable joKron{DDT,RDT} <: joAbstractLinearOperator{DDT,RDT}
    name::String
    m::Integer
    n::Integer
    l::Integer
    ms::Vector{Integer}
    ns::Vector{Integer}
    flip::Bool
    fop::Vector{joAbstractLinearOperator}
    fop_T::Vector{joAbstractLinearOperator}
    fop_CT::Vector{joAbstractLinearOperator}
    fop_C::Vector{joAbstractLinearOperator}
    iop::Vector{joAbstractLinearOperator}
    iop_T::Vector{joAbstractLinearOperator}
    iop_CT::Vector{joAbstractLinearOperator}
    iop_C::Vector{joAbstractLinearOperator}
end

############################################################
## type exceptions

type joKronException <: Exception
    msg :: String
end

############################################################
## joLinearOperator - outer constructors

"""
    joKron(ops::joAbstractLinearOperator...)

Kronecker product

# Example
    a=rand(Complex{Float64},6,4);
    A=joMatrix(a;name="A")
    b=rand(Complex{Float64},6,8);
    B=joMatrix(b;DDT=Complex{Float32},RDT=Complex{Float64},name="B")
    c=rand(Complex{Float64},6,4);
    C=joMatrix(c;DDT=Complex{Float64},RDT=Complex{Float32},name="C")
    K=joKron(A,B,C)

# Notes
- the domain and range types of joKron are equal respectively to domain type of rightmost operator and range type of leftmost operator
- all operators in the chain have to have consistent passing domain/range types, i.e. domain type of operator on the left have to be the same as range type of operator on the right

"""
function joKron(ops::joAbstractLinearOperator...)
    isempty(ops) && throw(joKronException("empty argument list"))
    e=eltype(ops[1])
    m=1
    n=1
    l=length(ops)
    ms=Vector{Integer}(0)
    ns=Vector{Integer}(0)
    fops=Vector{joAbstractLinearOperator}(0)
    fops_T=Vector{joAbstractLinearOperator}(0)
    fops_CT=Vector{joAbstractLinearOperator}(0)
    fops_C=Vector{joAbstractLinearOperator}(0)
    iops=Vector{joAbstractLinearOperator}(0)
    iops_T=Vector{joAbstractLinearOperator}(0)
    iops_CT=Vector{joAbstractLinearOperator}(0)
    iops_C=Vector{joAbstractLinearOperator}(0)
    for i=1:l
        im1=max(i-1,1)
        reltype(ops[i])==deltype(ops[im1]) || throw(joKronException("domain/range mismatch for $i operator"))
        m*=ops[i].m
        push!(ms,ops[i].m)
        n*=ops[i].n
        push!(ns,ops[i].n)
        push!(fops,ops[i])
        push!(fops_T,ops[i].')
        push!(fops_CT,ops[i]')
        push!(fops_C,conj(ops[i]))
    end
    return joKron{deltype(fops[l]),reltype(fops[1])}("joKron($l)",m,n,l,ms,ns,false,
    fops,fops_T,fops_CT,fops_C,iops,iops_T,iops_CT,iops_C)
end

############################
## overloaded Base functions

# conj(jo)
conj{DDT,RDT}(A::joKron{DDT,RDT}) =
    joKron{DDT,RDT}("(conj("*A.name*"))",
        A.m,A.n,A.l,A.ms,A.ns,A.flip,
        A.fop_C,A.fop_CT,A.fop_T,A.fop,
        A.iop_C,A.iop_CT,A.iop_T,A.iop)

# transpose(jo)
transpose{DDT,RDT}(A::joKron{DDT,RDT}) =
    joKron{RDT,DDT}("("*A.name*".')",
        A.n,A.m,A.l,A.ns,A.ms,!A.flip,
        A.fop_T,A.fop,A.fop_C,A.fop_CT,
        A.iop_T,A.iop,A.iop_C,A.iop_CT)

# ctranspose(jo)
ctranspose{DDT,RDT}(A::joKron{DDT,RDT}) =
    joKron{RDT,DDT}("("*A.name*"')",
        A.n,A.m,A.l,A.ns,A.ms,!A.flip,
        A.fop_CT,A.fop_C,A.fop,A.fop_T,
        A.iop_CT,A.iop_C,A.iop,A.iop_T)

############################################################
## overloaded Base *(...jo...)

# *(jo,vec)
function *{ADDT,ARDT}(A::joKron{ADDT,ARDT},v::AbstractVector{ADDT})
    size(A,2) == size(v,1) || throw(joKronException("shape mismatch"))
    ksz=reverse(A.ns)
    V=reshape(v,ksz...)
    p=[x for x in 1:A.l]
    if A.flip
        p=circshift(p,1)
        for i=1:1:A.l
            ksz=circshift(ksz,1)
            V=permutedims(V,p)
            V=reshape(V,[ksz[1],prod(ksz[2:length(ksz)])]...)
            V=A.fop[i]*V
            ksz[1]=A.fop[i].m
            V=reshape(V,ksz...)
        end
    else
        p=circshift(p,-1)
        for i=A.l:-1:1
            V=reshape(V,[ksz[1],prod(ksz[2:length(ksz)])]...)
            V=A.fop[i]*V
            ksz[1]=A.fop[i].m
            V=reshape(V,ksz...)
            V=permutedims(V,p)
            ksz=circshift(ksz,-1)
        end
    end
    return vec(V)
end

# *(jo,mvec)
#function *{AEDT,mvDT:<Number}(A::joKron{AEDT},mv::AbstractMatrix{mvDT})
    #size(A, 2) == size(mv, 1) || throw(joKronException("shape mismatch"))
    #MV=zeros(promote_type(AEDT,eltype(mv)),size(A,1),size(mv,2))
    #for i=1:size(mv,2)
        #MV[:,i]=A*mv[:,i]
    #end
    #return MV
#end

