# DBitArray is postponed after looking into internals. There is a chance of data race. 
# For now without concern for space complexity lets just use regular boolean value with 8-bit footprint
# We can optimize it once we know BitArrays can be used safely or with minimal work.
# Lets focus on accuracy first.
# 

mutable struct DBool
    bit::Bool
    DBool(b::Bool) = new(b)
end

mutable struct DBitArray
    bitarray::BitArray
    function DBitArray(count::Int)
        return new(bitrand(count))
    end
end

@forward DBitArray.bitarray Base.getindex, Base.setindex!

function set!(b::DBool, x::Bool)
    b.bit = x
    b
end

(b::DBool)(x::Bool) = set!(b, x)

Base.xor(a::DBool, b::DBool) = let x = Base.xor(a.bit, b.bit); DBool(x) end
and(a::DBool, b::DBool) = let x = Base.and_int(a.bit, b.bit); DBool(x) end
or(a::DBool, b::DBool) = let x = Base.or_int(a.bit, b.bit); DBool(x) end
not(a::DBool) = let x = Base.not_int(a.bit); DBool(x) end

(&)(a::DBool, b::DBool) = and(a, b)
(|)(a::DBool, b::DBool) = or(a, b)
(!)(a::DBool) = not(a::DBool)
(==)(a::DBool, b::DBool) = DBool(a.bit == b.bit)
(⊻)(a::DBool, b::DBool) = xor(a, b)
# Refer to bool.jl for other implementations

@adjoint DBool(b::Bool) = DBool(b), (b) -> (DBool(b), )

@adjoint xor(a::DBool, b::DBool) = xor(a, b), (∂) -> (∂, ∂) # TODO
@adjoint and(a::DBool, b::DBool) = and(a, b), (∂) -> (!xor(∂, b), !xor(∂, a))
@adjoint or(a::DBool, b::DBool) = or(a, b), (∂) -> (!xor(∂, b), !xor(∂, a)) # TODO
@adjoint not(a::DBool) = not(a), (∂) -> (∂,)

# @adjoint (&)(a::DBool, b::DBool) = and(a, b), (∂) -> (xor(∂, b), xor(∂, a))
# @adjoint (|)(a::DBool, b::DBool) = or(a, b), (∂) -> (!xor(∂, b), !xor(∂, a))
# @adjoint (!)(a::DBool) = not(a), (∂) -> (∂ == a,)

⨁(a::DBool, b::DBool) = !xor(a, b) # U2A01-3 Remember

# TODO sessions are important here for others to work in this space

# Array versions
# Broadcasts works out of box
# Adjoints need to supported.

 
Base.xor(a::Array{DBool}, b::Array{DBool}) = xor.(a, b)
and(a::Array{DBool}, b::Array{DBool}) = and.(a, b)
or(a::Array{DBool}, b::Array{DBool}) = or.(a, b)
not(a::Array{DBool}) = not.(a)

(&)(a::Array{DBool}, b::Array{DBool}) = and(a, b)
(|)(a::Array{DBool}, b::Array{DBool}) = or(a, b)
(==)(a::Array{DBool}, b::Array{DBool}) = a .== b
(⊻)(a::Array{DBool}, b::Array{DBool}) = xor(a, b)

import Base: broadcasted

(!)(a::Array{DBool}) = not.(a)

@adjoint broadcasted(::typeof(xor), x::Array{DBool}, y::Array{DBool}) = xor.(x, y), Δ -> (nothing, Δ, Δ)
@adjoint broadcasted(::typeof(and), x::Array{DBool}, y::Array{DBool}) = and.(a, b), (∂) -> (nothing, !xor.(∂, b), !xor.(∂, a))
@adjoint broadcasted(::typeof(or), x::Array{DBool}, y::Array{DBool}) = or.(a, b), (∂) -> (nothing, !xor.(∂, b), !xor.(∂, a))
@adjoint broadcasted(::typeof(not), x::Array{DBool}) = not.(a), (∂) -> (nothing, ∂)
@adjoint broadcasted(::typeof(⨁), x::Array{DBool}, y::Array{DBool}) = xor.(x, y), Δ -> (nothing, !Δ, !Δ)

# Not sure if this broadcasted version
# @adjoint DBool(b::Bool) = DBool(b), (b) -> (DBool(b), )

# @adjoint (&)(a::DBool, b::DBool) = and(a, b), (∂) -> (xor(∂, b), xor(∂, a))
# @adjoint (|)(a::DBool, b::DBool) = or(a, b), (∂) -> (!xor(∂, b), !xor(∂, a))
# @adjoint (!)(a::DBool) = not(a), (∂) -> (∂ == a,)

lossF(x, y) = sum(xor(x, y))





