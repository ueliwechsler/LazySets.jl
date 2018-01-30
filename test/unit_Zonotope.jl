for N in [Float64, Rational{Int}, Float32]
    # 1D Zonotope
    z = Zonotope(N[0.], eye(N, 1))
    # Test Dimension
    @test dim(z) == 1
    # Test Support Vector
    d = N[1.]
    @test σ(d, z) == N[1.]
    d = N[-1.]
    @test σ(d, z) == N[-1.]

    # 2D Zonotope
    z = Zonotope(N[0., 0.], N(1.) * eye(N, 2))
    # Test Dimension
    @test dim(z) == 2
    # Test Support Vector
    d = N[1., 0.]
    @test σ(d, z) == N[1., 1.] || N[1., -1]
    d = N[-1., 0.]
    @test σ(d, z) == N[-1., 1.] || N[-1., -1]
    d = N[0., 1.]
    @test σ(d, z) == N[1., 1.] || N[-1., 1]
    d = N[0., -1.]
    @test σ(d, z) == N[1., -1.] || N[-1., -1]

    # 2D Zonotope not 0-centered
    z = Zonotope(N[1., 2.], N(1.) * eye(N, 2))
    # Test Dimension
    @test dim(z) == 2
    # Test Support Vector
    d = N[1., 0.]
    @test σ(d, z) == N[2., 3]
    d = N[-1., 0.]
    @test σ(d, z) == N[0., 3]
    d = N[0., 1.]
    @test σ(d, z) == N[2., 3]
    d = N[0., -1.]
    @test σ(d, z) == N[2., 1.]

    # an_element function
    @test an_element(z) ∈ z

    # concrete operations
    Z1 = Zonotope(N[1, 1.], N[1 1; -1 1.])
    Z2 = Zonotope(N[-1, 1.], eye(N, 2))
    A = N[0.5 1; 1 0.5]

    # concrete Minkowski sum
    Z3 = minkowski_sum(Z1, Z2)
    @test Z3.center == N[0, 2.]
    @test Z3.generators == N[1 1 1 0; -1 1 0 1.]

    # concrete linear map and scale
    Z4 = linear_map(A, Z3)
    @test Z4.center == N[2, 1.]
    @test Z4.generators == N[-0.5 1.5 0.5 1.0; 0.5 1.5 1.0 0.5]
    Z5 = scale(0.5, Z3)
    @test Z5.center == N[0, 1.]
    @test Z5.generators == N[0.5 0.5 0.5 0.0; -0.5 0.5 0.0 0.5]

    # intersection with a hyperplane
    H1 = Hyperplane(N[1., 1.], N(3.))
    #intersection_empty, point = is_intersection_empty(Z1, H1, true)
    @test !is_intersection_empty(Z1, H1) #&& !intersection_empty &&
          #point ∈ Z1 && point ∈ H1
    H2 = Hyperplane(N[1., 1.], N(-11.))
    @test is_intersection_empty(Z1, H2) && is_intersection_empty(Z1, H2, true)[1]
end
