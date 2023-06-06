using Random
using FFTW

"""
    generate_gaussian_hermitian_noise(N::int)

Generates Gaussian hermitian white noise, specifically noise that when you take the inverse FFT the output is strictly real (aside from the imprecision of FFTs).
Note that this means it is not a hermitian matrix, because the FFT indexing is different.
Returned matrix is `NxN` and populated with complex numbers.
"""
function generate_gaussian_hermitian_noise(N::Int)
    whitenoise = randn(N, N) * sqrt(2) / N
    return FFTW.fft(whitenoise)
end