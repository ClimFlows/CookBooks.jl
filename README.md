# CookBooks

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://ClimFlows.github.io/CookBooks.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://ClimFlows.github.io/CookBooks.jl/dev/)
[![Build Status](https://github.com/ClimFlows/CookBooks.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/ClimFlows/CookBooks.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/ClimFlows/CookBooks.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/ClimFlows/CookBooks.jl)

CookBooks implements the type `CookBook` which gathers a set of named recipes to compute named results from base ingredients or other results. Then `session = open(cookbook ; ...)` opens a cooking session with fresh ingredients. Anything described in the cookbook can the be fetched as `session.[symbol]`. Intermediate steps leading from base ingrediants to the requested outcome are identified and executed, and intermediate results are stored so that they need not be computed twice.

The goal is to have a large catalog of ways to compute things that you may need.

## Installation

`CookBooks` is registered in the ClimFlows registry. [Follow instructions there](https://github.com/ClimFlows/JuliaRegistry), then:
```julia
] add CookBooks
```

## Example

```julia
using CookBooks: CookBook

cake(dough, topping) = dough+topping
dough(flour, sugar, eggs) = flour*sugar*eggs

book = CookBook(; cake, dough)
session = open(book; flour=1, sugar=2, eggs=3, topping=4)

@info session.cake # computes dough then cake
@info session.dough # does not re-compute dough
```
