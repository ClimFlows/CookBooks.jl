using CookBooks
using Documenter

DocMeta.setdocmeta!(CookBooks, :DocTestSetup, :(using CookBooks); recursive=true)

makedocs(;
    modules=[CookBooks],
    authors="The ClimFlows contributors",
    sitename="CookBooks.jl",
    format=Documenter.HTML(;
        canonical="https://ClimFlows.github.io/CookBooks.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/ClimFlows/CookBooks.jl",
    devbranch="main",
)
