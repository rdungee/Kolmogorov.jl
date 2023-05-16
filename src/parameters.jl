"""
    Cn_squared_to_fried(Cn_squared::AbstractFloat,
                        wavelength::AbstractFloat=500e-9)

Calculates the Fried parameter (``r_0``) from a provided ``C_n^2`` value and (optionally) wavelength in meters.
If no wavelength is provided, the value assumed is 500 nm.
The returned Fried parameter has units of meters.
"""
function Cn_squared_to_fried(Cn_squared::AbstractFloat,
                             wavelength::AbstractFloat = 500e-9)
    k = (2*π)/wavelength
    return (0.423 * Cn_squared * k^2)^(-3/5)
end

"""
    fried_to_Cn_squared(r0::AbstractFloat,
                        wavelength::AbstractFloat=500e-9)

Calculates the integrated ``C_n^2`` value that yields the provided Fried parameter (``r_0``).
If wavelength is not provided, the value assumed is 500 nm.
The returned ``C_n^2`` has units of ``\\mathrm{m}^{-2/3}``.
"""
function fried_to_Cn_squared(r0::AbstractFloat,
                             wavelength::AbstractFloat = 500e-9)
    k = (2*π)/wavelength
    return r0^(-5/3) / (0.423 * k^2)
end

"""
    fried_to_seeing(r0::AbstractFloat,
                    wavelength::AbstractFloat=500e-9)

Calculates the resulting seeing from a given Fried parameter (``r_0``) and (optionally) wavelength, both in meters.
If no wavelength is provided, the value assumed is 500 nm.
The returned seeing is in arcseconds.
"""
function fried_to_seeing(r0::AbstractFloat,
                         wavelength::AbstractFloat = 500e-9)
    return 206265 * (0.98 * wavelength) / r0
end

"""
    seeing_to_fried(seeing::AbstractFloat,
                    wavelength::AbstractFloat=500e-9)

Calculates the Fried parameter (``r_0``) that yields the provided seeing, seeing must be in arcseconds.
If no wavelength is provided, the value assumed is 500 nm.
The returned Fried parameter is in units of meters.
"""
function seeing_to_fried(seeing::AbstractFloat,
                         wavelength::AbstractFloat = 500e-9)
    return 0.98 * wavelength / (seeing / 206265)
end