# neovim-config
Personal neovim configuration  

This is my personal neovim configuration. Feel free to fork, copy, or steal it.

## Installation

1. Backup your old neovim configuration and then check out this directory in
   its place.  
    
    **Ex.**
    ```bash
    mv ~/.config/nvim ~/.config/old-nvim
    git clone https://github.com/Natr1x/neovim-config.git ~/.config/nvim
    ```
2. Run `:PackerInstall` from nvim. The first time (and maybe the second) you
   will probably see a lot of error. Do not worry, just restart nvim and
   run it again until they go away.


## Optional External Apps to improve plugins

Stupidly I have not kept track on exactly what is needed but these include
these are the ones I am currently aware of.

- Any NerdFont (This will probably look awful if you do not have extra icons)
- ripgrep (if you want live\_grep functionalit from telescope)
- fzf (used to improve telescope functionality)
- bat (used to improve telescope preview)
- nodejs and npm (I think this is used by treesitter and some other stuff.)
- ctags (needed for tagbar but is very slow on windows so you might skip it)

## Optional Plugin Setup  

Some plugins work better with some extra manual setup. These are the ones I am
currently aware of.

- `:TSInstall` Installs language specific stuff for treesitter, eg. `:TSInstall lua`
  to get better treesitter functionality for lua files.

## Testing  

Tests have far from 100% code coverage but some tests for the configs utility
lua scripts do exist. Hopefully I will add more...  

Regardless you can run them with:  
```bash
vim --headless -c "PlenaryBustedDirectory $(git rev-parse --show-toplevel) { minimal = true }"
```
