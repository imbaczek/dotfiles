" Tim's .vimrc

" -----------------------------------------------------------------
" SYSTEM INSPECTION {{{
" -----------------------------------------------------------------

" sometimes it's useful to know what we're running on
let OS=substitute(system('uname -s'),"\n","","")

" }}}
" -----------------------------------------------------------------
" VIM-PLUG {{{
" -----------------------------------------------------------------

" download vim-plug if missing
if empty(glob("~/.vim/autoload/plug.vim"))
  silent! execute '!curl --create-dirs -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * silent! PlugInstall
endif

" declare plugins
silent! if plug#begin()

  Plug 'airblade/vim-gitgutter'
  Plug 'c9s/perlomni.vim', { 'for': 'perl' }
  Plug 'ervandew/supertab'
  Plug 'junegunn/vim-easy-align'
  Plug 'kien/ctrlp.vim'
  Plug 'michaeljsmith/vim-indent-object'
  Plug 'rking/ag.vim'
  Plug 'stephpy/vim-yaml'
  Plug 'thelocehiliosan/vim-byrne'
  Plug 'thelocehiliosan/vim-json'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-fugitive'
  Plug 'tpope/vim-jdaddy'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'vim-scripts/vis'

  " ignore these on older versions of vim
  if v:version >= 703
    Plug 'gerw/vim-HiLinkTrace'
    Plug 'gorodinskiy/vim-coloresque'
    Plug 'guns/xterm-color-table.vim'
    Plug 'jamessan/vim-gnupg'
    Plug 'toyamarinyon/vim-swift'
    Plug 'uguu-org/vim-matrix-screensaver'
    Plug 'yegappan/mru'
  endif

  " some plugins for the future?
  " Plug 'junegunn/vim-peekaboo'  -- conflicts with some things, not sure why
  " Plug 'Valloric/YouCompleteMe' -- requires newer vim, future perhaps?
  " Plug 'scrooloose/syntastic'   -- possibly used for perl and puppet?
  " Plug 'airblade/vim-gitgutter' -- perhaps use this in the future?
  " Plug 'ajh17/VimCompletesMe'   -- not supported yet, but promising

  call plug#end()
endif

" }}}
" -----------------------------------------------------------------
" BASIC SETTINGS {{{
" -----------------------------------------------------------------

" don't clear the screen on exit
set t_ti= t_te=

" enable syntax highlighting (where applicable)
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" color scheme
set background=dark
set t_Co=256
silent! colorscheme byrne
highlight Comment cterm=italic

" tabstop=2 master-race unite!
set tabstop=2
set shiftwidth=2

" indentation
set autoindent
set shiftround

" use spaces instead of tabs
set expandtab

" only one space after sentences (i am reformed)
set nojoinspaces

" vertically split to the right 
set splitright

" give vim a good memory
set history=500

" ensure we process modelines
set modelines=5

" utf-8—like a sane person
set encoding=utf-8

" add `kspell` to completion (use dictionary only when spelling is enabled)
set complete=.,w,b,u,t,kspell

" wildmode similar to bash
set wildmode=longest,list

" allow block selection to go outside of the actual text
set virtualedit=block

" remove the standard Vim :intro message
set shortmess+=I

" }}}
" -----------------------------------------------------------------
" MAPPINGS {{{
" -----------------------------------------------------------------

" column-minded editing
nnoremap <leader>7 :set tw=70<cr>:set colorcolumn=70<cr>
nnoremap <leader>8 :set tw&<cr>:set colorcolumn&<cr>

" checkboxes
inoreabbrev cbox ☐
nnoremap <leader>cbo s☐<esc>
nnoremap <leader>cbx s☒<esc>
nnoremap <leader>cbm s☑<esc>
nnoremap <leader>cba s⇉<esc>
nnoremap <leader>cm s✓<esc>

" git diffs during commits
nnoremap <leader>gg :silent new diff.staged \| :set filetype=git-diff \| :r! git diff --cached -p --stat<cr>:se ro<cr>:set nospell \| :goto 1<cr>
nnoremap <leader>gG :silent new diff.unstaged \| :set filetype=git-diff \| :r! git diff -p --stat<cr>:se ro<cr>:set nospell \| :goto 1<cr>
nnoremap <leader>gt :silent tab new diff.staged \| :set filetype=git-diff \| :r! git diff --cached -p --stat<cr>:se ro<cr>:set nospell \| :goto 1<cr>
nnoremap <leader>gT :silent tab new diff.unstaged \| :set filetype=git-diff \| :r! git diff -p --stat<cr>:se ro<cr>:set nospell \| :goto 1<cr>

