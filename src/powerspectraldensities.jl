"""
    kolmogorov_psd(frequencies::AbstractVector{AbstractFloat},
                   Cn_squared::AbstractFloat)

Generates the 2D Kolmogorov power spectral density (PSD) with a given ``C_n^2`` value which determines the overall strength.
The PSD is evaluated on a grid defined by `frequencies`, which are assumed to be the angular spatial frequencies along one axis of the grid.
Specifically, they should be in units of radians/meter.
`Cn_squared` determines the overall normalization of the output PSD.
The Kolmogorov PSD is defined as:

``\\Phi_n\\left(\\vec{k}\\right) = 0.033 \\: C_n^2 \\: \\vec{k}^{-11/3}``

where ``\\vec{k} = 2\\pi\\left(f_x \\: \\hat{i} + f_y \\: \\hat{j}\\right)`` is the angular spatial frequency in radians/meter
"""
function kolmogorov_psd(frequencies::AbstractVector{AbstractFloat},
                        Cn_squared::AbstractFloat)
    psd = zeros((length(frequencies), length(frequencies)))
    for fx in frequencies
        for fy in frequencies
            f = sqrt(fx^2 + fy^2)
            psd = 0.033 * Cn_squared * f^(-11/3) 
        end
    end
end

"""
    vonkarman_psd(frequencies::AbstractVector{AbstractFloat},
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
function vonkarman_psd(frequencies::AbstractVector{AbstractFloat},
                       Cn_squared::AbstractFloat,
                       L0::AbstractFloat)
    k0 = 2*π/L0
    psd = zeros((length(frequencies), length(frequencies)))
    for fx in frequencies
        for fy in frequencies
            f = sqrt(fx^2 + fy^2)
            psd = 0.033 * Cn_squared / (f^2 + k0^2) ^(-11/6) 
        end
    end
end

"""
    modified_vonkarman_psd(frequencies::AbstractVector{AbstractFloat},
                            Cn_squared::AbstractFloat,
                            L0::AbstractFloat,
                            l0::AbstractFloat)

Generates the 2D modified von Karman power spectral density (PSD) with a given ``C_n^2`` value which determines the overall strength, and ``L_0`` which determines the distance at which power rolls off at large distances, and ``l_0``, which determines the power roll off at small distances.
The PSD is evaluated on a grid defined by `frequencies`, which are assumed to be the angular spatial frequencies along one axis of the grid.
Specifically, they should be in units of radians/meter.
`Cn_squared` determines the overall normalization of the output PSD.
`L0` is the outer scale, which is, roughly speaking, the distance after which power no longer increases.
The von Karman PSD is defined as:

``\\Phi_n\\left(\\vec{k}\\right) = \\frac{0.033 \\: C_n^2 \\: e^{k^2/k_m^2}}{\\left(\\vec{k} \\: + \\: k_0\\right)^{-11/3}} \\: ``

where ``\\vec{k} = 2\\pi\\left(f_x \\: \\hat{i} + f_y \\: \\hat{j}\\right)`` is the angular spatial frequency in radians/meter, ``k_0 = 2\\pi/L_0``, and ``k_m = 5.92/l_0``
"""
function modified_vonkarman_psd(frequencies::AbstractVector{AbstractFloat},
                                Cn_squared::AbstractFloat,
                                L0::AbstractFloat,
                                l0::AbstractFloat)
    k0 = 2*π/L0
    km = 5.92/l0
    psd = zeros((length(frequencies), length(frequencies)))
    for fx in frequencies
        for fy in frequencies
            f = sqrt(fx^2 + fy^2)
            psd = 0.033 * Cn_squared * exp(-f^2/km^2) / (f^2 + k0^2) ^(-11/6) 
        end
    end
end