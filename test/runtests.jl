using CookBooks: CookBook
using Test

@testset "CookBooks.jl" begin

    cake(dough, topping) = dough + topping
    dough(flour, sugar, eggs) = flour * sugar * eggs

    book = CookBook(; cake, dough)
    open(book; flour = 1, sugar = 2, eggs = 3, topping = 4) do session
        @info session.cake # computes dough
        @info session.dough # does not re-compute dough
        @info session
        @test true
    end
end
