using Documenter
using Kolmogorov

setup = quote
    using Kolmogorov
    using Random
    Random.seed!(42)
end
DocMeta.setdocmeta!(Kolmogorov, :DocTestSetup, setup; recursive = true)

include("pages.jl")
makedocs(
    modules = [Kolmogorov],
    authors = "Ryan Dungee <ryan.dungee@utoronto.ca>",
    repo = "https://github.com/rdungee/Kolmogorov.jl/blob/{commit}{path}#L{line}",
    sitename = "Kolmogorov.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://rdungee.github.io/Kolmogorov.jl",
    ),
    pages=pages
)

deploydocs(
    repo = "github.com/rdungee/Kolmogorov.jl",
    push_preview = true)