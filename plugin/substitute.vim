" 
" substitute.vim -- mappings for using the s/// command on the word under the cursor
"
" Author:  Anders Thøgersen <anders [at] bladre.dk>
" Date:    2009-03-03
" Version: 1.1
"
" $Id: substitute.vim 266 2009-03-03 15:05:50Z alt $
"
" See substitute.txt for help
"
" GetLatestVimScripts: 1167 1 :AutoInstall: substitute.vba.gz
" 

if exists('loaded_substitute') || &cp
  finish
endif
let loaded_substitute = 1

let s:savedCpo = &cpoptions
set cpoptions&vim

" Configuration
if !exists("g:substitute_PromptMap")
	let g:substitute_PromptMap = ";'"
endif
if !exists("g:substitute_NoPromptMap")
	let g:substitute_NoPromptMap = ';;'
endif
if !exists("g:substitute_Register")
	let g:substitute_Register = '9'
endif
     
" define the mappings 
exe 'nnoremap <unique> '. g:substitute_NoPromptMap .' yiw:let @'. g:substitute_Register ."=':%'.<SID>SubstituteAltSubst(@\", 'g')<Cr>@". g:substitute_Register
exe 'nnoremap <unique> '. g:substitute_PromptMap   .' yiw:let @'. g:substitute_Register ."=':%'.<SID>SubstituteAltSubst(@\", 'gc')<Cr>@". g:substitute_Register
exe 'vnoremap <unique> '. g:substitute_NoPromptMap .' <ESC>gvy:let @'. g:substitute_Register ."=<SID>SubstituteVisualAltSubst(@\", 'g')<Cr>@". g:substitute_Register
exe 'vnoremap <unique> '. g:substitute_PromptMap   .' <ESC>gvy:let @'. g:substitute_Register ."=<SID>SubstituteVisualAltSubst(@\", 'gc')<Cr>@". g:substitute_Register
cnoremap <unique> <C-R><C-R> <C-R>"

" Remove the default key sequences
unlet g:substitute_Register
unlet g:substitute_PromptMap
unlet g:substitute_NoPromptMap

fun! <SID>SubstituteAltSubst(txt, flags)
	let d = <SID>GetSubstDelimiter(a:txt)
	exe "let left = '\<Left>'"
    let mv = left . left
	if a:flags == 'gc'
		let mv = mv . left 
	endif
	if strlen(a:txt)==0
		let mv = mv . left
	endif
	let @" = <SID>Escape(a:txt) 
	return 's' .d . @" .d .d . a:flags . mv 
endfun

fun! <SID>SubstituteVisualAltSubst(txt, flags)
	exe "let left = '\<Left>'"
	let mv = left . left . left
	if a:flags == 'gc'
		let mv = mv . left 
	endif
	if line("'<")!=line("'>") || (line("'<")==line("'>") && col("'<")==1 && col("'>")==col("$"))
		let d = <SID>GetSubstDelimiter(a:txt)
		return ":'<,'>s" .d .d .d . a:flags . mv
	else
		return ':%' . <SID>SubstituteAltSubst(a:txt, a:flags)	
	endif
endfun

" feel free to add more :-)
fun! <SID>GetSubstDelimiter(txt)
	if stridx(a:txt, '/') == -1
		return '/'
	elseif stridx(a:txt, ':') == -1
		return ':'
	elseif stridx(a:txt, '#') == -1
		return '#'
	elseif stridx(a:txt, ';') == -1
		return ';'
	elseif stridx(a:txt, '~') == -1
		return '~'
	elseif stridx(a:txt, '!') == -1
		return '!'
	else 
		return '*'
	endif
endfun

" escape as little as possible
fun! <SID>Escape(txt)
	let esc = '\\.~[]'
	if stridx(a:txt, '$') == (strlen(a:txt) -1)
		let esc = esc . '$'
	endif
	if stridx(a:txt, '^') == 0
		let esc = esc . '^'
	endif
	if stridx(a:txt, '*') > 0
		let esc = esc . '*'
	endif
	return escape(a:txt, esc)
endfun

let &cpoptions = s:savedCpo

