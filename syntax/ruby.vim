" Vim syntax file
" Language: Ruby
" Author: Jeffrey Crochet <jlcrochet91@pm.me>
" URL: https://github.com/jlcrochet/vim-ruby

if exists("b:current_syntax")
  finish
endif

" Syntax {{{1
syn sync fromstart
syn iskeyword @,48-57,_,?,!,:,128-255

if get(b:, "is_eruby")
  syn cluster rubyTop contains=@ruby
else
  syn cluster rubyTop contains=TOP
endif

syn cluster rubyPostfix contains=rubyOperator,rubyMethodOperator,rubyRangeOperator,rubyPostfixKeyword,rubyComma,rubySemicolon,rubyBackslash
syn cluster rubyArguments contains=rubyNumber,rubyCharacter,rubyString,rubyStringArray,rubySymbol,rubySymbolArray,rubyRegex,rubyCommand,rubyHeredoc,rubyHeredocSkip
syn cluster rubyKeywordArguments contains=rubyHashKey,rubyVariableOrMethod,rubyConstant,rubyInstanceVariable,rubySelf,rubyNil,rubyBoolean,rubySuper,rubyKeyword,rubyBlock,rubyDefine,rubyDefineLine,rubyDefineBlock,rubyBlockSkip

syn match rubyHashKey /\%#=1[^\x00-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*[?!]\=/ contained nextgroup=rubyHashKeyDelimiter
syn match rubyHashKey /\%#=1\u[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*[?!]\=/ contained nextgroup=rubyHashKeyDelimiter

" Comments {{{2
if get(b:, "is_eruby")
  syn match rubyLineComment /\%#=1#.\{-}\ze\%(-\=%>\)\=/ contains=rubyTodo
else
  syn match rubyLineComment /\%#=1#.*/ contains=rubyTodo
  syn region rubyComment start=/\%#=1^=begin\>.*/ end=/\%#=1^=end\>.*/ contains=rubyTodo
endif

syn match rubyTodo /\%#=1\<\(BUG\|DEPRECATED\|FIXME\|NOTE\|WARNING\|OPTIMIZE\|TODO\|XXX\|TBD\):\=\>/ contained

" Operators {{{2
syn cluster rubyRHS contains=@rubyArguments,rubyVariableOrMethod,rubyGlobalVariable,rubyConstant,rubyInstanceVariable,rubySelf,rubyNil,rubyBoolean,rubySuper,rubyKeyword,rubyBlock

syn match rubyUnaryOperator /\%#=1[+*!~&^]/ nextgroup=@rubyRHS skipwhite skipempty
syn match rubyUnaryOperator /\%#=1->\=/ nextgroup=@rubyRHS skipwhite skipempty

syn match rubyOperator /\%#=1=\%(==\=\|[>~]\)\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1![=~]/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1<\%(<=\=\|=>\=\)\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1>>\==\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1+=\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1-=\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1\*\*\==\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1[/?:]/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1%=\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1&&\==\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1||\==\=/ contained nextgroup=@rubyRHS skipwhite skipempty
syn match rubyOperator /\%#=1\^=\=/ contained nextgroup=@rubyRHS skipwhite skipempty

syn match rubyMethodOperator /\%#=1&\=\./ nextgroup=rubyVariableOrMethod,rubyOperatorMethod skipwhite
syn match rubyOperatorMethod /\%#=1\%([&|^/%]\|=\%(==\=\|\~\)\|>[=>]\=\|<\%(<\|=>\=\)\=\|[+\-~]@\=\|\*\*\=\|\[]=\=\|![@=~]\=\)/ contained nextgroup=@rubyPostfix,@rubyArguments,@rubyKeywordArguments skipwhite

syn match rubyRangeOperator /\%#=1\.\.\.\=/ nextgroup=rubyOperator,rubyPostfixKeyword skipwhite nextgroup=@rubyRHS skipwhite skipempty

syn match rubyNamespaceOperator /\%#=1::/ nextgroup=rubyConstant

