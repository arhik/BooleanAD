module BooleanAD

using ChainRulesCore
using Lazy
using MacroTools
using Random
using Lazy: @forward
import Base: &, |, !, ==
using Flux
using Flux: @adjoint
using Zygote

export DBool, majorityN, orN, andN, kjuntaN, weightedMajorityN


include("rules.jl")
include("voting.jl")
include("order.jl")
include("utility.jl")

# @warn "Experimental package BooleanAD"

end # module

# Why is this even a point here.



