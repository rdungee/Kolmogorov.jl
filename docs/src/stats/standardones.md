# Standard Atmospheric Statistics

Here we go through the standard set of atmosphere statistics which are commonly used in adaptive optics simulations.

## Hermitian Noise

The phase screens generated use the approach generating Gaussian Hermitian White Noise, which is then filtered to have a power spectrum matching a particular type.
At this point, the inverse FFT is applied to get the phase screen itself.
Gaussian Hermitian white noise is generated from the FFT of real white noise, as long as the filter applied to this data is strictly real then the hermitian nature will be preserved and the inverse FFT will still produce strictly real values.

```@docs
Kolmogorov.generate_gaussian_hermitian_noise
```

## Kolmogorov

This page is under construction, thank you for your patience.

```@docs
Kolmogorov.kolmogorov_psd
Kolmogorob.kolmogorov_filter!
```

## von Karman

```@docs
Kolmogorov.vonkarman_psd
```

## Modified von Karman

```@docs
Kolmogorov.modified_vonkarman_psd
```