" Delimiters {{{2
syn match rubyDelimiter /\%#=1(/ nextgroup=@rubyArguments,@rubyKeywordArguments skipwhite skipempty
syn match rubyDelimiter /\%#=1)/ nextgroup=@rubyPostfix skipwhite

syn match rubyDelimiter /\%#=1\[/ nextgroup=@rubyArguments,@rubyKeywordArguments skipwhite skipempty
syn match rubyDelimiter /\%#=1]/ nextgroup=@rubyPostfix skipwhite

syn match rubyDelimiter /\%#=1{/ nextgroup=rubyBlockParameters,@rubyArguments,@rubyKeywordArguments skipwhite skipempty
syn match rubyDelimiter /\%#=1}/ nextgroup=@rubyPostfix skipwhite

syn region rubyNestedParentheses matchgroup=rubyDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@rubyRHS,rubyHashKey,rubyNestedParentheses nextgroup=@rubyPostfix skipwhite
syn region rubyNestedBrackets matchgroup=rubyDelimiter start=/\%#=1\[/ end=/\%#=1]/ contained contains=@rubyRHS,rubyNestedBrackets nextgroup=@rubyPostfix skipwhite
syn region rubyNestedBraces matchgroup=rubyDelimiter start=/\%#=1{/ end=/\%#=1}/ contained contains=@rubyTop,rubyBlockParameters,rubyHashKey,rubyNestedBraces nextgroup=@rubyPostfix skipwhite

syn match rubyComma /\%#=1,/ contained nextgroup=@rubyArguments,@rubyKeywordArguments skipwhite skipempty

syn match rubyBackslash /\%#=1\\/
syn match rubySemicolon /\%#=1;/

" Identifiers {{{2
syn match rubyInstanceVariable /\%#=1@@\=[^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*/ nextgroup=@rubyPostfix skipwhite
syn match rubyGlobalVariable /\%#=1\$\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|[!@~&`'"+=/\\,;:.<>_*$?]\|-\w\|0\|[1-9]\d*\)/ nextgroup=@rubyPostfix skipwhite
syn match rubyConstant /\%#=1\u[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\%(::\u[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\)*:\@!\>/ contains=rubyNamespaceOperator nextgroup=@rubyPostfix skipwhite
syn match rubyVariableOrMethod /\%#=1[^\x00-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*[?!]\=:\@!\>/ nextgroup=@rubyPostfix,@rubyArguments,@rubyKeywordArguments skipwhite

" Literals {{{2
syn keyword rubyNil nil nextgroup=@rubyPostfix skipwhite
syn keyword rubyBoolean true false nextgroup=@rubyPostfix skipwhite
syn keyword rubySelf self nextgroup=@rubyPostfix skipwhite
syn keyword rubySuper super nextgroup=@rubyPostfix,@rubyArguments,@rubyKeywordArguments skipwhite

" Numbers {{{3
syn match rubyNumber /\%#=1[1-9]\d*\%(_\d\+\)*\%([eE][+-]\=\d\+\%(_\d\+\)*i\=\|\.\d\+\%(_\d\+\)*\%([eE][+-]\=\d\+\%(_\d\+\)*i\=\|ri\=\|i\)\=\|ri\=\|i\)\=\>/ nextgroup=@rubyPostfix skipwhite
syn match rubyNumber /\%#=10\%([eE][+-]\=\d\+\%(_\d\+\)*i\=\|\.\d\+\%(_\d\+\)*\%([eE][+-]\=\d\+\%(_\d\+\)*i\=\|ri\=\|i\)\=\|ri\=\|i\|\o\+\%(_\o\+\)*r\=i\=\|[bB][01]\+\%(_[01]\+\)*r\=i\=\|[oO]\o\+\%(_\o\+\)*r\=i\=\|[dD]\d\+\%(_\d\+\)*r\=i\=\|[xX]\x\+\%(_\x\+\)*r\=i\=\)\=\>/ nextgroup=@rubyPostfix skipwhite

