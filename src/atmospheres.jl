"""
    AtmosphericLayer(pixelsize, altitude, windvector, dims)
    AtmosphericLayer(pixelsize, altitude, windvector, phase)
    AtmosphericLayer(pixelsize, altitude, windvector, phase, center)

A single layer in the atmosphere, represented as an infinitely thin phase screen.
Light that is propagated through the layer will acquire the phase delay accordingly.
`AtmosphericLayer.phase` can be a matrix of real or complex numbers.
If real, these numbers are interpreted as the phase itself, if complex they are interpreted as the Fourier transform of the phase, and thus will be inverse Fourier transformed before the wave is propagated through.

 - `pixelsize` is the physical size of a pixel in the layer's phase screen, note this assumes a square, regular grid
 - `altitude` is the height of the layer in meters, only critical if doing Fresnel propagation
 - `windvector` is the [East, North] components of the wind velocity of this layer, in meters/second. 
 - `phase` is optional, but if passed is a `Matrix` that must contain either `Complex` or `AbstractFloat`
 - `dims` is the alternative to `phase`, should be a tuple specifiying the size of a Phase array to initialize
 - `center` is the location of the center of the layer that tracks how the screen has evolved, is [East, North] location of screen in meters.
"""
struct AtmosphericLayer
    pixelsize::AbstractFloat
    altitude::AbstractFloat
    windvector::Vector{AbstractFloat}
    phase::Matrix{Union{Complex,AbstractFloat}}
    center::Vector{AbstractFloat}
    AtmosphericLayer(pixsize, alt, wv, dims::Tuple{Integer, Integer}) = new(pixsize, alt, wv, zeros(Complex, dims...), [0.0, 0.0])
    AtmosphericLayer(pixsize, alt, wv, arr) = new(pixsize, alt, wv, arr, [0.0, 0.0])
end

"""
    Atmosphere

The `Atmosphere` type which is a type that simply packs together any number of atmospheric layers.
Operations which evolve the atmosphere will loop over all the layers within a given atmosphere.
"""
struct Atmosphere
    layers::Vector{AtmosphericLayer}
end