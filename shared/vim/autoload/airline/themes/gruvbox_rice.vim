" ═══════════════════════════════════════════════════════════════
"  vim-airline theme — gruvbox_rice
"
"  Matches sketchybar, tmux and starship exactly:
"    accent  #fabd2f   base #1d2021   surface #3c3836   chip #504945
"
"  Mode drives the colour of section A:
"    normal yellow · insert blue · visual orange · replace red · term green
"
"  Lives in ~/.vim/autoload/airline/themes/ so plugin updates
"  never clobber it.
" ═══════════════════════════════════════════════════════════════
scriptencoding utf-8

let g:airline#themes#gruvbox_rice#palette = {}
let s:p = g:airline#themes#gruvbox_rice#palette

" [ guifg, guibg, ctermfg, ctermbg ]
let s:base   = ['#1d2021', 234]
let s:chip   = ['#ebdbb2', '#504945', 223, 239]
let s:panel  = ['#ebdbb2', '#3c3836', 223, 237]

" ── normal ─────────────────────────────────────────────────────
let s:N1 = ['#1d2021', '#fabd2f', 234, 214]
let s:N2 = s:chip
let s:N3 = s:panel
let s:p.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let s:p.normal_modified = {
      \ 'airline_c': ['#fe8019', '#3c3836', 208, 237, ''] }

" ── insert ─────────────────────────────────────────────────────
let s:I1 = ['#1d2021', '#83a598', 234, 109]
let s:p.insert = airline#themes#generate_color_map(s:I1, s:chip, s:panel)
let s:p.insert_modified = s:p.normal_modified

" ── replace ────────────────────────────────────────────────────
let s:R1 = ['#1d2021', '#fb4934', 234, 167]
let s:p.replace = airline#themes#generate_color_map(s:R1, s:chip, s:panel)
let s:p.replace_modified = s:p.normal_modified

" ── visual ─────────────────────────────────────────────────────
let s:V1 = ['#1d2021', '#fe8019', 234, 208]
let s:p.visual = airline#themes#generate_color_map(s:V1, s:chip, s:panel)
let s:p.visual_modified = s:p.normal_modified

" ── terminal ───────────────────────────────────────────────────
let s:T1 = ['#1d2021', '#b8bb26', 234, 142]
let s:p.terminal = airline#themes#generate_color_map(s:T1, s:chip, s:panel)

" ── inactive splits: drop to muted grey ────────────────────────
let s:IA = ['#928374', '#282828', 245, 235, '']
let s:p.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)
let s:p.inactive_modified = {
      \ 'airline_c': ['#928374', '', 245, '', ''] }

" ── tabline ────────────────────────────────────────────────────
let s:p.tabline = {
      \ 'airline_tab':     ['#a89984', '#3c3836', 246, 237, ''],
      \ 'airline_tabsel':  ['#1d2021', '#fabd2f', 234, 214, 'bold'],
      \ 'airline_tabtype': ['#1d2021', '#8ec07c', 234, 108, 'bold'],
      \ 'airline_tabfill': ['#ebdbb2', '#282828', 223, 235, ''],
      \ 'airline_tabmod':  ['#1d2021', '#fe8019', 234, 208, 'bold'],
      \ 'airline_tabhid':  ['#665c54', '#282828', 241, 235, ''],
      \ }

" ── accents: warnings, errors, coc diagnostics ─────────────────
let s:WARN = ['#1d2021', '#fabd2f', 234, 214, '']
let s:ERR  = ['#1d2021', '#fb4934', 234, 167, '']

for s:mode in ['normal', 'insert', 'replace', 'visual', 'terminal']
  let s:p[s:mode].airline_warning = s:WARN
  let s:p[s:mode].airline_error   = s:ERR
endfor

let s:p.normal.airline_term = s:panel + ['']
