using Kolmogorov: fried_to_Cn_squared,
                  Cn_squared_to_fried,
                  fried_to_seeing,
                  seeing_to_fried

@testset "Parameter Conversions" begin
    # Values taken from Keck Adaptive Optics Note #303: Atmospheric Parameters for Mauna Kea, Table 1
    cn2 = 1.57e-13
    r0 = 0.2441204491
    seeing = 0.4140163201 # My own conversion since they don't include this
    @test isapprox(fried_to_Cn_squared(r0), cn2, atol=1e-6)
    @test isapprox(Cn_squared_to_fried(cn2), r0, atol=1e-6)
    @test isapprox(fried_to_seeing(r0), seeing, atol=1e-6)
    @test isapprox(seeing_to_fried(seeing), r0, atol=1e-6)
end