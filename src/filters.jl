"""
    kolmogorovfilter(frequencies::AbstractVector{AbstractFloat},
                     Cn_squared::AbstractFloat,
                     deltafreq::AbstractFloat)

A filter for generating a Kolmogorov turbulence phase screen.
Uses the idea of Johansson and Gavel (1994), which is to create a "Gaussian white noise process" and apply a filter that shapes the noise to have a particular structure function.
After this shaping the inverse FFT produces a matrix which contains the turbulent phase screen with the proper statistics, in this case Kolmogorov.
Specifically, the output of the inverse FFT will be a random field which has the following spatial power spectral density:

``\\Phi_n\\left(\\vec{k}\\right) = 0.033 \\: C_n^2 \\: \\vec{k}^{-11/3}``

where ``\\vec{k} = 2\\pi\\left(f_x \\: \\hat{i} + f_y \\: \\hat{j}\\right)`` is the angular spatial frequency in radians/meter
"""
function kolmogorovfilter(frequencies::AbstractVector{AbstractFloat},
                          Cn_squared::AbstractFloat,
                          deltafreq::AbstractFloat)
    return
end