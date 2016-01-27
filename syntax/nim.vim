if exists("b:current_syntax")
  finish
endif

syntax keyword nimKeyword let const var
syntax keyword nimKeyword addr and as asm atomic
syntax keyword nimKeyword bind block break
syntax keyword nimKeyword case cast concept const continue converter
syntax keyword nimKeyword defer discard distinct div do
syntax keyword nimKeyword elif else end enum except export
syntax keyword nimKeyword finally for from func
syntax keyword nimKeyword generic
syntax keyword nimKeyword if import in include interface is isnot iterator
syntax keyword nimKeyword let
syntax keyword nimKeyword macro method mixin mod
syntax keyword nimKeyword nil not notin
syntax keyword nimKeyword object of or out
syntax keyword nimKeyword proc ptr
syntax keyword nimKeyword raise ref return
syntax keyword nimKeyword shl shr static
syntax keyword nimKeyword template try tuple type
syntax keyword nimKeyword using
syntax keyword nimKeyword var
syntax keyword nimKeyword when while with without
syntax keyword nimKeyword xor
syntax keyword nimKeyword yield

syntax keyword nimBuiltinFunction echo

syntax keyword nimOperator and or not xor shl shr div mod in notin is isnot of.
" syntax keyword nimOperator =+-*/<>@$~&%|!?^.:\

highlight link nimOperator Operator
highlight link nimKeyword Keyword
highlight link nimBuiltinFunction Function

let b:current_syntax = "nim"
