using Plots

function bounded_approximation(P::HPolyhedron{N}, emax, emin) where {N}
    A, a = tosimplehrep(P)
    n = LazySets.dim(P)
    B = [Matrix{N}(I,n,n); -Matrix{N}(I,n,n)]
    # b = [x_max, y_max; -x_min, -y_min]
    b = [emax...; -emin...]
    return HPolytope([A;B], [a;b])
end

function plot_extrem_points()
    # gives you the extrem point and not predefined limits
    p = plot!()
    xaxis = p[1][:xaxis]
    yaxis = p[1][:yaxis]
    emax = [xaxis[:extrema].emax; yaxis[:extrema].emax]
    emin = [xaxis[:extrema].emin; yaxis[:extrema].emin]
    if Inf ∈ [emax...; emin...]
        # rand(2) decrease the possibility of hitting a singular point
        emax = 10*ones(2) + rand(2)
        emin = -10*ones(2) + + rand(2)
    end
    return emax, emin
end

function plot_polyhedron!(P::HPolyhedron{N}; kwargs...) where {N}
    emax, emin = plot_extrem_points()
    # TODO: it could be that bounded_approximation returns a emptyset!!
    P_bounded = bounded_approximation(P, emax, emin)
    while isempty(P_bounded)
        # recompute P_bounded wiht new emax, emin
        center = [(emax[i]+emin[i])/2 for i=1:2]
        radius_high = emax - center
        radius_low = emin - center
        emax, emin = emax + radius_high, emin + radius_low
        P_bounded = bounded_approximation(P, emax, emin)
    end
    plot!(P_bounded; kwargs...)
end
