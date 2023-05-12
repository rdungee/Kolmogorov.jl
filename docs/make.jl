using Documenter
using AOAtmospheres

setup = quote
    using AOAtmospheres
    using Random
    Random.seed!(42)
end
DocMeta.setdocmeta!(AOAtmospheres, :DocTestSetup, setup; recursive = true)

include("pages.jl")
makedocs(
    modules = [AOAtmospheres],
    authors = "Ryan Dungee <ryan.dungee@utoronto.ca>",
    repo = "https://github.com/rdungee/AOAtmospheres.jl/blob/{commit}{path}#L{line}",
    sitename = "AOAtmospheres.jl",
    format = Documenter.HTML(;
        prettyurls = get(ENV, "CI", "false") == "true",
        canonical = "https://rdungee.github.io/AOAtmospheres.jl",
    ),
    pages=pages
)

deploydocs(
    repo = "github.com/rdungee/AOAtmospheres.jl",
    push_preview = true)