" Strings {{{3
syn match rubyCharacter /\%#=1?\%(\\\%(\o\{1,3}\|x\x\{,2}\|u\%(\x\{,4}\|{\x\{1,6}}\)\|\%(c\|C-\)\%(\\M-\)\=\S\|M-\%(\\c\|\\C-\)\=\S\|\_.\)\|\S\)/ contains=rubyCharacterStart,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn match rubyCharacterStart /\%#=1?\@1<!?/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1"/ matchgroup=rubyStringEnd end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite

syn match rubyStringInterpolation /\%#=1#\%(@@\=[^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|\$\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|[!@~&`'"+=/\\,;:.<>_*$?]\|-\w\|0\|[1-9]\d*\)\)/ contained contains=rubyStringInterpolationDelimiter,rubyInstanceVariable,rubyGlobalVariable
syn match rubyStringInterpolationDelimiter /\%#=1#/ contained
syn region rubyStringInterpolation matchgroup=rubyStringInterpolationDelimiter start=/\%#=1#{/ end=/\%#=1}/ contained contains=@rubyTop,rubyNestedBraces

syn match rubyStringEscape /\%#=1\\\_./ contained
syn match rubyStringEscapeError /\%#=1\\\%(x\|u\x\{,3}\)/ contained
syn match rubyStringEscape /\%#=1\\\%(\o\{1,3}\|x\x\x\=\|u\%(\x\{4}\|{\s*\x\{1,6}\%(\s\+\x\{1,6}\)*\s*}\)\|\%(c\|C-\)\%(\\M-\)\=\p\|M-\%(\\c\|\\C-\)\=\p\)/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1'/ matchgroup=rubyStringEnd end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn match rubyQuoteEscape /\%#=1\\[\\']/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=(/ matchgroup=rubyStringEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn region rubyStringParentheses matchgroup=rubyString start=/\%#=1(/ end=/\%#=1)/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=\[/ matchgroup=rubyStringEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn region rubyStringSquareBrackets matchgroup=rubyString start=/\%#=1\[/ end=/\%#=1]/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\={/ matchgroup=rubyStringEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn region rubyStringCurlyBraces matchgroup=rubyString start=/\%#=1{/ end=/\%#=1}/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=</ matchgroup=rubyStringEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn region rubyStringAngleBrackets matchgroup=rubyString start=/\%#=1</ end=/\%#=1>/ transparent contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q(/ matchgroup=rubyStringEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyParenthesisEscape nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn match rubyParenthesisEscape /\%#=1\\[\\()]/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q\[/ matchgroup=rubyStringEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubySquareBracketEscape nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn match rubySquareBracketEscape /\%#=1\\[\\\[\]]/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q{/ matchgroup=rubyStringEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyCurlyBraceEscape nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn match rubyCurlyBraceEscape /\%#=1\\[\\{}]/ contained

syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q</ matchgroup=rubyStringEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyAngleBracketEscape nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn match rubyAngleBracketEscape /\%#=1\\[\\<>]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w(/ end=/\%#=1)/ contains=rubyStringParentheses,rubyArrayParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayParenthesisEscape /\%#=1\\[()[:space:]]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyArraySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArraySquareBracketEscape /\%#=1\\[\[\][:space:]]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w{/ end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayCurlyBraceEscape /\%#=1\\[{}[:space:]]/ contained

syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w</ end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyArrayAngleBracketEscape nextgroup=@rubyPostfix skipwhite
syn match rubyArrayAngleBracketEscape /\%#=1\\[<>[:space:]]/ contained

" Symbols {{{3
syn match rubySymbol /\%#=1:\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*[?!=]\=\|\%([&|^/%]\|=\%(==\=\|\~\)\|>[=>]\=\|<\%(<\|=>\=\)\=\|[+\-~]@\=\|\*\*\=\|\[]=\=\|![@=~]\=\)\)/ contains=rubySymbolStart nextgroup=@rubyPostfix skipwhite

