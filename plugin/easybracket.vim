" easybracket.vim: 自動括弧補完プラグイン。
" 
" The MIT License (MIT)
"
" Copyright (c) 2013 Ishibashi Hironori
"
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"),
" to deal in the Software without restriction, including without limitation
" the rights to use, copy, modify, merge, publish, distribute, sublicense,
" and/or sell copies of the Software, and to permit persons to whom
" the Software is furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included
" in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
" THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.
"
" 括弧やクオーテーションを補完する。
" 閉じ括弧や閉じクオートを二重に書かないようにする。
" ビジュアルモードで選択範囲を括弧やクオートなどで括る。
"
" ビジュアルモードで選択範囲を括弧やクオートなどで括るプラグインのキー。
" <Plug>EasyBracket_EncloseWithParentheses: デフォルトで<Leader>(
" <Plug>EasyBracket_EncloseWithBraces: デフォルトで<Leader>{
" <Plug>EasyBracket_EncloseWithSquareBrackets: デフォルトで<Leader>[
" <Plug>EasyBracket_EncloseWithApostrophe: デフォルトで<Leader>a
" <Plug>EasyBracket_EncloseWithQuote: デフォルトで<Leader>q

if exists("did_easybracket_on")
    finish
endif
let did_easybracket_on = 1

" 閉じ括弧を自動で補完する。===================================================
" 括弧の回数を記録する変数。
let s:count_parenthesis = 0
let s:count_brace = 0
let s:count_bracket = 0
let s:count_apostrophe = 0
let s:count_quote = 0

" 次の文字を取得するプライベート関数。
function s:GetNextChar()
    let l:text = getline(".")
    let l:next_pos = col(".") - 1
    return l:text[l:next_pos]
endfunction
" 前の文字を取得するプライベート関数。
function s:GetPrevChar()
    let l:text = getline(".")
    let l:prev_pos = col(".") -2
    return l:text[l:prev_pos]
endfunction

" 丸括弧の制御。
function <SID>DoOpenParenthesis()
    let s:count_parenthesis += 1
    return "()\<LEFT>"
endfunction
function <SID>DoCloseParenthesis()
    let l:next_char = s:GetNextChar()
    if (s:count_parenthesis > 0) && (s:GetNextChar() == ")")
        let s:count_parenthesis -= 1
        return "\<RIGHT>"
    else
        return ")"
    endif
endfunction

" 中括弧の制御。
function <SID>DoOpenBrace()
    let s:count_brace += 1
    return "{}\<LEFT>"
endfunction
function <SID>DoCloseBrace()
    if (s:count_brace > 0) && (s:GetNextChar() == "}")
        let s:count_brace -= 1
        return "\<RIGHT>"
    else
        return "}"
    endif
endfunction

" 角括弧の制御。
function <SID>DoOpenBracket()
    let s:count_bracket += 1
    return "[]\<LEFT>"
endfunction
function <SID>DoCloseBracket()
    if (s:count_bracket > 0) && (s:GetNextChar() == "]")
        let s:count_bracket -= 1
        return "\<RIGHT>"
    else
        return "]"
    endif
endfunction

" アポストロフィの制御。
function <SID>DoApostrophe()
    if (s:count_apostrophe > 0) && (s:GetNextChar() == "'")
        let s:count_apostrophe -= 1
        return "\<RIGHT>"
    else
        let s:count_apostrophe += 1
        return "''\<LEFT>"
    endif
endfunction

" クオートの制御。
function <SID>DoQuote()
    if (s:count_quote > 0) && (s:GetNextChar() == "\"")
        let s:count_quote -= 1
        return "\<RIGHT>"
    else
        let s:count_quote += 1
        return "\"\"\<LEFT>"
    endif
endfunction

" バックスペースの制御。
function <SID>DoBS()
    let l:next_char = s:GetNextChar()
    let l:prev_char = s:GetPrevChar()
    if (l:prev_char == "(" && l:next_char == ")" && s:count_parenthesis > 0)
    \|| (l:prev_char == "{" && l:next_char == "}" && s:count_brace > 0)
    \|| (l:prev_char == "[" && l:next_char == "]" && s:count_bracket > 0)
    \|| (l:prev_char == "'" && l:next_char == "'" && s:count_apostrophe > 0)
    \|| (l:prev_char == "\"" && l:next_char == "\"" && s:count_quote > 0)
        if l:prev_char == "("
            let s:count_parenthesis -= 1
        endif
        if l:prev_char == "{"
            let s:count_brace -= 1
        endif
        if l:prev_char == "["
            let s:count_bracket -= 1
        endif
        if l:prev_char == "'"
            let s:count_apostrophe -= 1
        endif
        if l:prev_char == "\""
            let s:count_quote -= 1
        endif
        return "\<Del>\<BS>"
    else
        return "\<BS>"
endfunction

" エスケープを押したときの制御。
" 挿入モードを抜けるときは変数をリセットする。
function <SID>DoESC()
    let s:count_parenthesis = 0
    let s:count_brace = 0
    let s:count_bracket = 0
    let s:count_apostrophe = 0
    let s:count_quote = 0
    return "\<ESC>"
endfunction

" 丸括弧をマップ。
inoremap <expr> ( <SID>DoOpenParenthesis()
inoremap <expr> ) <SID>DoCloseParenthesis()

" 中括弧をマップ。
inoremap <expr> { <SID>DoOpenBrace()
inoremap <expr> } <SID>DoCloseBrace()

" 角括弧をマップ。
inoremap <expr> [ <SID>DoOpenBracket()
inoremap <expr> ] <SID>DoCloseBracket()

