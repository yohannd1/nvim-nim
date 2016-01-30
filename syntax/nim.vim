" if exists("b:current_syntax")
"   finish
" endif
" if version < 600
"     syntax
" endif

let b:current_syntax = "nim"


" Keywords
syntax keyword nimKeyword let const var static
syntax keyword nimKeyword addr asm atomic bind cast converter
syntax keyword nimKeyword defer discard distinct do end generic iterator
syntax keyword nimKeyword typedesc out ptr raise ref return using with without yield

" syntax keyword nimOperator for while
syntax keyword nimBoolean      true   false
syntax keyword nimConditional  if     elif    else   case      continue break
syntax keyword nimDefine       from   as
syntax keyword nimException    try    except  finally
syntax keyword nimInclude      import include export
syntax keyword nimLabel        of
syntax keyword nimMacro        macro
syntax keyword nimPreCondit    when   block
syntax keyword nimPreProc      nil
syntax keyword nimRepeat       for    while
syntax keyword nimStorage      tuple  enum    object interface concept  mixin
syntax keyword nimStorageClass type
syntax keyword nimTypedef      func   proc    method template

syntax keyword nimTodo TODO FIXME


" Operators
syntax match nimOperatorAll "[&:?!@<>\|\~\.\^\=\/\+\-\*\$%]\+"
syntax keyword nimOperator and or not xor shl shr div mod in notin is isnot of.
syntax keyword nimOP9 div mod shl shr
syntax keyword nimOP5 in notin is isnot not of
syntax keyword nimOP4 and
syntax keyword nimOP3 or xor
syntax match nimOP10        "[\$\^]"
syntax match nimOP9         "[\*\%\\\/]"
syntax match nimOP6         "\."
syntax match nimOP5         "[=|<|>]"
syntax match nimOP5         "\v([!<>]\=)"
syntax match nimOP2         "[@:?]"
syntax match nimOP1         "[\*+\/%&]="
syntax match nimOP0         "=>"
syntax match nimOP0         "\->"


" Comments
syntax match nimComment "\v#.*$" contains=nimTodo


" Builtin
syntax keyword nimBuiltinFunction echo debugEcho

syntax keyword nimBuiltinType seq


" Numbers
syntax match nimNumber "\v[0-9_]+((i|I|u|U)(8|16|32|64))?>"
syntax match nimFloat "\v[0-9_]+(f|d|F|D)>"
syntax match nimFloat "\v[0-9_]+\.[0-9]+(f|d|F|D)>"
syntax match nimFloat "\v[0-9_]+((f|F)(32|64|128))>"
syntax match nimFloat "\v[0-9_]+\.[0-9]+((f|F)(32|64|128))?>"


" Tokens
syntax match nimToken "`"
syntax match nimToken "("
syntax match nimToken ")"
syntax match nimToken "{"
syntax match nimToken "}"
syntax match nimToken "\["
syntax match nimToken "\]"
syntax match nimToken ","
syntax match nimToken ";"
syntax match nimToken "\[\."
syntax match nimToken "\.\]"
syntax match nimToken "{\."
syntax match nimToken "\.}"
syntax match nimToken "(\."
syntax match nimToken "\.)"


" Linking
highlight link nimBuiltinFunction Function
highlight link nimBuiltinType     Type
highlight link nimComment         Comment
highlight link nimKeyword         Keyword
highlight link nimTodo            Todo
highlight link nimOperatorAll     Operator
highlight link nimOP10            Operator10
highlight link nimOP9             Operator9
highlight link nimOP8             Operator8
highlight link nimOP7             Operator7
highlight link nimOP6             Operator6
highlight link nimOP5             Operator5
highlight link nimOP4             Operator4
highlight link nimOP3             Operator3
highlight link nimOP2             Operator2
highlight link nimOP1             Operator1
highlight link nimOP0             Operator0
highlight link nimToken           Delimiter
highlight link nimSuffix          SpecialChar
highlight link nimBoolean         Boolean
highlight link nimFloat           Float
highlight link nimString          String
highlight link nimChar            Char
highlight link nimNumber          Number

highlight link nimConditional  Conditional
highlight link nimConstant     Constant
highlight link nimDefine       Define
highlight link nimException    Exception
highlight link nimInclude      Include
highlight link nimLabel        Label
highlight link nimMacro        Macro
highlight link nimPreCondit    PreCondit
highlight link nimPreProc      PreProc
highlight link nimRepeat       Repeat
highlight link nimStorage      Structure
highlight link nimStorageClass StorageClass
highlight link nimTypedef      Typedef
