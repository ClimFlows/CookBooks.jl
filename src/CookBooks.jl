module CookBooks

export CookBook

"""
    cookbook = CookBook([sym1=fun1, sym2=fun2, ...])

Returns a cookbook, optionnally containing an initial set of recipes.
Recipes are functions, identified by a symbol. Additional recipes can be added to the cookbook by:

    push!(cookbook ; fun1, fun2 = fun1->(...))
    cookbook.fun1 = fun1
    cookbook.fun2 = fun1->(...)

Function argument names matter in order to identify dependencies between recipes. Here evaluating `fun2`
requires evaluating `fun1` first, and passing the result of `fun1` to `fun2`.
Once the cookbook is complete, one opens at any time a fresh cooking session by:

    session = open(cookbook; data1=val1, data2=val2, ...)

In addition to data provided as above at session creation time, data can be added to an existing session by:

    session.sym = val

Data is fetched by:

    val = session.sym

Recipes from the coobook will be called if the required data is not already present in the session.
The session stores user-provided data and any additional data computed during its lifetime.
A given result is computed at most once per session.

The special argument name `all` represents the session itself. Therefore a function :

    function fun(all)
        (; data1, data2) = all
        ... # compute
        return something
    end

is given the whole session as sole input argument. `fun` can then fetch arbitrary results from the session. This
possibility is useful mostly if the inputs of the recipe are not always the same.

If a function has several methods with different argument names, it is called with the session as its sole argument.
Checking methods and argument names is done each time `fun` is called.
"""
struct CookBook
    recipes::Dict{Symbol,Any}
    CookBook(; kwargs...) = new(kwargs)
end

print_recipe(sym, value) = "$sym::$(typeof(value))"
function print_recipe(sym, def::Function)
    args = join(map(String, fun_arg_names(def)), ", ")
    mod = parentmodule(def)
    return "$mod.$def : ($args) -> $sym"
end

function Base.show(io::IO, book::CookBook)
    println(io, "┌ CookBooks.CookBook")
    for (key, recipe) in book.recipes
        println(io, "│    ", print_recipe(key, recipe))
    end
end

Base.setproperty!(book::CookBook, sym::Symbol, value) = (book.recipes[sym] = value)

#==================== Session =====================#

struct Session
    book::CookBook
    values::Dict{Symbol,Any}
    lock::ReentrantLock
    stack::Vector{Symbol}
    Session(recipes, values) = new(recipes, values, ReentrantLock(), Symbol[])
end
Base.open(book::CookBook; kwargs...) = Session(book, kwargs)
Base.close(::Session) = nothing

function Base.show(io::IO, session::Session)
    println(io)
    println(io, "┌ CookBooks.Session")
    for (key, def) in session.values
        println(io, "│    ", print_value(key, def))
    end
    println(io, session.book)
end
print_value(sym, value) = "$sym::$(typeof(value))"
print_value(sym, value::Number) = "$sym = $value"

function Base.setproperty!(session::Session, sym::Symbol, value)
    return lock(session.lock) do
        session.values[sym] = value
    end
end

function Base.getproperty(session::Session, prop::Symbol)
    if prop in fieldnames(Session)
        return getfield(session, prop)
    else
        return get(session, prop)
    end
end

struct DependsOn end

get(session::Session, syms::NTuple{N,Symbol}) where {N} =
    NamedTuple{syms}(map(sym -> get(session, sym), syms))

function get(session::Session, sym::Symbol)
    (; book, values) = session
    sym in keys(values) && return values[sym]
    return lock(session.lock) do
        fun = book.recipes[sym]
        fetch(session, sym, fun, fun)
    end
end

function fetch(session, sym, fun::F, ::F) where {F<:Function}
    return lock(session.lock) do
        pushfirst!(session.stack, sym)
        session.values[sym] = DependsOn()
        inputs = fun_arg_names(fun)
        value = fun(get(session, inputs)...)
        session.values[sym] = value
    end
end

function fun_arg_names(fun::F) where {F}
    args = (meth_arg_names(meth) for meth in methods(fun))
    return allequal(args) ? first(args) : (:all,)
end

function meth_arg_names(meth)
    _, args, _ = Base.arg_decl_parts(meth)
    return Tuple(Symbol(name) for (name, t) in args[2:end])
end

end # module