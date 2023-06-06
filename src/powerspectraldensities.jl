using FFTW

"""
    kolmogorov_psd(frequencies::AbstractVector{<:AbstractFloat},
                   Cn_squared::AbstractFloat)

Generates the 2D Kolmogorov power spectral density (PSD) with a given ``C_n^2`` value which determines the overall strength.
The PSD is evaluated on a grid defined by `frequencies`, which are assumed to be the angular spatial frequencies along one axis of the grid.
Specifically, they should be in units of radians/meter.
`Cn_squared` determines the overall normalization of the output PSD.
The Kolmogorov PSD is defined as:

``\\Phi_n\\left(\\vec{k}\\right) = 0.033 \\: C_n^2 \\: \\vec{k}^{-11/3}``

where ``\\vec{k} = 2\\pi\\left(f_x \\: \\hat{i} + f_y \\: \\hat{j}\\right)`` is the angular spatial frequency in radians/meter
"""
function kolmogorov_psd(frequencies::AbstractVector{<:AbstractFloat},
                        Cn_squared::AbstractFloat)
    psd = zeros((length(frequencies), length(frequencies)))
    for (i, fx) in enumerate(frequencies)
        for (j, fy) in enumerate(frequencies)
            f = sqrt(fx^2 + fy^2)
            psd[j,i] = 0.033 * Cn_squared * f^(-11/3) 
        end
    end
    psd[1,1] = 0.0
    return psd
end

"""
    kolmogorov_filter!(noise::Matrix{<:Complex},
                       pixelsize::AbstractFloat,
                       r0::AbstractFloat)

Filters a matrix of Gaussian Hermitian noise such that it now has a Kolmogorov power spectrum (specified by `r0`, which is the Fried parameter ``r_0``) rather than being white noise.
Edits the matrix `noise` in place, and needs the spatial size of one pixel (`pixelsize`) in units of meters.
`noise` is assumed to be in the standard 2D FFT ordering (e.g., `noise[1,1]` represents the 0th frequency/mean value of noise)
Assumes that `noise` is a square matrix.
"""
function kolmogorov_filter!(noise::Matrix{<:Complex},
                            pixelsize::AbstractFloat,
                            r0::AbstractFloat)
    N, M = size(noise)
    freqs = FFTW.fftfreq(N, 1/pixelsize)
    for i in 1:N
        for j in 1:M
            f2 = freqs[i]^2 + freqs[j]^2
            if (i == 1) & (j == 1)
                noise[j,i] = 0.0 + 0.0im
            else
                noise[j,i] = sqrt(0.023 * r0^(-5/3) * f2^(-11/6)) / pixelsize
            end
        end
    end
end

"""
    vonkarman_psd(frequencies::AbstractVector{<:AbstractFloat},
                  Cn_squared::AbstractFloat,
                  L0::AbstractFloat)

Generates the 2D von Karman power spectral density (PSD) with a given ``C_n^2`` value which determines the overall strength, and ``L_0`` which determines the distance at which power rolls off.
The PSD is evaluated on a grid defined by `frequencies`, which are assumed to be the angular spatial frequencies along one axis of the grid.
Specifically, they should be in units of radians/meter.
`Cn_squared` determines the overall normalization of the output PSD.
`L0` is the outer scale, which is, roughly speaking, the distance after which power no longer increases.
The von Karman PSD is defined as:

``\\Phi_n\\left(\\vec{k}\\right) = \\frac{0.033 \\: C_n^2}{\\left(\\vec{k} \\: + \\: k_0\\right)^{-11/3}} \\: ``

where ``\\vec{k} = 2\\pi\\left(f_x \\: \\hat{i} + f_y \\: \\hat{j}\\right)`` is the angular spatial frequency in radians/meter and ``k_0 = 2\\pi/L_0``
"""
# TODO: need to fix the types, something about AbstractVector isn't right, need to think about the units here too
# to determine the factors of 2pi and such, probably want to do frequencies which are cycles/meter instead of the radians/meter
function vonkarman_psd(frequencies,
                       Cn_squared,
                       L0)
    k0 = 2*π/L0
    psd = zeros((length(frequencies), length(frequencies)))
    for (i, fx) in enumerate(frequencies)
        for (j, fy) in enumerate(frequencies)
            f = sqrt(fx^2 + fy^2)
            psd[j,i] = 0.033 * Cn_squared / (f^2 + k0^2)^(11/6) 
        end
    end
    psd[1,1] = 0.0
    return psd
end

"""
    modified_vonkarman_psd(frequencies::AbstractVector{<:AbstractFloat},
                           Cn_squared::AbstractFloat,
                           L0::AbstractFloat,
                           l0::AbstractFloat)

Generates the 2D modified von Karman power spectral density (PSD) with a given ``C_n^2`` value which determines the overall strength, and ``L_0`` which determines the distance at which power rolls off at large distances, and ``l_0``, which determines the power roll off at small distances.
The PSD is evaluated on a grid defined by `frequencies`, which are assumed to be the angular spatial frequencies along one axis of the grid.
Specifically, they should be in units of radians/meter.
`Cn_squared` determines the overall normalization of the output PSD.
`L0` is the outer scale, which is, roughly speaking, the distance after which power no longer increases.
The von Karman PSD is defined as:

``\\Phi_n\\left(\\vec{k}\\right) = \\frac{0.033 \\: C_n^2 \\: e^{\\left(k^2/k_m^2\\right)}}{\\left(\\vec{k} \\: + \\: k_0\\right)^{-11/3}} \\: ``

where ``\\vec{k} = 2\\pi\\left(f_x \\: \\hat{i} + f_y \\: \\hat{j}\\right)`` is the angular spatial frequency in radians/meter, ``k_0 = 2\\pi/L_0``, and ``k_m = 5.92/l_0``
"""
function modified_vonkarman_psd(frequencies::AbstractVector{<:AbstractFloat},
                                Cn_squared::AbstractFloat,
                                L0::AbstractFloat,
                                l0::AbstractFloat)
    k0 = 2*π/L0
    km = 5.92/l0
    psd = zeros((length(frequencies), length(frequencies)))
    for (i, fx) in enumerate(frequencies)
        for (j, fy) in enumerate(frequencies)
            f = sqrt(fx^2 + fy^2)
            psd[j,i] = 0.033 * Cn_squared * exp(-f^2/km^2) / (f^2 + k0^2)^(11/6) 
        end
    end
    psd[1,1] = 0.0
    return psd
end