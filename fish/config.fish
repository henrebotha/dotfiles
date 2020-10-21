set fish_greeting "Welcome back, Commander."
set fish_term24bit 0

function prompt_pwd --description 'Display at most the last 3 dirs of the pwd'
  set trunc (pwd | sed 's/^\///' | rev | cut -d/ -f1-3 | rev)
  if test (pwd | grep -o '/' | wc -l) -gt 3
    echo (set_color green)"…"(set_color yellow)"/$trunc"
  else
    echo (set_color yellow)"/$trunc"
  end
end

function fish_prompt --description 'Write out the prompt'
  set -l date_string (date +'%Y-%m-%d %H:%M:%S')
  set -l git_string (
    if git -C . rev-parse ^ /dev/null; and git rev-parse --abbrev-ref HEAD > /dev/null ^ /dev/null
      git rev-parse --abbrev-ref HEAD
    else
      echo ""
    end
  )
  set -l username (whoami)
  set -l prompt_char "»"
  set -l last_status $status
  # TODO: this function doesn't work
  function set_prompt_color
    set_color cyan
    # if test $last_status -eq 0
    #   set_color cyan
    # else
    #   set_color red
    # end
  end
  echo "$date_string "(set_color magenta)"$username "(set_color normal)(prompt_pwd)(set_color green)" $git_string " (set_color normal) "
"(set_prompt_color)"$prompt_char "(set_color normal)
end

# Workaround for multiline prompt issues: https://github.com/fish-shell/fish-shell/issues/3481
function fish_vi_cursor; end

set -g EDITOR "mvim -v"

# Enable rbenv
# https://github.com/rbenv/rbenv/issues/195#issuecomment-6168636
set PATH $PATH $HOME/.rbenv/bin
set PATH $PATH $HOME/.rbenv/shims
rbenv rehash >/dev/null ^&1

# Fix yarn binary issue https://github.com/yarnpkg/yarn/issues/648
# Do `yarn global bin` to get the path
set PATH $PATH /usr/local/Cellar/node/8.2.1/bin

function cmd; functions $argv; end

function g; git $argv; end
# Shortcuts for hiding changes from git (e.g. so that we can override configs
# in dev without risk of committing them by accident).
function ghide; git update-index --skip-worktree $argv; end
function gunhide; git update-index --no-skip-worktree $argv; end
function ghidden; git ls-files -v . | grep ^S $argv; end

function emacs; /usr/local/Cellar/emacs-plus/25.1/Emacs.app/Contents/MacOS/Emacs -nw $argv; end
function vim; mvim -v $argv; end
function v; mvim -v $argv; end

function t; tree -L $argv; end

function tx; tmuxinator s $argv; end
function txe; tmuxinator new $argv; end
function ta; tmux a -t $argv; end
function tai; tmux new-session -t $argv; end # mnemonic: "tmux attach independent"
function tk; tmux kill-session -t $argv; end
function tl; tmux ls $argv; end
function tn; tmux new-session -s $argv; end

function elmc; elm-repl $argv; end
function elmr; elm-reactor $argv; end
function elmm; elm-make $argv; end
function elmp; elm-package $argv; end

function mvnq; mvn -q $argv; end

# function s; . ~/.zshrc $argv; end

function swine; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wine $argv; end
function swine64; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wine64 $argv; end
function swineboot; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wineboot $argv; end
# function swinebuild; winebuild $argv; end
function swinecfg; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winecfg $argv; end
function swineconsole; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wineconsole $argv; end
# function swinecpp; winecpp $argv; end
function swinedbg; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winedbg $argv; end
# function swinedump; winedump $argv; end
function swinefile; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winefile $argv; end
# function swineg++; wineg++ $argv; end
# function swinegcc; winegcc $argv; end
# function swinemaker; winemaker $argv; end
function swinemine; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winemine $argv; end
function swinepath; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/winepath $argv; end
function swineserver; /Applications/Wine\ Staging.app/Contents/Resources/wine/bin/wineserver $argv; end
# function swinetricks; winetricks $argv; end

# function hybrid_bindings --description "Vi-style bindings that inherit emacs-style bindings in all modes"
#   for mode in default insert visual
#     fish_default_key_bindings -M $mode
#   end
#   fish_vi_key_bindings --no-erase
# end
# set -g fish_key_bindings hybrid_bindings
# https://fedragon.github.io/vimode-fishshell-osx/
set -g fish_key_bindings fish_vi_key_bindings

# Prevent reading fast Esc > B as Esc+B
set fish_escape_delay_ms 10

function cdl --description "List folder contents after cd"
  cd $argv
  ls -la
end

# A lovely script that watches files for changes and automatically commits them
# to git. Nice to use for note-taking.
# TODO: Test fish compatibility
function autocommit --description "Watches files for changes and automatically commits them to git"
  # commit any changes since last run
  date +%Y-%m-%dT%H:%M:%S%z
  git add $argv
  git commit -m "AUTOCOMMIT"
  echo
  # now commit changes whenever files are saved
  fswatch -0 $argv | xargs -0 -n 1 sh -c "date +%Y-%m-%dT%H:%M:%S%z; git add .; git commit -m \"AUTOCOMMIT\"; echo"
end

# Whenever a command is not found, prompt the user to install it via homebrew.
# command_not_found_handler is a built-in Zsh hook, called automatically.
# TODO: Test fish compatibility
function command_not_found_handler
  echo "Command "$argv[1]" not found. Install it with b for brew, g for gem, n for npm."
  read -sk answer
  if $answer = "b"; or $answer = "B"
    echo "brew install "$argv[1]
    brew install $argv[1]
  else if $answer = "g"; or $answer = "G"
    echo "gem install "$argv[1]
    gem install $argv[1]
  else if $answer = "n"; or $answer = "N"
    echo "npm install "$argv[1]
    npm install -g $argv[1]
  end
end

# # fzf keybinds/completion
# [ -f ~/.fzf.zsh ] && . ~/.fzf.zsh

source ~/.dev
