############################################################
## types supporting conversion from local to DA arrays #####
############################################################

############################################################
# joDA{distribute,gather} ##################################

export joDAdistribute, joDAgather

# type definition
"""
    joDAdistribute is DAarray toggle type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
struct joDAdistribute{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelToggleOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_out::joPAsetup  # output distributor
    gclean::Bool        # clean input vector post gathering
end
"""
    joDAgather is DAarray toggle type & constructor

    !!! Do not use it to create the operators
    !!! Use joMatrix and joLinearFunction constructors

"""
struct joDAgather{DDT<:Number,RDT<:Number,N} <: joAbstractDAparallelToggleOperator{DDT,RDT,N}
    name::String
    m::Integer
    n::Integer
    nvc::Integer
    fop::Function    # forward
    fop_T::Function  # transpose
    fop_A::Function  # adjoint
    fop_C::Function  # conj
    iop::Nullable{Function}
    iop_T::Nullable{Function}
    iop_A::Nullable{Function}
    iop_C::Nullable{Function}
    PAs_in::joPAsetup  # input distributor
    gclean::Bool       # clean input vector post gathering
end

