############################################################
# joKron ###################################################
############################################################

############################################################
## outer constructors

"""
    joKron(ops::joAbstractLinearOperator...)

Kronecker product

# Example
    a=rand(ComplexF64,6,4);
    A=joMatrix(a;name="A")
    b=rand(ComplexF64,6,8);
    B=joMatrix(b;DDT=ComplexF32,RDT=ComplexF64,name="B")
    c=rand(ComplexF64,6,4);
    C=joMatrix(c;DDT=ComplexF64,RDT=ComplexF32,name="C")
    K=joKron(A,B,C)

# Notes
- the domain and range types of joKron are equal respectively to domain type of rightmost operator and range type of leftmost operator
- all operators in the chain must have consistent passing domain/range types, i.e. domain type of operator on the left have to be the same as range type of operator on the right

"""
function joKron(ops::joAbstractLinearOperator...)
    isempty(ops) && throw(joKronException("empty argument list"))
    l=length(ops)
    for i=2:l
        reltype(ops[i])==deltype(ops[i-1]) || throw(joKronException("domain/range type mismatch for $i operator"))
    end
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    fops=Vector{joAbstractLinearOperator}(undef,0)
    fops_T=Vector{joAbstractLinearOperator}(undef,0)
    fops_A=Vector{joAbstractLinearOperator}(undef,0)
    fops_C=Vector{joAbstractLinearOperator}(undef,0)
    for i=1:l
        ms[i]=ops[i].m
        ns[i]=ops[i].n
    end
    m=prod(ms)
    n=prod(ns)
    for i=1:l
        push!(fops,ops[i])
        push!(fops_T,transpose(ops[i]))
        push!(fops_A,adjoint(ops[i]))
        push!(fops_C,conj(ops[i]))
    end
    return joKron{deltype(fops[l]),reltype(fops[1])}("joKron($l)",m,n,l,ms,ns,false,
                 fops,fops_T,fops_A,fops_C,@joNF,@joNF,@joNF,@joNF)
end

############################
## overloaded Base functions

# display(jo)
function display(A::joKron)
    println("# joKron")
    println("-     name: ",A.name)
    println("-     type: ",typeof(A))
    println("-     size: ",size(A))
    println("- # of ops: ",A.l)
    println("-  m-sizes: ",A.ms)
    println("-  n-sizes: ",A.ns)
    println("-  flipped: ",A.flip)
    for i=1:A.l
    println("*     op $i: ",(A.fop[i].name,typeof(A.fop[i]),A.fop[i].m,A.fop[i].n))
    end
end

# conj(jo)
conj(A::joKron{DDT,RDT}) where {DDT,RDT} =
    joKron{DDT,RDT}("(conj("*A.name*"))",
        A.m,A.n,A.l,A.ms,A.ns,A.flip,
        A.fop_C,A.fop_A,A.fop_T,A.fop,
        A.iop_C,A.iop_A,A.iop_T,A.iop)

# transpose(jo)
transpose(A::joKron{DDT,RDT}) where {DDT,RDT} =
    joKron{RDT,DDT}("(transpose("*A.name*"))",
        A.n,A.m,A.l,A.ns,A.ms,!A.flip,
        A.fop_T,A.fop,A.fop_C,A.fop_A,
        A.iop_T,A.iop,A.iop_C,A.iop_A)

# adjoint(jo)
adjoint(A::joKron{DDT,RDT}) where {DDT,RDT} =
    joKron{RDT,DDT}("(adjoint("*A.name*"))",
        A.n,A.m,A.l,A.ns,A.ms,!A.flip,
        A.fop_A,A.fop_C,A.fop,A.fop_T,
        A.iop_A,A.iop_C,A.iop,A.iop_T)

# *(jo,vec)
function *(A::joKron{ADDT,ARDT},v::LocalVector{ADDT}) where {ADDT,ARDT}
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
function *(A::joKron{ADDT,ARDT},mv::LocalMatrix{ADDT}) where {ADDT,ARDT}
    size(A, 2) == size(mv, 1) || throw(joKronException("shape mismatch"))
    MV=Matrix{ARDT}(undef,A.m,size(mv,2))
    for i=1:size(mv,2)
        MV[:,i]=A*mv[:,i]
    end
    return MV
end

# -(jo)
function -(A::joKron{DDT,RDT}) where {DDT,RDT}
    fops=Vector{joAbstractLinearOperator}(undef,0)
    fops_T=Vector{joAbstractLinearOperator}(undef,0)
    fops_A=Vector{joAbstractLinearOperator}(undef,0)
    fops_C=Vector{joAbstractLinearOperator}(undef,0)
    for i=1:A.l
        push!(fops,-A.fop[i])
        push!(fops_T,-A.fop_T[i])
        push!(fops_A,-A.fop_A[i])
        push!(fops_C,-A.fop_C[i])
    end
    return joKron{DDT,RDT}("(-"*A.name*")",
        A.m,A.n,A.l,A.ms,A.ns,A.flip,
        fops,fops_T,fops_A,fops_C,
        A.iop,A.iop_T,A.iop_A,A.iop_C)
end