" kill ANSI codes
nnoremap <leader>ka :%s/\%d027[[0-9\;]\+m//g<cr>

" kill trailing spaces
nnoremap <leader>k<space> :%s/ \+$//g<cr>

" quick spelling corrections 
" - ^gu (break the undo sequence)
" - [s (jump to last mistake)
" - 1z= (choose first correction)
" - `] (jump to last insert)
" - a (append)
" - ^o (jump to last position in jump list)
inoremap <c-f> <c-g>u<esc>[s1z=`]a<c-g>u
nnoremap <c-f> [s1z=<c-o>

" sort in visual using tab
vnoremap <tab> :sort<cr>

" quick fold toggling
nnoremap <tab> za

" bullet extract (for status notes)
nnoremap <leader>be :normal mx<cr> \| :let @a="" \| :'<,'>g/^-/yank A \| :nohlsearch \| :normal `x<cr> \| :normal "apdd<cr>

" quick tab navigation and preserve H/L using gH/gL (and add gM for consistency)
nnoremap H gT
nnoremap L gt
nnoremap gH H
nnoremap gL L
nnoremap gM M

" toggle wrap on all windows
map <leader>wa :windo set wrap!<cr>

" reset scroll value with <leader>
nnoremap <leader><c-u> :set scroll=0<cr><c-u>
nnoremap <leader><c-d> :set scroll=0<cr><c-d>

" remove search highlighting with ^L (while preserving ^L)
nnoremap <c-l> :nohlsearch<cr><c-l>

" make ^p/^n work like arrow keys in command mode
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" remote pbcopy
vnoremap <leader>rc <esc> \| :silent '<,'>:w !rpbcopy<cr>
nnoremap <leader>rc :silent %:w !rpbcopy<cr>

" open Marked 2
function! Marked()
  write
  silent !marked --open %
  augroup marked
    au!
    au BufWritePost * :silent !marked %
  augroup END
endfunction
nnoremap <leader>m :call Marked()<cr>
vnoremap <leader>m <esc> \| :silent '<,'>:w !marked --open<cr>

function! RebaseCommandMaps()
  let b:git_rebase_words="pick|reword|edit|squash|fixup|exec"
  nnoremap <buffer> K :s/\v^<c-r>=b:git_rebase_words<cr>/pick/<cr>:nohlsearch<cr>
  nnoremap <buffer> R :s/\v^<c-r>=b:git_rebase_words<cr>/reword/<cr>:nohlsearch<cr>
  nnoremap <buffer> E :s/\v^<c-r>=b:git_rebase_words<cr>/edit/<cr>:nohlsearch<cr>
  nnoremap <buffer> S :s/\v^<c-r>=b:git_rebase_words<cr>/squash/<cr>:nohlsearch<cr>
  nnoremap <buffer> F :s/\v^<c-r>=b:git_rebase_words<cr>/fixup/<cr>:nohlsearch<cr>
  nnoremap <buffer> X :s/\v^<c-r>=b:git_rebase_words<cr>/exec/<cr>:nohlsearch<cr>
endfunction
autocmd FileType gitrebase call RebaseCommandMaps()

" }}}
" -----------------------------------------------------------------
" AUTOCMD {{{
" -----------------------------------------------------------------

" keywords for special types
autocmd FileType vim  set keywordprg=:help
autocmd FileType perl set keywordprg=perldoc\ -f

" no textwidth for text files
autocmd BufRead *.txt set textwidth=0

" preserve <tab> in makefiles
autocmd FileType make set noexpandtab

" auto spelling for markdown
autocmd FileType mkd set spell

" enforce formatting/spelling for git commit messages
autocmd FileType gitcommit set tw=72 lbr spell

" comment wrapping type stuff
autocmd FileType * setlocal formatoptions-=r formatoptions+=o
autocmd FileType perl set comments=:#;,:#
autocmd FileType perl set commentstring=#;\ %s
autocmd FileType perl set textwidth=75
autocmd FileType perl setlocal formatoptions-=t
autocmd FileType perl let g:tcomment_types = { 'myperl' : '#; %s' }

" when editing a file, always jump to the last known cursor position
autocmd BufReadPost *
  \ if line("'\"") > 1 && line("'\"") <= line("$") |
  \   execute "normal! g`\"" |
  \ endif

" handle svn stuff (unless we're on a mac)
if (OS != "Darwin")
  " SVN Command plugin
  let SVNCommandEdit='split'
  autocmd BufNewFile,BufRead  svn-commit.* setfiletype svn
  autocmd FileType svn nnoremap <leader>sd :SVNCommitDiff<cr>
endif

" }}}
" -----------------------------------------------------------------
" PLUGIN CONFIGURATIONS {{{
" -----------------------------------------------------------------

" JSON syntax highlighting
" prevent json content from jumping all over the place
let g:vim_json_syntax_conceal = 0
" allow comment highlighting
let g:vim_json_comments = 1

" EasyAlign
" start interactive EasyAlign in visual mode (e.g. vip<enter>)
vmap <enter> <Plug>(EasyAlign)
" start interactive EasyAlign for a motion/text object (e.g. <leader>aip)
nmap <leader>a <Plug>(EasyAlign)

" }}}
" -----------------------------------------------------------------
" ABBREVIATIONS {{{
" -----------------------------------------------------------------

inoreabbrev lod ಠ_ಠ
inoreabbrev sadface ʘ︵ʘ
inoreabbrev tmyk ⋯-=≡★ ♪ The More You Know… ♫
inoreabbrev tdate <c-r>=strftime("%Y-%m-%d")<cr>
inoreabbrev lorem Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam. Sed nisi. Nulla quis sem at nibh elementum imperdiet. Duis sagittis ipsum. Praesent mauris. Fusce nec tellus sed augue semper porta. Mauris massa. Vestibulum lacinia arcu eget nulla.<cr><cr>Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Curabitur sodales ligula in libero. Sed dignissim lacinia nunc. Curabitur tortor. Pellentesque nibh. Aenean quam. In scelerisque sem at dolor. Maecenas mattis. Sed convallis tristique sem. Proin ut ligula vel nunc egestas porttitor. Morbi lectus risus, iaculis vel, suscipit quis, luctus non, massa. Fusce ac turpis quis ligula lacinia aliquet. Mauris ipsum. Nulla metus metus, ullamcorper vel, tincidunt sed, euismod in, nibh.<cr><cr>Quisque volutpat condimentum velit. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Nam nec ante. Sed lacinia, urna non tincidunt mattis, tortor neque adipiscing diam, a cursus ipsum ante quis turpis. Nulla facilisi. Ut fringilla. Suspendisse potenti. Nunc feugiat mi a tellus consequat imperdiet. Vestibulum sapien. Proin quam. Etiam ultrices. Suspendisse in justo eu magna luctus suscipit. Sed lectus.

" }}}
" -----------------------------------------------------------------
" RETIRED {{{
" -----------------------------------------------------------------

" " display current syntax name (replaced with vim-HiLinkTrace)
" map <f4> :echo
"   \ "hi<" . synIDattr(synID(line("."),col("."),1),"name") .
"   \ '> trans<' . synIDattr(synID(line("."),col("."),0),"name") .
"   \ "> lo<" . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") .
"   \ ">"<cr>

" " Only show quick-scope highlights after f/F/t/T is pressed
" if v:version >= 703
"   Plug 'unblevable/quick-scope'
"   function! Quick_scope_selective(movement)
"     let needs_disabling = 0
"     if !g:qs_enable
"       QuickScopeToggle
"       redraw
"       let needs_disabling = 1
"     endif
"     let letter = nr2char(getchar())
"     if needs_disabling
"       QuickScopeToggle
"     endif
"     return a:movement . letter
"   endfunction
"   let g:qs_enable = 0
"   for i in  [ 'f', 'F', 't', 'T' ]
"     execute 'noremap <expr> <silent>' . i . " Quick_scope_selective('". i . "')"
"   endfor
" endif

" }}}
" -----------------------------------------------------------------
" TODO {{{
" -----------------------------------------------------------------

" Examine plugins for opprotunities for on-demand loading

" " auto indent my braces with CTRL-Enter
" inoremap {<cr> {<cr>}<esc>O<tab>

" " make [[, ]] work properly with cuddled braces
" nnoremap [[ ?\v^\S.*\{\n?e<cr>:nohlsearch<cr>
" nnoremap ][ /\v^\}\n<cr>:nohlsearch<cr>
" nmap ]] j0[[%/{<cr>
" nmap [] k$][%?}<cr>

" }}}
" -----------------------------------------------------------------
" MODELINES {{{
" -----------------------------------------------------------------

" vim: set foldmethod=marker :

" }}}

