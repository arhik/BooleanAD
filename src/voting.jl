# These define majority voting functions;
# Majority voting function theory

cumulative_sum(x::DBool, y::Array{DBool}) = 
    length(y) > 2 ? x.bit + cumulative_sum(y) : x.bit + y[1].bit 
cumulative_sum(x::Array{DBool}) = cumulative_sum(x[1], x[2:end])

majorityN(x::Array{DBool}) = let y = floor(0.5 + (cumulative_sum(x) - 0.5)/length(x));  
    @assert  y in [0.0, 1.0] 
    return DBool(y == 1.0)
end

#=
And Voting procedure
=#

andN(x::Array{DBool}) = DBool(all([i.bit for i in x]))

#=
Or Voting procedure
=#

orN(x::Array{DBool}) = DBool(any([i.bit for i in x]))

#=
Dictator voting procedure
=#

dictatorN(x::Array{DBool}; idx=1) = x[idx]

#=
K-junta voting procedure
=#
# TODO Union statement is not typechecking

kjuntaN(x::Array{DBool}; k =10, voting=Union{andN, orN, majorityN}, kidxs=nothing) = begin(x)
    if kidxs == nothing
        kidxs = CartesianIndices(1:k)
    end
    voting(x[kidxs])
end

# TODO small utility function needs to be moved to utility.jl
*(a::DBool, b::Number) = a.bit * true

#=
Weighted Majority or linear thresholding function
=#

weightedMajorityN(x::Array{DBool}, weights; bias=0.0, threshold=0.5) = bias + sum( weights.*[i.bit for i in x]) > threshold

