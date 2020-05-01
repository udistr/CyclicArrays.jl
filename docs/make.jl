using Documenter
using CircularArrays

makedocs(
    sitename = "CircularArrays",
    format = Documenter.HTML(),
    modules=[CircularArrays],
    repo="git@github.com:udistr/CircularArrays.jl.git",
    authors="udistr <strobach.ehud@gmail.com>",
    pages = [
    "Home" => "index.md",
    "Main" => "main.md",
            ]
)

deploydocs( repo = "github.com:udistr/CircularArrays.jl" )

