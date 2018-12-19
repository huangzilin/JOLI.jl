# FFT operators: joDFT

## helper module
module joDFT_etc
    using JOLI: jo_convert
    using FFTW
    ### planned
    function apply_fft_centered(pln::FFTW.cFFTWPlan,v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=(pln*rv)/sqrt(mp)
        rv=fftshift(rv)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft_centered(pln::AbstractFFTs.ScaledPlan,v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=ifftshift(rv)
        rv=(pln*rv)*sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_fft(pln::FFTW.cFFTWPlan,v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=(pln*rv)/sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft(pln::AbstractFFTs.ScaledPlan,v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=(pln*rv)*sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    ### not planned
    function apply_fft_centered(v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=fft(rv)/sqrt(mp)
        rv=fftshift(rv)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft_centered(v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=ifftshift(rv)
        rv=ifft(rv)*sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_fft(v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=fft(rv)/sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
    function apply_ifft(v::Vector{vdt},ms::Tuple,rdt::DataType) where vdt<:Union{AbstractFloat,Complex}
        mp::Integer=prod(ms)
        rv=reshape(v,ms)
        rv=ifft(rv)*sqrt(mp)
        rv=vec(rv)
        rv=jo_convert(rdt,rv,false)
        return rv
    end
end
using .joDFT_etc

# constructors
export joDFT
"""
Multi-dimensional FFT transform over fast dimension(s)

    joDFT(m[,n[, ...]]
            [;planned=true,centered=false,DDT=joFloat,RDT=(DDT:<Real?Complex{DDT}:DDT)])

# Examples

- joDFT(m) - 1D FFT
- joDFT(m; centered=true) - 1D FFT with centered coefficients
- joDFT(m; planned=false) - 1D FFT without the precomputed plan
- joDFT(m,n) - 2D FFT
- joDFT(m; DDT=Float32) - 1D FFT for 32-bit input
- joDFT(m; DDT=Float32,RDT=ComplexF64) - 1D FFT for 32-bit input and 64-bit output

# Notes

- if DDT:<Real then imaginary part will be neglected for transpose/adjoint
- if you intend to use joDFT in remote* calls, you have to either set planned=false or create the operator on the worker

"""
function joDFT(ms::Integer...;planned::Bool=true,centered::Bool=false,DDT::DataType=joFloat,RDT::DataType=(DDT<:Real ? Complex{DDT} : DDT))
    if planned
        pf=plan_fft(zeros(ms))
        ipf=plan_ifft(zeros(ms))
        if centered
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft_centered(pf,v1,ms,RDT),
                v2->joDFT_etc.apply_ifft_centered(ipf,v2,ms,DDT),
                v3->joDFT_etc.apply_ifft_centered(ipf,v3,ms,DDT),
                v4->joDFT_etc.apply_fft_centered(pf,v4,ms,RDT),
                DDT,RDT;
                name="joDFTpc"
                )
        else
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft(pf,v1,ms,RDT),
                v2->joDFT_etc.apply_ifft(ipf,v2,ms,DDT),
                v3->joDFT_etc.apply_ifft(ipf,v3,ms,DDT),
                v4->joDFT_etc.apply_fft(pf,v4,ms,RDT),
                DDT,RDT;
                name="joDFTp"
                )
        end
    else
        if centered
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft_centered(v1,ms,RDT),
                v2->joDFT_etc.apply_ifft_centered(v2,ms,DDT),
                v3->joDFT_etc.apply_ifft_centered(v3,ms,DDT),
                v4->joDFT_etc.apply_fft_centered(v4,ms,RDT),
                DDT,RDT;
                name="joDFTc"
                )
        else
            return joLinearFunction_A(prod(ms),prod(ms),
                v1->joDFT_etc.apply_fft(v1,ms,RDT),
                v2->joDFT_etc.apply_ifft(v2,ms,DDT),
                v3->joDFT_etc.apply_ifft(v3,ms,DDT),
                v4->joDFT_etc.apply_fft(v4,ms,RDT),
                DDT,RDT;
                name="joDFT"
                )
        end
    end
end

