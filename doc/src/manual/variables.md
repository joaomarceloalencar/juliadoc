# [Variáveis](@id man-variables)

Uma variável, em Julia, é um nome associado (ou ligado) a um valor. É util quando você deseja armazenar uma valor (que você obteve após algum cálculo, por exemplo) para uso posterior. Por exemplo:

```julia-repl
# Atribua o valor 10 para a variável x
julia> x = 10
10

# Fazendo cálculos com o valor de x
julia> x + 1
11

# Reatribuindo valor de x
julia> x = 1 + 1
2

# Você pode atribuir valores de outros tipos, como cadeias de caracteres
julia> x = "Olá Mundo!"
"Olá Mundo!"
```

Julia fornece um sistema extremamente flexível para nomear variáveis. Nomes de variáveis diferencia maiúsculas de minúsculas e não tem significado semântico (isto é, a linguagem não trata variáveis de forma diferente baseada no seus nomes).

```jldoctest
julia> x = 1.0
1.0

julia> y = -3
-3

julia> Z = "Minha string"
"My string"

julia> frase_comum = "Olá Mundo!"
"Olá Mundo!"

julia> DeclaraçãoUniversalDosDireitosHumanos = "人人生而自由，在尊严和权利上一律平等。"
"人人生而自由，在尊严和权利上一律平等。"
```

Nomes UNICODE (em codificação UTF-8) são permitidos:

```jldoctest
julia> δ = 0.00001
1.0e-5

julia> 안녕하세요 = "Olá"
"Olá"
```

No terminal Julia (REPL) e em vários outros ambientes de edição Julia, você pode digitar vários símbolos matemáticos do UNICODE usando o nome do símbolo em LaTeX precedido por uma barra invertida e seguido por uma _tab_. Por exemplo, a variável `δ` pode ser inseridade digitando `\delta`-*tab*, ou até mesmo `α̂⁽²⁾` por `\alpha`-*tab*-`\hat`- *tab*-`\^(2)`-*tab*. (Se você encontrar um símbolo em algum lugar, por exemplo em código de outra pessoa, que você não sabe como digitar, a ajuda do REPL irá informá-lo: apenas digite `?` e em seguida cole o símbolo.)

Julia irá até deixar você redefinir constantes e funções internas se necessário (apesar de não é recomendado para evitar confusões potenciais):

```jldoctest
julia> pi = 3
3

julia> pi
3

julia> sqrt = 4
4
```

Entretanto, se você tentar redefinir uma constante ou função interna já em uso, Julia irá lhe devolver um erro:

```jldoctest
julia> pi
π = 3.1415926535897...

julia> pi = 3
ERROR: cannot assign a value to imported variable Base.pi from module Main

julia> sqrt(100)
10.0

julia> sqrt = 4
ERROR: cannot assign a value to imported variable Base.sqrt from module Main
```

## [Nomes de Variáveis Permitidos](@id man-allowed-variable-names)

