using Test, Kolmogorov, Random

Random.seed!(42)

@testset "Parameter Conversions" begin
    include("testsets/parameters.jl")
end