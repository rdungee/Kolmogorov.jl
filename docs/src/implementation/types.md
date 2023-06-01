# Types

This page is under construction, thank you for your patience.

Atmospheres are implemented as structs, the `Atmosphere` struct contains a vector of `AtmosphericLayer`s.
`AtmosphericLayer`s package together a phase screen with a few extra useful pieces of information that dictate how that screen evolves over time, its altitude above the telescope, and tracks how that screen has evolved thus far.

## Constructors

```@docs
Kolmogorov.AtmosphereicLayer
Kolmogorov.Atmosphere
```