" アポストロフィをマップ。
inoremap <expr> ' <SID>DoApostrophe()

" クオートをマップ。
inoremap <expr> " <SID>DoQuote()

" バックスペースをマップ。
inoremap <expr> <BS> <SID>DoBS()
inoremap <expr> <C-h> <SID>DoBS()

" 挿入モードを抜けるときのマップ。
inoremap <expr> <ESC> <SID>DoESC()

" 選択範囲を括弧やクオーテーションで括る。=====================================
" 括弧で括る。
function <SID>EncloseWithParentheses() range
    let l:start_pos = getpos("'<")
    let l:end_pos = getpos("'>")
    execute ":normal \<ESC>"

    call setpos(".", l:start_pos)
    execute ":normal i()\<BS>"

    call setpos(".", l:end_pos)
    if l:start_pos[1] == l:end_pos[1]
        execute ":normal l"
    endif
    execute ":normal a)"
    let l:end_pos[2] = col(".")

    if visualmode() == "V"
        let l:end_pos[2] = col("$")
    endif

    call setpos(".", l:start_pos)
    execute ":normal v"
    call setpos(".", l:end_pos)
endfunction

" 中括弧で括る。
function <SID>EncloseWithBraces() range
    let l:start_pos = getpos("'<")
    let l:end_pos = getpos("'>")
    execute ":normal \<ESC>"

    call setpos(".", l:start_pos)
    execute ":normal i{}\<BS>"

    call setpos(".", l:end_pos)
    if l:start_pos[1] == l:end_pos[1]
        execute ":normal l"
    endif
    execute ":normal a}"
    let l:end_pos[2] = col(".")

    if visualmode() == "V"
        let l:end_pos[2] = col("$")
    endif

    call setpos(".", l:start_pos)
    execute ":normal v"
    call setpos(".", l:end_pos)
endfunction

" 角括弧で括る。
function <SID>EncloseWithSquareBrackets() range
    let l:start_pos = getpos("'<")
    let l:end_pos = getpos("'>")
    execute ":normal \<ESC>"

    call setpos(".", l:start_pos)
    execute ":normal i[]\<BS>"

    call setpos(".", l:end_pos)
    if l:start_pos[1] == l:end_pos[1]
        execute ":normal l"
    endif
    execute ":normal a]"
    let l:end_pos[2] = col(".")

    if visualmode() == "V"
        let l:end_pos[2] = col("$")
    endif

    call setpos(".", l:start_pos)
    execute ":normal v"
    call setpos(".", l:end_pos)
endfunction

" アポストロフィで括る。
function <SID>EncloseWithApostrophe() range
    let l:start_pos = getpos("'<")
    let l:end_pos = getpos("'>")
    execute ":normal \<ESC>"

    call setpos(".", l:start_pos)
    execute ":normal i''\<BS>"

    call setpos(".", l:end_pos)
    if l:start_pos[1] == l:end_pos[1]
        execute ":normal l"
    endif
    execute ":normal a''\<BS>"
    let l:end_pos[2] = col(".")

    if visualmode() == "V"
        let l:end_pos[2] = col("$")
    endif

    call setpos(".", l:start_pos)
    execute ":normal v"
    call setpos(".", l:end_pos)
endfunction

" クオートで括る。
function <SID>EncloseWithQuote() range
    let l:start_pos = getpos("'<")
    let l:end_pos = getpos("'>")
    execute ":normal \<ESC>"

    call setpos(".", l:start_pos)
    execute ":normal i\"\"\<BS>"

    call setpos(".", l:end_pos)
    if l:start_pos[1] == l:end_pos[1]
        execute ":normal l"
    endif
    execute ":normal a\"\"\<BS>"
    let l:end_pos[2] = col(".")

    if visualmode() == "V"
        let l:end_pos[2] = col("$")
    endif

    call setpos(".", l:start_pos)
    execute ":normal v"
    call setpos(".", l:end_pos)
endfunction

" プラグインのマップを作る。
vnoremap <unique> <script> <Plug>EasyBracket_EncloseWithParentheses :call <SID>EncloseWithParentheses()<CR>
vnoremap <unique> <script> <Plug>EasyBracket_EncloseWithBraces :call <SID>EncloseWithBraces()<CR>
vnoremap <unique> <script> <Plug>EasyBracket_EncloseWithSquareBrackets :call <SID>EncloseWithSquareBrackets()<CR>
vnoremap <unique> <script> <Plug>EasyBracket_EncloseWithApostrophe :call <SID>EncloseWithApostrophe()<CR>
vnoremap <unique> <script> <Plug>EasyBracket_EncloseWithQuote :call <SID>EncloseWithQuote()<CR>

" デフォルトのマップを作る。
if !hasmapto("<plug>EasyBracket_EncloseWithParenthesis")
    vmap <Leader>( <Plug>EasyBracket_EncloseWithParentheses
endif
if !hasmapto("<plug>EasyBracket_EncloseWithBrace")
    vmap <Leader>{ <Plug>EasyBracket_EncloseWithBraces
endif
if !hasmapto("<plug>EasyBracket_EncloseWithSquareBracket")
    vmap <Leader>[ <Plug>EasyBracket_EncloseWithSquareBrackets
endif
if !hasmapto("<plug>EasyBracket_EncloseWithApostrophe")
    vmap <Leader>a <Plug>EasyBracket_EncloseWithApostrophe
endif
if !hasmapto("<plug>EasyBracket_EncloseWithQuote")
    vmap <Leader>q <Plug>EasyBracket_EncloseWithQuote
endif
