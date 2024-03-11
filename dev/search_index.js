var documenterSearchIndex = {"docs":
[{"location":"","page":"Home","title":"Home","text":"CurrentModule = CookBooks","category":"page"},{"location":"#CookBooks","page":"Home","title":"CookBooks","text":"","category":"section"},{"location":"","page":"Home","title":"Home","text":"Documentation for CookBooks.","category":"page"},{"location":"","page":"Home","title":"Home","text":"","category":"page"},{"location":"","page":"Home","title":"Home","text":"Modules = [CookBooks]","category":"page"},{"location":"#CookBooks.CookBook","page":"Home","title":"CookBooks.CookBook","text":"cookbook = CookBook([sym1=fun1, sym2=fun2, ...])\n\nReturns a cookbook, optionnally containing an initial set of recipes. Recipes are functions, identified by a symbol. Additional recipes can be added to the cookbook by:\n\npush!(cookbook ; fun1, fun2 = fun1->(...))\ncookbook.fun1 = fun1\ncookbook.fun2 = fun1->(...)\n\nFunction argument names matter in order to identify dependencies between recipes. Here evaluating fun2 requires evaluating fun1 first, and passing the result of fun1 to fun2. Once the cookbook is complete, one opens at any time a fresh cooking session by:\n\nsession = open(cookbook; data1=val1, data2=val2, ...)\n\nIn addition to data provided as above at session creation time, data can be added to an existing session by:\n\nsession.sym = val\n\nData is fetched by:\n\nval = session.sym\n\nRecipes from the coobook will be called if the required data is not already present in the session. The session stores user-provided data and any additional data computed during its lifetime. A given result is computed at most once per session.\n\nThe special argument name all represents the session itself. Therefore a function :\n\nfunction fun(all)\n    (; data1, data2) = all\n    ... # compute\n    return something\nend\n\nis given the whole session as sole input argument. fun can then fetch arbitrary results from the session. This possibility is useful mostly if the inputs of the recipe are not always the same.\n\nIf a function has several methods with different argument names, it is called with the session as its sole argument. Checking methods and argument names is done each time fun is called.\n\n\n\n\n\n","category":"type"}]
}
