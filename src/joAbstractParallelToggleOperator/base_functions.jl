############################################################
## joDAdistribute/gather - overloaded Base functions

# eltype(jo)
eltype(A::joAbstractParallelToggleOperator{DDT,RDT}) where {DDT,RDT} = promote_type(DDT,RDT)

# deltype(jo)
deltype(A::joAbstractParallelToggleOperator{DDT,RDT}) where {DDT,RDT} = DDT

# reltype(jo)
reltype(A::joAbstractParallelToggleOperator{DDT,RDT}) where {DDT,RDT} = RDT

# show(jo)
show(A::joAbstractParallelToggleOperator) = println((typeof(A),A.name,(A.m,A.n)))

# display(jo)
display(A::joAbstractParallelToggleOperator) = show(A)
function display(d::joDAdistributor)
    println("joDAdistributor: ",d.name)
    println(" DataType: ",d.DT)
    println(" Dims    : ",d.dims)
    println(" Chunks  : ",d.chunks)
    println(" Workers : ",d.procs)
    for i=1:length(d.procs)
        @printf "  Worker/ranges: %3d " d.procs[i]
        println(d.idxs[i])
    end
end

# size(jo)
size(A::joAbstractParallelToggleOperator) = A.m,A.n

# size(jo,1/2)
function size(A::joAbstractParallelToggleOperator,ind::Integer)
    if ind==1
		return A.m
	elseif ind==2
		return A.n
	else
		throw(joAbstractParallelToggleOperatorException("invalid index"))
	end
end

# length(jo)
length(A::joAbstractParallelToggleOperator) = A.m*A.n

# jo_full(jo)

# norm(jo)

# real(jo)

# imag(jo)

# conj(jo)
@inline conj(A::joDAtoggle) = A

# transpose(jo)
function transpose(in::joDAdistributor)
    dims=reverse(in.dims)
    length(dims)==2 || throw(joDAdistributorException("joDAdistributor: transpose(joDAdistributor) makes sense only for 2D distributed arrays"))
    nlabs=length(in.procs)
    ddim=findfirst(i->i>1,in.chunks)
    ldim=findlast(i->i>1,in.chunks)
    ddim==ldim || throw(joDAdistributorException("joDAdistributor: cannot transpose and array with more then one distributed dimension"))
    parts=joDAdistributor_etc.balanced_partition(nlabs,dims[ddim])
    return joDAdistributor(dims,ddim,DT=in.DT,parts=parts,name="transpose($(in.name))")
end
transpose(A::joDAdistribute{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAgather{RDT,DDT,N}("regather($(A.name))",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst, A.gclean)
transpose(A::joDAgather{DDT,RDT,N}) where {DDT,RDT,N} =
    joDAdistribute{RDT,DDT,N}("redistribute($(A.name))",A.n,A.m,
        A.fop_T, A.fop, A.fop_C, A.fop_A,
        A.iop_T, A.iop, A.iop_C, A.iop_A,
        A.dst, A.gclean)

# adjoint(jo)
@inline adjoint(A::joDAtoggle) = transpose(A)

# isreal(jo)

# issymmetric(jo)

# ishermitian(jo)

# isequal(jo,jo)
function isequal(a::joDAdistributor,b::joDAdistributor)
    (a.name  ==b.name  ) || return false
    (a.dims  ==b.dims  ) || return false
    (a.procs ==b.procs ) || return false
    (a.chunks==b.chunks) || return false
    (a.idxs  ==b.idxs  ) || return false
    (a.cuts  ==b.cuts  ) || return false
    (a.DT    ==b.DT    ) || return false
    return true
end

# isapprox(jo,jo)
function isapprox(a::joDAdistributor,b::joDAdistributor)
    (a.dims  ==b.dims  ) || return false
    (a.procs ==b.procs ) || return false
    (a.chunks==b.chunks) || return false
    (a.idxs  ==b.idxs  ) || return false
    (a.cuts  ==b.cuts  ) || return false
    return true
end

############################################################
## overloaded Base *(...jo...)

# *(jo,jo)

# *(jo,mvec)
function *(A::joDAdistribute{ADDT,ARDT,2},mv::LocalMatrix{mvDT}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDAtoggleException("joDAdistributeMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.dst.dims==size(mv) || throw(joDAtoggleException("sjoDAdistributeMV: shape mismatch dst$(A.dst.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end
function *(A::joDAgather{ADDT,ARDT,2},mv::DArray{mvDT,2}) where {ADDT,ARDT,mvDT<:Number}
    A.n == size(mv,1) || throw(joDAtoggleException("joDAgatherMV: shape mismatch A$(size(A))*v$(size(mv))"))
    A.dst.dims==size(mv) || throw(joDAtoggleException("joDAgatherMV: shape mismatch dst$(A.dst.dims)*v$(size(mv))"))
    jo_check_type_match(ADDT,mvDT,join(["DDT for *(jo,mvec):",A.name,typeof(A),mvDT]," / "))
    MV = A.fop(mv)
    jo_check_type_match(ARDT,eltype(MV),join(["RDT from *(jo,mvec):",A.name,typeof(A),eltype(MV)]," / "))
    return MV
end

# *(mvec,jo)

# *(jo,vec)
function *(A::joDAdistribute{ADDT,ARDT,1},v::LocalVector{vDT}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joDAtoggleException("joDAdistributeV: shape mismatch A$(size(A))*v$(size(v))"))
    A.dst.dims==size(v) || throw(joDAtoggleException("joDAdistributeV: shape mismatch dst$(A.dst.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end
function *(A::joDAgather{ADDT,ARDT,1},v::DArray{vDT,1}) where {ADDT,ARDT,vDT<:Number}
    A.n == size(v,1) || throw(joDAtoggleException("joDAgatherV: shape mismatch A$(size(A))*v$(size(v))"))
    A.dst.dims==size(v) || throw(joDAtoggleException("joDAgatherV: shape mismatch dst$(A.dst.dims)*v$(size(v))"))
    jo_check_type_match(ADDT,vDT,join(["DDT for *(jo,vec):",A.name,typeof(A),vDT]," / "))
    V=A.fop(v)
    jo_check_type_match(ARDT,eltype(V),join(["RDT from *(jo,vec):",A.name,typeof(A),eltype(V)]," / "))
    return V
end

# *(vec,jo)

# *(num,jo)

# *(jo,num)

