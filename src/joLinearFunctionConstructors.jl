############################################################
# joLinearFunction - operator  constructors ################
############################################################

# FFT operators: joDFT
include("joLinearFunctionConstructors/joDFT.jl")

# DCT operators: joDCT
include("joLinearFunctionConstructors/joDCT.jl")

# NFFT operators: joNFFT
include("joLinearFunctionConstructors/joNFFT.jl")

# DWT operators: joDWT
include("joLinearFunctionConstructors/joDWT.jl")

# CurveLab operators: joCurvelet2D joCurvelet2DnoFFT
include("joLinearFunctionConstructors/joCurvelet2D.jl")
include("joLinearFunctionConstructors/joCurvelet2DnoFFT.jl")

# Restriction operator
include("joLinearFunctionConstructors/joRestriction.jl")

# Mask operator
include("joLinearFunctionConstructors/joMask.jl")

# Padding/extension operators: joExtend
include("joLinearFunctionConstructors/joExtend.jl")

# Permutation operator: joPermutation
include("joLinearFunctionConstructors/joPermutation.jl")

