# neovim-config
Personal neovim configuration  

This is my personal neovim configuration. Feel free to fork, copy, or steal it.

## Optional External Apps to improve plugins

Stupidly I have not kept track on exactly what is needed but these include
these are the ones I am currently aware of.

- ripgrep (if you want live\_grep functionalit from telescope)
- fzf (used to improve telescope functionality)
- bat (used to improve telescope preview)
- nodejs and npm (I think this is used by treesitter)
- ctags (needed for tagbar but is very slow on windows so you might skip it)

## Optional Plugin Setup  

Some plugins work better with some extra manual setup. These are the ones I am
currently aware of.

- `:TSInstall` Installs language specific stuff for treesitter, eg. `:TSInstall lua`
  to get better treesitter functionality for lua files.

