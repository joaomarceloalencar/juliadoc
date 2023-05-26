```@eval
io = IOBuffer()
release = isempty(VERSION.prerelease)
v = "$(VERSION.major).$(VERSION.minor)"
!release && (v = v*"-$(first(VERSION.prerelease))")
print(io, """
    # Julia $(v) Documentation

    Welcome to the documentation for Julia $(v).

    """)
if !release
    print(io,"""
        !!! warning "Work in progress!"
            This documentation is for an unreleased, in-development, version of Julia.
        """)
end
import Markdown
Markdown.parse(String(take!(io)))
```

Por valor leia as [notas de versão](NEWS.md) para observar o que mudou desde a última versão.

```@eval
release = isempty(VERSION.prerelease)
file = release ? "julia-$(VERSION).pdf" :
       "julia-$(VERSION.major).$(VERSION.minor).$(VERSION.patch)-$(first(VERSION.prerelease)).pdf"
url = "https://raw.githubusercontent.com/JuliaLang/docs.julialang.org/assets/$(file)"
import Markdown
Markdown.parse("""
!!! note
    The documentation is also available in PDF format: [$file]($url).
""")
```

## [Links Importantes](@id man-important-links)

Abaixo está uma lista não exaustiva de _links_ que serão úteis à medida que você aprende e usa a linguagem de programação Julia.

