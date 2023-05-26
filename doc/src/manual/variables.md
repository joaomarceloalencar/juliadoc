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

## [Expressões de atribuição e atribuição versus mutação](@id man-assignment-expressions)

Uma atribuição `variável = valor` vincula o nome `variável` ao `valor` calculado no lado direito e toda a atribuição
é tratada por Julia como uma expressão igual ao `valor` do lado direito. Isso significa que atribuições podem ser
encadeadas (o mesmo `valor` atribuído para muitas variáveis com `variável1 = variável2 = valor`) ou usadas em outras expressões e esta é a razão pela qual seu resultado é mostrado na REPL como o valor do lado direito. (Em geral, a REPL mostra o valor de qualquer expressão avaliada). Por exemplo, aqui o valor `4` de `b = 2 + 2` é usado em outra operação aritmética e atribuição:

```jldoctest
julia> a = (b = 2+2) + 3
7

julia> a
7

julia> b
4
```

Uma confusão comum é distinção entre *atribuição* (dar um novo "nome" a um valor) e *mutação* (alterar um valor).
Se você executar `a = 2` seguido por `a = 3`, você mudou o "nome" `a` para referenciar o novo valor `3`. Você não alterou o número `2`, portanto `2 + 2` ainda irá retornar `4` e não `6`! Esta distinção se torna mais clara ao lidar com objetos *mutáveis* como [arrays](@ref lib-arrays), cujo conteúdo *pode* ser alterado:

```jldoctest mutation_vs_rebind
julia> a = [1,2,3] # um array de 3 inteiros
3-element Vector{Int64}:
 1
 2
 3

julia> b = a       # tanto b quanto a são nomes para o mesmo array!
3-element Vector{Int64}:
 1
 2
 3
```

Aqui, a linha `b = a` não faz uma cópia do _array_ `a`, simplesmente vincula o nome `b` para o mesmo _array_ `a`: tanto `b` quanto `a` apontam para o _array_ `[1,2,3]` na memória. Em contraste, uma atribuição `a[i] = valor` altera o conteúdo do `array` e o `array` modificado será visível tanto pelo nome `a` quanto pelo nome `b`:

```jldoctest mutation_vs_rebind
julia> a[1] = 42     # alterar o primeiro elemento
42

julia> a = 3.14159   # a agora é o nome de um objeto diferente
3.14159

julia> b             # b referencia o objeto array original, que foi alterado
3-element Vector{Int64}:
 42
  2
  3
```

Isto é, `a[i] = valor` (um apelido para [`setindex!`](@ref)) *altera* um objeto _array_ existente em memória, acessível seja por `a` ou `b`. Atribuir `a = 3.14159` não altera este _array_, simplesmente vincula `a` para um objeto diferente; o _array_ ainda é acessível por `b`. Outra sintaxe comum para alterar um objeto existente é `a.campo = valor` (um apelido para [`setproperty!`](@ref)), que pode ser usada para alterar uma [`estrutura mutável`](@ref).

Quando você chama uma [função](@ref man-functions) e Julia, ela se comporta como se você tivesse *atribuído* os valores dos argumentos para novos nomes de variáveis correspondendo aos argumentos da função, como discutindo em [Comportamento de Passagem de Argumento](@ref man-functions). (Por [convenção](@ref man-punctuation), funçòes que alteram um ou mais dos seus argumentos devem ter nomes terminando com `!`). 

## Convenções de Estilo

Apesar de Julia impor poucas restrições a nomes válidos, se tornou útil adotar as seguintes convenções:

  * Nomes de variáveis em minúsculo.
  * Separação de palavras pode ser indicada por sublinhados (`'_'`), mas o uso de sublinhados é desencorajado a não ser que o nome se tornasse difícil de ler sem usá-los.
  * Nomes de tipos e módulos começam com uma letra maiúscula e a separação de palavras é feita com letras maiúsculas no lugar de sublinhados.
  * Nomes de funções e macros são em minúsculas, sem sublinhados.
  * Funções que atualizam os argumentos tem nomes que terminam em `!`. Estas são algumas vezes chamadas de funções "mutante" ou "em local" porque são definidas para alterar seus argumentos após a invocação da função, não apenas retornar um valor.

Para mais informações sobre convenções de estilo, veja o [Guia de Estilo](@ref).