Nomes de variáveis devem começar com uma letra (A-Z ou a-z), sublinhado, ou um subconjunto de pontos de código Unicode acima de 00A0; em particular, [categoria de caracteres unicode](https://www.fileformat.info/info/unicode/category/index.htm)
Lu/Ll/Lt/Lm/Lo/Nl (letras), Sc/So (monetários e outros símbolos) e mais alguns caracteres semelhantes à letras (exemplo, um subconjunto dos símbolos matemáticos Sm) são permitidos. Caracteres subsequentes podem também incluir ! e dígitos (0-9 e outros caracteres nas categorias Nd/No), assim como outros pontos de código Unicode, diacríticos e outras marcas modificadoras (categorias Mn/Mc/Me/Sk), alguns conectores de pontuação (categoria Pc), primos e mais alguns outros caracteres.

Operadores como `+` também são identificadores válidos, mas são analisados de forma diferente. Em alguns contextos, operadores podem ser usados da mesma forma que variáveis; por exemplo `(+)` se refere a função de adição e `(+) = f` irá reatribuí-lo. A maioria dos operadores infixos do Unicode (categoria SM), tais como `⊕` são avaliados como operadores infixos e estão disponíveis para métodos definidos pelo usuário (isto é, você pode usar  `const ⊗ = kron` para definir `⊗` como o produto infixo de Kronecker). Operadores tambéms podem ter sufixos com marcas modificadoras, primos e sobrescritos ou subscritos, isto é,  `+̂ₐ″` é avaliado como um operador infixo com a mesma precedência de `+`. Um espaço é necessário entre um operador que termina com uma letra subscrita/sobrescrita e um nome de variável subsequente. Por exemplo se `+ᵃ` é um operador, então `+ᵃx` deve ser escrito com `+ᵃ x` para distinguir da cadeia `+ ᵃx`, na qual `ᵃx` é o nome da variável.

Uma classe particular de variáveis é aquela que contém apenas sublinhados. Estes identificadores só podem ter valores atribuídos, que são descartados imediatamente e não podem desta forma serem usados para atribuir valores para outras variáveis (isto é, eles não podem ser usados como [`rvalues`](https://en.wikipedia.org/wiki/Value_(computer_science)#Assignment:_l-values_and_r-values)) ou até mesmo utilizar os últimos valores atribuídos a eles de qualquer forma.

```julia-repl
julia> x, ___ = size([2 2; 1 1])
(2, 2)

julia> y = ___
ERROR: syntax: all-underscore identifier used as rvalue

julia> println(___)
ERROR: syntax: all-underscore identifier used as rvalue
```

The only explicitly disallowed names for variables are the names of the built-in [Keywords](@ref Keywords):

Os únicos nomes explicitamente proibidos para variáveis são as [palavras chave](@ref Keywords) embutidas:

```julia-repl
julia> else = false
ERROR: syntax: unexpected "else"

julia> try = "No"
ERROR: syntax: unexpected "="
```

Alguns caracteres Unicode são considerados equivalentes ao serem usados em identificadores. Maneiras diferentes de informar caracteres combinantes no Unicode (isto é
, acentos) são tratados como equivalentes (especificamente, identificadores Julia são [NFC](https://en.wikipedia.org/wiki/Unicode_equivalence). Julia também inclui algumas equivalê
ncias fora do padrão para caracteres que são visualmente similares e são facilmente informados por algum método de entrada. O caractere Unicode `ɛ` (U+025B: letra pequena aberta latina e) and `µ` (U+00B5: sinal micro) são tratados como equivalentes a letras gregas correspondentes. O ponto mediano `·` (U+00B7) e o Grego
[intercalar](https://en.wikipedia.org/wiki/Interpunct) `·` (U+0387) são tratados como operador matemático `⋅` (U+22C5). O sinal de menos `−` (U+2212) é tratado como equivalente ao hí
fen `-` (U+002D).

## [Assignment expressions and assignment versus mutation](@id man-assignment-expressions)

An assignment `variable = value` "binds" the name `variable` to the `value` computed
on the right-hand side, and the whole assignment is treated by Julia as an expression
equal to the right-hand-side `value`.  This means that assignments can be *chained*
(the same `value` assigned to multiple variables with `variable1 = variable2 = value`)
or used in other expressions, and is also why their result is shown in the REPL as
the value of the right-hand side.  (In general, the REPL displays the value of whatever
expression you evaluate.)  For example, here the value `4` of `b = 2+2` is
used in another arithmetic operation and assignment:

```jldoctest
julia> a = (b = 2+2) + 3
7

julia> a
7

julia> b
4
```

A common confusion is the distinction between *assignment* (giving a new "name" to a value)
and *mutation* (changing a value).  If you run `a = 2` followed by `a = 3`, you have changed
the "name" `a` to refer to a new value `3` … you haven't changed the number `2`, so `2+2`
will still give `4` and not `6`!   This distinction becomes more clear when dealing with
*mutable* types like [arrays](@ref lib-arrays), whose contents *can* be changed:

```jldoctest mutation_vs_rebind
julia> a = [1,2,3] # an array of 3 integers
3-element Vector{Int64}:
 1
 2
 3

julia> b = a   # both b and a are names for the same array!
3-element Vector{Int64}:
 1
 2
 3
```

Here, the line `b = a` does *not* make a copy of the array `a`, it simply binds the name
`b` to the *same* array `a`: both `b` and `a` "point" to one array `[1,2,3]` in memory.
In contrast, an assignment `a[i] = value` *changes* the *contents* of the array, and the
modified array will be visible through both the names `a` and `b`:

```jldoctest mutation_vs_rebind
julia> a[1] = 42     # change the first element
42

julia> a = 3.14159   # a is now the name of a different object
3.14159

julia> b   # b refers to the original array object, which has been mutated
3-element Vector{Int64}:
 42
  2
  3
```
That is, `a[i] = value` (an alias for [`setindex!`](@ref)) *mutates* an existing array object
in memory, accessible via either `a` or `b`.  Subsequently setting `a = 3.14159`
does not change this array, it simply binds `a` to a different object; the array is still
accessible via `b`. The other common syntax to mutate an existing object is
`a.field = value` (an alias for [`setproperty!`](@ref)), which can be used to change
a [`mutable struct`](@ref).

When you call a [function](@ref man-functions) in Julia, it behaves as if you *assigned*
the argument values to new variable names corresponding to the function arguments, as discussed
in [Argument-Passing Behavior](@ref man-functions).  (By [convention](@ref man-punctuation),
functions that mutate one or more of their arguments have names ending with `!`.)


## Stylistic Conventions

While Julia imposes few restrictions on valid names, it has become useful to adopt the following
conventions:

  * Names of variables are in lower case.
  * Word separation can be indicated by underscores (`'_'`), but use of underscores is discouraged
    unless the name would be hard to read otherwise.
  * Names of `Type`s and `Module`s begin with a capital letter and word separation is shown with upper
    camel case instead of underscores.
  * Names of `function`s and `macro`s are in lower case, without underscores.
  * Functions that write to their arguments have names that end in `!`. These are sometimes called
    "mutating" or "in-place" functions because they are intended to produce changes in their arguments
    after the function is called, not just return a value.

For more information about stylistic conventions, see the [Style Guide](@ref).