- [Página da Julia](https://julialang.org)
- [Download Julia](https://julialang.org/downloads/)
- [Fórum de Discussão](https://discourse.julialang.org)
- [Julia YouTube](https://www.youtube.com/user/JuliaLanguage)
- [Encontre pacotes Julia](https://julialang.org/packages/)
- [Recursos de Aprendizagem](https://julialang.org/learning/)
- [Leia e escreva blogs em Julia](https://forem.julialang.org)

## [Introdução](@id man-introduction)

Computação científica tradicionalmente necessida do melhor desempenho, ainda assim especialistas de domínio adotaram linguagens dinâmicas mais lentas em seu trabalho diário. Nós acreditamos que há várias boas razões para preferir linguagens dinâminas para essas aplicações e não esperamos que seu uso diminua. Felizmente, técnicas modernas de projeto de linguagens e compiladores tornam possível eliminar quase que totalmente a perda de desempenho e fornecem um ambiente único com produtividade suficiente para prototipação e com eficiência suficiente para implantar aplicações com desempenho intensivo. A linguagem de programação Julia desempenha esse papel: é uma linguagem dinâmica flexível, apropriada para computação científica e numérica, com desempenho comparavável a linguagems tradicionais com tipagem estática. 

Uma vez que o compilador Julia é diferente dos interpretadores usados para linguagems como Python ou R, você pode achar o desempenho de Julia contraintuitivo no começo. Se você acha que algo está lendo, sugerimos fortemente ler a seção [Dicas de Desempenho](@ref man-performance-tips) antes de tentar qualquer outra coisa. Uma vez que você entende como Julia funciona, é fácil escrever código que é quase tão rápido quanto C.

## [Julia Comparada a Outras Linguagens](@id man-julia-compared-other-languages)

Julia apresenta tipagem opcional, despacho múltiplo e bom desempenho, garantidos pela inferência de tipos e [Compilação just-in-time (JIT)](https://en.wikipedia.org/wiki/Just-in-time_compilation) (e
[Compilação antes do tempo opcional](https://github.com/JuliaLang/PackageCompiler.jl)),
implementada usando [LLVM](https://en.wikipedia.org/wiki/Low_Level_Virtual_Machine). É multi paradigma, combinando características de linguagens imperativas, funcionais e orientadas a objetos. Julia fornece facilidade e expressividade computação numérica de alto nívl da mesma maneira que linguagens como R, MATLAB e Python, mas também suporta programação geral. Para conseguir isso, Julia aprimora uma linhagem de linguagens de programação matemáticas, mas também utiliza muito de linguagens dinâmicas populares, incluindo [Lisp](https://en.wikipedia.org/wiki/Lisp_(programming_language)), [Perl](https://en.wikipedia.org/wiki/Perl_(programming_language)),
[Python](https://en.wikipedia.org/wiki/Python_(programming_language)), [Lua](https://en.wikipedia.org/wiki/Lua_(programming_language)) e [Ruby](https://en.wikipedia.org/wiki/Ruby_(programming_language)).

As diferenças mais importantes de Julia em relação a linguagens dinâmicas típicas são:

  * O núcleo da linguagens tem poucas imposições; a base da Julia e a biblioteca padrão são escritas na própria Jula, incluindo operações primitivas como aritméticas de inteiros
  * Uma linguagens de tipos rica para construir e descrever objetos que também pode ser usada opcionalmente para fazer declarações de tipos
  * A possibilidade de definir comportamento de funções através de várias combinações de tipos de argumentos através do [dispacho múltipo](https://en.wikipedia.org/wiki/Multiple_dispatch)
  * Geração automática de código eficiente e especializado para diferentes tipos de argumentos.
  * Bom desempenho, aproximando de linguagens compiladas estaticamente como C

Apesar de muitas vezes falarem de linguagens dinâmicas como "sem tipo", elas definitivamente não são assim. Cada objeto, seja primitivo ou definido pelo usuário, tem um tipo. A ausência de declarações de tipos na maioria das linguagens dinâmicas, entretanto, significa que não é possível instruir o compilador sobre os tipos de valores e geralmente não é possível falar sobre tipos de alguma forma. Em linguagens estáticas, por outro lado, enquanto é possível -- e geralmente aconselhável -- anotar tipos para o compilador, tipos existem apenas no tempo de compilação e não podem ser manipulados ou expressados durante tempo de execução. Em Julia, tipos são eles mesmos objetos de tempo de execução e podem ser usados para transmitir informação ao compilador. 

### [O que faz de Julia, Julia?](@id man-what-makes-julia)

Enquanto o programador casual não precisa utilizar explicitamente tipos ou despacho múltiplo, estas são as características essenciais de Julia: funções são definidas em combinações diferentes de tipos de argumentos e aplicadas por despacho para a definição com combinação mais específica. Esse modelo é uma boa opção para programação matemática, na qual não é natural que o primeiro argumento "domine" uma operação como no despacho tradicional orientado a objetos. Operadores são apenas funções com notação especial -- para ampliar adição para novos tipos definidos pelo usuário, você define novos métodos para a função `+`. Código existente pode ser aplicado sem alterações para novos tipos de dados.

Em parte devido a inferência de tipos em tempo de execução (aprimorada por anotações de tipo opcionais) e em parte por causa da ênfase em desempenho desde a criação do projeto, a eficiência computacional da Julia é superior a de outras linguagens dinâmicas e até mesmo rivaliza a de linguagens com compilação estática. Para problemas numéricos de larga escala, velocidade sempre foi, e continua sendo, e provavelmente sempre será crucial: a quantidade de dados sendo processadas tem facilmente acompanhado o ritmo da Lei de Moore no decorrer das últimas décadas. 

### [Vantagens da Julia](@id man-advantages-of-julia)

Julia tem como objetivo criar uma combinação sem precedentes de facilidade de uso, poder e eficiência em uma única linguagem. Em adição ao que já foi dito acima, algumas vantagens de Julia em relação a sistemas semelhantes inclui:

  * Livre e código aberto ([MIT licensed](https://github.com/JuliaLang/julia/blob/master/LICENSE.md))
  * Tipos definidos pelo usuário são tão rápidos e compactos quanto os embutidos
  * Sem necessidade de vetorizar código para desempenho; código sem vetorização é rápido.
  * Projetado para paralelismo e computação distribuída
  * Threads leves "verdes" ([coroutines](https://en.wikipedia.org/wiki/Coroutine))
  * Sistema de tipos poderoso discreto
  * Conversões e promoções elegantes e extensíveis para tipos numéricos e outros
  * Suporte eficiente para [Unicode](https://en.wikipedia.org/wiki/Unicode), incluindo mas não limitado à [UTF-8](https://en.wikipedia.org/wiki/UTF-8)
  * Invocar funções C diretamente (sem _wrappers_ ou APIs especiais)
  * Funcionalidades semelhantes ao _shell_ para gerenciar outros processos
  * Macros semelhantes a Lisp e outras facilidades da metaprogramação.
