############################################################
# joDict ##############################################
############################################################

export joDict, joDictException

struct joDictException <: Exception
    msg :: String
end

############################################################
## outer constructors

"""
Dictionary operator composed from different square JOLI operators

    joDict(ops::joAbstractLinearOperator...;
        weights::LocalVector,name::String)

# Example

    a=rand(ComplexF64,4,4);
    A=joMatrix(a;DDT=ComplexF32,RDT=ComplexF64,name="A")
    b=rand(ComplexF64,4,8);
    B=joMatrix(b;DDT=ComplexF32,RDT=ComplexF64,name="B")
    c=rand(ComplexF64,4,6);
    C=joMatrix(c;DDT=ComplexF32,RDT=ComplexF64,name="C")
    # either
        D=joDict(A,B,C) # basic dictionary in function syntax
    #or
        D=[A B C] # basic dictionary in [] syntax
    w=rand(ComplexF64,3)
    D=joDict(A,B,C;weights=w) # weighted dictionary

# Notes

- all operators must have the same # of rows (M)
- all given operators must have same domain/range types
- the domain/range types of joDict are equal to domain/range types of the given operators

"""
function joDict(ops::joAbstractLinearOperator...;
           weights::LocalVector{WDT}=zeros(0),name::String="joDict") where {WDT<:Number}
    isempty(ops) && throw(joDictException("empty argument list"))
    l=length(ops)
    for i=1:l
        ops[i].m==ops[1].m || throw(joDictException("size mismatch for $i operator"))
        deltype(ops[i])==deltype(ops[1]) || throw(joDictException("domain type mismatch for $i operator"))
        reltype(ops[i])==reltype(ops[1]) || throw(joDictException("range type mismatch for $i operator"))
    end
    (length(weights)==l || length(weights)==0) || throw(joDictException("lenght of weights vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    mo=zeros(Int,l)
    no=zeros(Int,l)
    for i=1:l
        ms[i]=ops[1].m
        ns[i]=ops[i].n
    end
    for i=2:l
        no[i]=no[i-1]+ns[i-1]
    end
    m=ops[1].m
    n=sum(ns)
    weighted=(length(ws)==l)
    fops=Vector{joAbstractLinearOperator}(undef,0)
    fops_T=Vector{joAbstractLinearOperator}(undef,0)
    fops_A=Vector{joAbstractLinearOperator}(undef,0)
    fops_C=Vector{joAbstractLinearOperator}(undef,0)
    for i=1:l
        if weighted
            push!(fops,ws[i]*ops[i])
            push!(fops_T,ws[i]*transpose(ops[i]))
            push!(fops_A,conj(ws[i])*adjoint(ops[i]))
            push!(fops_C,conj(ws[i])*conj(ops[i]))
        else
            push!(fops,ops[i])
            push!(fops_T,transpose(ops[i]))
            push!(fops_A,adjoint(ops[i]))
            push!(fops_C,conj(ops[i]))
        end
    end
    return joCoreBlock{deltype(fops[1]),reltype(fops[1])}(name*"($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_A,fops_C,@joNF,@joNF,@joNF,@joNF)
end
"""
Dictionary operator composed from l-times replicated square JOLI operator

    joDict(l::Int,op::joAbstractLinearOperator;
        weights::LocalVector,name::String)

# Example

    a=rand(ComplexF64,4,4);
    w=rand(ComplexF64,3)
    A=joMatrix(a;DDT=ComplexF32,RDT=ComplexF64,name="A")
    D=joDict(3,A) # basic dictionary
    D=joDict(3,A;weights=w) # weighted dictionary

# Notes

- all operators must have the same # of rows (M)
- all given operators must have same domain/range types
- the domain/range types of joDict are equal to domain/range types of the given operators

"""
function joDict(l::Integer,op::joAbstractLinearOperator;
           weights::LocalVector{WDT}=zeros(0),name::String="joDict") where {WDT<:Number}
    (length(weights)==l || length(weights)==0) || throw(joDictException("lenght of weights vector does not match number of operators"))
    ws=Base.deepcopy(weights)
    ms=zeros(Int,l)
    ns=zeros(Int,l)
    mo=zeros(Int,l)
    no=zeros(Int,l)
    for i=1:l
        ms[i]=op.m
        ns[i]=op.n
    end
    for i=2:l
        no[i]=no[i-1]+ns[i-1]
    end
    m=op.m
    n=l*op.n
    weighted=(length(weights)==l)
    fops=Vector{joAbstractLinearOperator}(undef,0)
    fops_T=Vector{joAbstractLinearOperator}(undef,0)
    fops_A=Vector{joAbstractLinearOperator}(undef,0)
    fops_C=Vector{joAbstractLinearOperator}(undef,0)
    for i=1:l
        if weighted
            push!(fops,ws[i]*op)
            push!(fops_T,ws[i]*transpose(op))
            push!(fops_A,conj(ws[i])*adjoint(op))
            push!(fops_C,conj(ws[i])*conj(op))
        else
            push!(fops,op)
            push!(fops_T,transpose(op))
            push!(fops_A,adjoint(op))
            push!(fops_C,conj(op))
        end
    end
    return joCoreBlock{deltype(op),reltype(op)}(name*"($l)",m,n,l,ms,ns,mo,no,ws,
                      fops,fops_T,fops_A,fops_C,@joNF,@joNF,@joNF,@joNF)
end

