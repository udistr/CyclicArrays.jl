using Documenter
using CyclicArrays

makedocs(
    sitename = "CyclicArrays",
    format = Documenter.HTML(),
    modules=[CyclicArrays],
    repo="git@github.com:udistr/CyclicArrays.jl.git",
    authors="udistr <strobach.ehud@gmail.com>",
    pages = [
    "Home" => "index.md",
    "Main" => "main.md",
            ]
)

deploydocs( repo = "github.com:udistr/CyclicArrays.jl" )

