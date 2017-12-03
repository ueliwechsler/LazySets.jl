include("convex_hull_algorithms.jl")

export ConvexHull, CH,
       convex_hull,
       convex_hull!

"""
    ConvexHull{S1<:LazySet, S2<:LazySet} <: LazySet

Type that represents the convex hull of the union of two convex sets.

### Fields

- `X` -- convex set
- `Y` -- convex set
"""
struct ConvexHull{S1<:LazySet, S2<:LazySet} <: LazySet
    X::S1
    Y::S2

    # default constructor with dimension check
    ConvexHull{S1,S2}(X::S1, Y::S2) where {S1<:LazySet, S2<:LazySet} =
        dim(X) != dim(Y) ? throw(DimensionMismatch) : new(X, Y)
end
# type-less convenience constructor
ConvexHull(X::S1, Y::S2) where {S1<:LazySet, S2<:LazySet} =
    ConvexHull{S1, S2}(X, Y)
# alias
CH = ConvexHull

"""
    dim(ch::ConvexHull)

Return the dimension of a convex hull of two convex sets.

### Input

- `ch` -- convex hull of two convex sets

### Output

The ambient dimension of the convex hull of two convex sets.
"""
function dim(ch::ConvexHull)
    return dim(ch.X)
end

"""
    σ(d::AbstractVector{<:Real}, ch::ConvexHull)::AbstractVector{<:Real}

Return the support vector of a convex hull of two convex sets in a given
direction.

### Input

- `d`  -- direction
- `ch` -- convex hull of two convex sets
"""
function σ(d::AbstractVector{<:Real}, ch::ConvexHull)::AbstractVector{<:Real}
    σ1 = σ(d, ch.X)
    σ2 = σ(d, ch.Y)
    ρ1 = dot(d, σ1)
    ρ2 = dot(d, σ2)
    return ρ1 >= ρ2 ? σ1 : σ2
end
