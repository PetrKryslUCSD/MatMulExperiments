module MatMulExperiments

using LoopVectorization
using LinearAlgebra

include("default.jl")  
include("plain.jl")  
include("wavx.jl")  
include("winbounds.jl")   

end # module