syn match rubySymbolStart /\%#=1:/ contained
syn match rubyHashKeyDelimiter /\%#=1:/ contained nextgroup=rubyComma skipwhite

syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1:"/ matchgroup=rubySymbolEnd end=/\%#=1"/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1:'/ matchgroup=rubySymbolEnd end=/\%#=1'/ contains=rubyQuoteEscape nextgroup=@rubyPostfix skipwhite

syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s(/  matchgroup=rubySymbolEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s\[/ matchgroup=rubySymbolEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s{/  matchgroup=rubySymbolEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s</  matchgroup=rubySymbolEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i(/  end=/\%#=1)/ contains=rubyStringParentheses,rubyArrayParenthesisEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i\[/ end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyArraySquareBracketEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i{/  end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyArrayCurlyBraceEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i</  end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyArrayAngleBracketEscape nextgroup=@rubyPostfix skipwhite

" Regular Expressions {{{3
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1\/\s\@!/ matchgroup=rubyRegexEnd end=/\%#=1\/[imx]*/ skip=/\%#=1\\\\\|\\\// oneline keepend contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite

" NOTE: This is defined here in order to take precedence over /-style
" regexes
syn match rubyOperator /\%#=1\/=/ contained

syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r(/  matchgroup=rubyRegexEnd end=/\%#=1)[imx]*/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r\[/ matchgroup=rubyRegexEnd end=/\%#=1][imx]*/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r{/  matchgroup=rubyRegexEnd end=/\%#=1}[imx]*/ skip=/\%#=1{.\{-}}/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r</  matchgroup=rubyRegexEnd end=/\%#=1>[imx]*/ skip=/\%#=1<.\{-}>/ contains=rubyStringInterpolation,@rubyOnigmo nextgroup=@rubyPostfix skipwhite

" Onigmo {{{4
syn cluster rubyOnigmo contains=
      \ rubyOnigmoGroup,rubyOnigmoEscape,rubyOnigmoMetaCharacter,rubyOnigmoQuantifier,rubyOnigmoComment,rubyOnigmoClass

syn match rubyOnigmoEscape /\%#=1\\\%(\d\+\|x\%(\x\x\|{\x\+}\)\|u\x\x\x\x\|c.\|C-.\|M-\%(\\\\C-.\|.\)\|p{\^\=\u\a*}\|P{\u\a*}\|k\%(<\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|-\=\d\+\)\%([+-]\d\+\)\=>\|'\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|-\=\d\+\)\%([+-]\d\+\)\='\)\|g\%(<\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|[+-]\=\d\+\)>\|'\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|[+-]\=\d\+\)'\)\|.\)/ contained
syn region rubyOnigmoGroup matchgroup=rubyOnigmoMetaCharacter start=/\%#=1(\%(?\%([imxdau]\+\%(-[imx]\+\)\=:\=\|[:=!>~]\|<[=!]\|<[^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*>\|(\%(\d\+\|<[^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*>\|'[^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*'\))\)\)\=/ end=/\%#=1)/ contained transparent

syn match rubyOnigmoMetaCharacter /\%#=1[.^$|]/ contained

syn match rubyOnigmoQuantifier /\%#=1[?*+][?+]\=/ contained
syn match rubyOnigmoQuantifier /\%#=1{\%(\d\+,\=\d*\|,\d\+\)}[?+]\=/ contained

syn region rubyOnigmoComment start=/\%#=1(?#/ end=/\%#=1)/ contained contains=rubyRegexSlashEscape
syn match rubyRegexSlashEscape /\%#=1\\\// contained

syn region rubyOnigmoClass matchgroup=rubyOnigmoMetaCharacter start=/\%#=1\[\^\=/ end=/\%#=1\]/ contained transparent contains=rubyOnigmoEscape,rubyStringEscape,rubyStringEscapeError,rubyOnigmoPOSIXClass,rubyOnigmoClass,rubyOnigmoIntersection
syn match rubyOnigmoPOSIXClass /\%#=1\[:\^\=\l\+:\]/ contained
syn match rubyOnigmoIntersection /\%#=1&&/ contained nextgroup=rubyOnigmoClass

" Commands {{{3
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1`/ matchgroup=rubyCommandEnd end=/\%#=1`/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x(/  matchgroup=rubyCommandEnd end=/\%#=1)/ contains=rubyStringParentheses,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x\[/ matchgroup=rubyCommandEnd end=/\%#=1]/ contains=rubyStringSquareBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x{/  matchgroup=rubyCommandEnd end=/\%#=1}/ contains=rubyStringCurlyBraces,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x</  matchgroup=rubyCommandEnd end=/\%#=1>/ contains=rubyStringAngleBrackets,rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

" Additional % Literals {{{3
syn region rubyString matchgroup=rubyStringStart start=/\%#=1%Q\=\z([)\]}>~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyStringEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn region rubyString matchgroup=rubyStringStart start=/\%#=1%q\z([)\]}>~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyStringEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ nextgroup=@rubyPostfix,rubyHashKeyDelimiter skipwhite
syn region rubyStringArray matchgroup=rubyStringArrayDelimiter start=/\%#=1%w\z([)\]}>~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyArrayEscape nextgroup=@rubyPostfix skipwhite
syn region rubySymbol matchgroup=rubySymbolStart start=/\%#=1%s\z([)\]}>~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubySymbolEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite
syn region rubySymbolArray matchgroup=rubySymbolArrayDelimiter start=/\%#=1%i\z([)\]}>~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyArrayEscape nextgroup=@rubyPostfix skipwhite
syn region rubyRegex matchgroup=rubyRegexStart start=/\%#=1%r\z([)\]}>~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyRegexEnd end=/\%#=1\z1[imx]*/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError,@rubyRegexSpecial nextgroup=@rubyPostfix skipwhite
syn region rubyCommand matchgroup=rubyCommandStart start=/\%#=1%x\z([)\]}>~`!@#$%^&*_\-+=|\\:;"',.?/]\)/ matchgroup=rubyCommandEnd end=/\%#=1\z1/ skip=/\%#=1\\\\\|\\\z1/ contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=@rubyPostfix skipwhite

syn match rubyArrayEscape /\%#=1\\\s/ contained

" Here Documents {{{3
syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\=\z([^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]\+\)/ matchgroup=rubyHeredocEnd end=/\%#=1^\s*\z1$/ contains=rubyHeredocStartLine,rubyHeredocLine
syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\=\(["`]\)\z(.\{-}\)\1/ matchgroup=rubyHeredocEnd end=/\%#=1^\s*\z1$/ contains=rubyHeredocStartLine,rubyHeredocLine
syn match rubyHeredocStartLine /\%#=1.*/ contained contains=@rubyTop nextgroup=rubyHeredocLine skipempty
syn match rubyHeredocLine /\%#=1^.*/ contained contains=rubyStringInterpolation,rubyStringEscape,rubyStringEscapeError nextgroup=rubyHeredocLine skipempty

syn region rubyHeredoc matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\='\z(.\{-}\)'/ matchgroup=rubyHeredocEnd end=/\%#=1^\s*\z1$/ contains=rubyHeredocStartLineRaw,rubyHeredocLineRaw
syn match rubyHeredocStartLineRaw /\%#=1.*/ contained contains=@rubyTop nextgroup=rubyHeredocLineRaw skipempty
syn match rubyHeredocLineRaw /\%#=1^.*/ contained nextgroup=rubyHeredocLineRaw skipempty

syn region rubyHeredocSkip matchgroup=rubyHeredocStart start=/\%#=1<<[-~]\=\%(\(["`']\).\{-}\1\|[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]\+\)/ end=/\%#=1\ze<<[-~]\=[^\x00-\x21\x23-\x26\x28-\x40\x5B-\x5E\x7B-\x7F]/ contains=@rubyTop,@rubyPostfix oneline nextgroup=rubyHeredoc,rubyHeredocSkip
syn region rubyHeredocSkip start=/\%#=1<<[-~]\=\%(\(["`']\).\{-}\1\|[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]\+\)/ end=/\%#=1\ze<<[-~]\=[^\x00-\x21\x23-\x26\x28-\x40\x5B-\x5E\x7B-\x7F]/ transparent oneline

" Blocks {{{2
if get(g:, "ruby_simple_indent") || get(b:, "is_eruby") || get(b:, "is_haml")
  syn keyword rubyKeyword if unless case while until for begin else elsif when ensure
  syn keyword rubyKeyword in nextgroup=@rubyKeywordArguments skipwhite
  syn keyword rubyKeyword rescue nextgroup=rubyConstant,rubyOperator skipwhite
  syn keyword rubyKeyword end nextgroup=@rubyPostfix skipwhite
  syn keyword rubyKeyword do nextgroup=rubyBlockParameters skipwhite

  syn keyword rubyKeyword def nextgroup=rubyMethodDefinition skipwhite
  syn keyword rubyKeyword class module nextgroup=rubyTypeDefinition skipwhite
else
  " NOTE: When definition blocks are highlighted, the following keywords
  " have to be matched with :syn-match instead of :syn-keyword to
  " prevent the block regions from being clobbered.

  syn keyword rubyKeywordError end else elsif when in ensure rescue
  syn keyword rubyKeywordError and or then

  syn match rubyKeyword /\%#=1\<do\>/ nextgroup=rubyBlockParameters skipwhite contained containedin=rubyBlock
  syn region rubyBlock start=/\%#=1\<do\>/ matchgroup=rubyKeyword end=/\%#=1\<\.\@1<!end\>/ contains=@rubyTop nextgroup=@rubyPostfix skipwhite

  syn region rubyBlock matchgroup=rubyKeyword start=/\%#=1\<\%(if\|unless\|case\|begin\|for\|while\|until\)\>/ end=/\%#=1\<\.\@1<!end\>/ contains=@rubyTop nextgroup=@rubyPostfix skipwhite
  syn keyword rubyKeyword else elsif when ensure contained containedin=rubyBlock
  syn keyword rubyKeyword in contained containedin=rubyBlock nextgroup=rubyHashKey skipwhite
  syn keyword rubyKeyword rescue contained containedin=rubyBlock nextgroup=rubyConstant,rubyOperator skipwhite

  syn region rubyBlockSkip matchgroup=rubyKeywordNoBlock start=/\%#=1\<\%(while\|until\|for\)\>/ end=/\%#=1\ze\<\.\@1<!do\>/ transparent oneline nextgroup=rubyBlock

  syn match rubyDefine /\%#=1\<def\>/ nextgroup=rubyMethodDefinition skipwhite
  syn match rubyDefine /\%#=1\<\%(class\|module\)\>/ nextgroup=rubyTypeDefinition skipwhite contained containedin=rubyDefineBlock

  syn region rubyDefineBlock start=/\%#=1\<\%(def\|class\|module\)\>/ matchgroup=rubyDefine end=/\%#=1\<\.\@1<!end\>/ contains=@rubyTop fold
  syn keyword rubyDefine else ensure contained containedin=rubyDefineBlock
  syn keyword rubyDefine rescue contained containedin=rubyDefineBlock nextgroup=rubyConstant,rubyOperator skipwhite

  " This is to handle `end`-less definitions:
  syn region rubyDefineLine matchgroup=rubyDefineNoBlock start=/\%#=1\<def\>/ matchgroup=rubyMethodAssignmentOperator end=/\%#=1=/ skip=/\%#=1\%((.*)\|=\%([>~]\|==\=\)\|!=\|\[\]=\|[^\x00-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*=\=\)/ oneline contains=rubyMethodDefinition
endif

syn match rubyTypeDefinition /\%#=1\u[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*/ contained nextgroup=rubyTypeNamespace,rubyInheritanceOperator skipwhite
syn match rubyTypeNamespace /\%#=1::/ contained nextgroup=rubyTypeDefinition
syn match rubyInheritanceOperator /\%#=1</ contained nextgroup=rubyConstant skipwhite

syn match rubyMethodDefinition /\%#=1\%(\%(\u[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|[^\x00-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\)\.\)\=\%([^\x00-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*[?!=]\=\|\%([&|^/%]\|=\%(==\=\|\~\)\|>[=>]\=\|<\%(<\|=>\=\)\=\|[+\-~]@\=\|\*\*\=\|\[]=\=\|![@=~]\=\)\)/ contained contains=@rubyMethodReceivers nextgroup=rubyMethodParameters,rubyMethodAssignmentOperator,rubyHashKey,rubyVariableOrMethod skipwhite
syn region rubyMethodParameters matchgroup=rubyDelimiter start=/\%#=1(/ end=/\%#=1)/ contained contains=@rubyTop,rubyHashKey nextgroup=rubyMethodAssignmentOperator skipwhite
syn cluster rubyMethodReceivers contains=rubyMethodReceiverVariable,rubyMethodReceiverConstant,rubyMethodReceiverSelf
syn match rubyMethodReceiverVariable /\%#=1[^\x00-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\.\@=/ contained nextgroup=rubyMethodReceiverDot
syn match rubyMethodReceiverConstant /\%#=1\u[^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\.\@=/ contained nextgroup=rubyMethodReceiverDot
syn keyword rubyMethodReceiverSelf self contained nextgroup=rubyMethodReceiverDot
syn match rubyMethodReceiverDot /\%#=1\./ contained nextgroup=rubyMethodDefinition
syn match rubyMethodAssignmentOperator /\%#=1=/ contained

" Miscellaneous {{{2
syn keyword rubyKeyword not undef
syn keyword rubyKeyword return next break yield redo retry nextgroup=rubyPostfixKeyword skipwhite

syn keyword rubyKeyword alias nextgroup=@rubyAliases skipwhite
syn cluster rubyAliases contains=rubySymbolAlias,rubyGlobalVariableAlias,rubyMethodAlias
syn match rubySymbolAlias /\%#=1:\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*[?!=]\=\|\%([&|^/%]\|=\%(==\=\|\~\)\|>[=>]\=\|<\%(<\|=>\=\)\=\|[+\-~]@\=\|\*\*\=\|\[]=\=\|![@=~]\=\)\)/ contained contains=rubySymbolStart nextgroup=@rubyAliases skipwhite
syn match rubyGlobalVariableAlias /\%#=1\$\%([^\x00-\x40\x5B-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*\|-\w\)/ contained nextgroup=@rubyAliases skipwhite
syn match rubyMethodAlias /\%#=1\%([^\x00-\x5E`\x7B-\x7F][^\x00-\x2F\x3A-\x40\x5B-\x5E`\x7B-\x7F]*[?!=]\=\|\%([&|^/%]\|=\%(==\=\|\~\)\|>[=>]\=\|<\%(<\|=>\=\)\=\|[+\-~]@\=\|\*\*\=\|\[]=\=\|![@=~]\=\)\)/ contained nextgroup=@rubyAliases skipwhite

syn keyword rubyPostfixKeyword and or then if unless while until contained
syn keyword rubyPostfixKeyword rescue contained nextgroup=rubyHashKey,rubyOperator skipwhite skipempty
syn keyword rubyPostfixKeyword in contained nextgroup=rubyHashKey skipwhite

syn keyword rubyKeyword BEGIN END

syn region rubyBlockParameters matchgroup=rubyDelimiter start=/\%#=1|/ end=/\%#=1|/ transparent contained
" }}}2

" Highlighting {{{1
hi def link rubyComment Comment
hi def link rubyLineComment rubyComment
hi def link rubyTodo Todo
hi def link rubyOperator Operator
hi def link rubyUnaryOperator rubyOperator
hi def link rubyRangeOperator rubyOperator
hi def link rubyMethodOperator rubyOperator
hi def link rubyNamespaceOperator rubyOperator
hi def link rubyDelimiter Delimiter
hi def link rubyInstanceVariable Identifier
hi def link rubyGlobalVariable Identifier
hi def link rubyConstant Identifier
hi def link rubyHashKey rubySymbol
hi def link rubyNil Constant
hi def link rubyBoolean Boolean
hi def link rubySelf Constant
hi def link rubySuper Constant
hi def link rubyNumber Number
hi def link rubyCharacter Character
hi def link rubyCharacterStart rubyDelimiter
hi def link rubyString String
hi def link rubyStringStart rubyDelimiter
hi def link rubyStringEnd rubyStringStart
hi def link rubyStringArray rubyString
hi def link rubyStringArrayDelimiter rubyDelimiter
hi def link rubyStringEscape SpecialChar
hi def link rubyStringEscapeError Error
hi def link rubyQuoteEscape rubyStringEscape
hi def link rubyStringInterpolationDelimiter rubyDelimiter
hi def link rubyParenthesisEscape rubyStringEscape
hi def link rubySquareBracketEscape rubyStringEscape
hi def link rubyCurlyBraceEscape rubyStringEscape
hi def link rubyAngleBracketEscape rubyStringEscape
hi def link rubyArrayEscape rubyStringEscape
hi def link rubyArrayParenthesisEscape rubyStringEscape
hi def link rubyArraySquareBracketEscape rubyStringEscape
hi def link rubyArrayCurlyBraceEscape rubyStringEscape
hi def link rubyArrayAngleBracketEscape rubyStringEscape
hi def link rubyHeredocLine String
hi def link rubyHeredocLineRaw rubyHeredocLine
hi def link rubyHeredocStart rubyHeredocLine
hi def link rubyHeredocEnd rubyHeredocStart
hi def link rubySymbol String
hi def link rubySymbolStart rubyDelimiter
hi def link rubySymbolEnd rubySymbolStart
hi def link rubySymbolArray rubySymbol
hi def link rubySymbolArrayDelimiter rubyDelimiter
hi def link rubyRegex String
hi def link rubyRegexStart rubyDelimiter
hi def link rubyRegexEnd rubyRegexStart
hi def link rubyOnigmoMetaCharacter SpecialChar
hi def link rubyOnigmoEscape rubyOnigmoMetaCharacter
hi def link rubyOnigmoQuantifier rubyOnigmoMetaCharacter
hi def link rubyOnigmoComment rubyComment
hi def link rubyOnigmoPOSIXClass rubyOnigmoMetaCharacter
hi def link rubyOnigmoIntersection rubyOnigmoMetaCharacter
hi def link rubyRegexSlashEscape rubyStringEscape
hi def link rubyCommand String
hi def link rubyCommandStart rubyDelimiter
hi def link rubyCommandEnd rubyCommandStart
hi def link rubyKeyword Keyword
hi def link rubyKeywordNoBlock rubyKeyword
hi def link rubyPostfixKeyword rubyKeyword
hi def link rubyDefine Define
hi def link rubyDefineNoBlock rubyDefine
hi def link rubyKeywordError Error
hi def link rubyMethodDefinition Function
hi def link rubyMethodReceiverVariable rubyVariableOrMethod
hi def link rubyMethodReceiverConstant rubyConstant
hi def link rubyMethodReceiverSelf rubySelf
hi def link rubyMethodReceiverDot rubyOperator
hi def link rubyMethodAssignmentOperator rubyOperator
hi def link rubyTypeDefinition Typedef
hi def link rubyTypeNamespace rubyOperator
hi def link rubySymbolAlias rubySymbol
hi def link rubyGlobalVariableAlias rubyGlobalVariable
hi def link rubyMethodAlias rubyMethodDefinition
hi def link rubyHashKeyDelimiter rubyDelimiter
hi def link rubyComma rubyDelimiter
hi def link rubyBackslash rubyDelimiter
hi def link rubySemicolon rubyDelimiter
" }}}1

let b:current_syntax = "ruby"

" vim:fdm=marker
