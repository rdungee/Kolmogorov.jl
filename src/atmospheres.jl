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
    windvector::Vector{<:AbstractFloat}
    phase::Matrix{Union{<:Complex,<:AbstractFloat}}
    center::Vector{<:AbstractFloat}
    AtmosphericLayer(pixsize, alt, wv, dims::Tuple{Integer, Integer}, center) = new(pixsize, alt, wv, zeros(Complex, dims...), center)
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

function Base.size(atm::Atmosphere)
    return size(atm.layers)
end

function Base.getindex(atm::Atmosphere, I::Vararg{Int,1})
    return atm.layers[I...]
end

function Base.setindex!(atm::Atmosphere, value, I::Vararg{Int,1})
    return atm.layers[I...] = values
end

function Base.length(atm::Atmosphere)
    return length(atm.layers)
end


"""
    KolmogorovAtmosphere(Cn2::AbstractFloat,
                         pixelsize::AbstractFloat,
                         screensize::AbstractFloat,
                         altitudes::Vector{AbstractFloat},
                         windvectors::Matrix{AbstractFloat},
                         layerstrengths::Vector{AbstractFloat},
                         phasetype::Symbol)
 
Constructs a full atmosphere where each atmospheric layer has a phase screen with a Kolmogorov power spectrum.

 - `Cn2` is the integrated ``C_n^2`` value of the atmosphere, which is internally converted to an ``r_0`` at 500 nanometers.
 - `pixelsize` is the size of one pixel in the screen, in meters, and `screensize` is the total size of the screen in meters.
 - `screensize` will be adjusted upwards to ensure an integer number of pixels if needed (so the returned screens will always be `screensize` or larger).
 - `altitudes` is the height in meters of each layer in the atmosphere, and the number of layers is taken as the length of this vector.
 - `layerstrengths` is the relative strength of each layer, they will be internally normalized, so a vector such as `[1, 4]` is a valid argument that will yield two layers where one is four times the strength of the other.
 - `phasetype` is a symbol that is `:real` or `:complex` that denotes how to store the phase in each layer (`:real` means the phase itself will be in the arrays, `:complex` means it will be the Fourier modes of the phase).

"""
function KolmogorovAtmosphere(Cn2::AbstractFloat,
                              pixelsize::AbstractFloat,
                              screensize::AbstractFloat, # Alternate version with integer number setting the number of pixels instead
                              altitudes::Vector{<:AbstractFloat},
                              windvectors::Matrix{<:AbstractFloat}, # Alternate version with speed and direction as a compass direction in degrees?
                              layerstrengths::Vector{<:AbstractFloat},
                              phasetype::Symbol)
    # First, a few setup steps, create the Atmosphere to populate with layers
    atmos = Atmosphere(Vector{AtmosphericLayer}(undef, nlayers))
    # And calculate/extract a few parameters
    nlayers = length(altitudes)
    npix = ceil(Int64, screensize/pixelsize)
    screensize = pixelsize * npix # Adjust the value of screensize to match what we had to round to
    r0 = Cn_squared_to_fried(Cn2)
    # Normalize layer strengths so they are fractions 1
    layerstrengths = layerstrengths ./ sum(layerstrengths)
    # Use the now normalized layer strengths to calculate each layers r0
    r0s = ((r0^(-5/3)) .* layerstrengths).^(-3/5)
    for layer in range(nlayers)
        Phase = generate_gaussian_hermitian_noise(npix) #TODO, need to figure out specifics of scaling this properly
        kolmogorov_filter!(Phase, pixelsize, r0s[layer])
        if phasetype == :complex
            al = AtmosphericLayer(pixelsize, altitudes[layer], windvectors[layer,:], Phase)
        elseif phasetype == :real
            phase = FFTW.bfft(Phase) .* (pixelsize)^2
            al = AtmosphericLayer(pixelsize, altitudes[layer], windvectors[layer,:], phase)
        else
            #error
        end
        atmos.layers[layer] = AtmosphericLayer()
    end
    return 
end