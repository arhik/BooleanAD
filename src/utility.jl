# Probability that 
dot(x::T, y::T) where {T<:BitArray} = x.&y
dot(x::T, y::T) where {T<:Bool} = x&y

dist(x::T, y::T) where {T<:Bool} = dot(x, y)

# TODO sum needs to customized
# TODO dot needs to be renamed to something else
# TODO dist should be probability that x != y given function outputs

dist(x::T, y::T) where {T<:BitArray} = sum(dot(x, y))/length(x)

bloss(x, y) = dist(x, y)