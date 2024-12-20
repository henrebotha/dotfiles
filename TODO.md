* ?: My whole Mac slows to a crawl while running all tests in Orchestrator, but _only_ if the terminal window is visible and not scrolling back in Tmux.
* Zsh: sandboxd supports "shims", to allow loading a binary if a sub-binary it installed is invoked (e.g. running `flask` should load Python). Go configure this.
* Zsh: fzf Alt-C switcher should keep going up if the repo it hits is a submodule.
* Zsh: Set up a proper way to handle optional config.
  * I don't want e.g. Elm-specific aliases to pollute my namespace unless I am "currently" working on Elm stuff on this machine. Thus, I need a mechanism to specify that I am currently working on Elm stuff on this machine.
  * I don't want to use comments in my dotfiles, because that's just going to mean every machine has a dirty working tree.
  * Set up a config file. Have dotfiles read the config file to determine what to enable. Set up a mechanism to create a template config if it doesn't already exist.
    * Extra nice would be if each topic has its own config, so that when I add a new one and propagate it to my machines, each one will create a new config file for that topic instead of skipping it because there's already a config. Although this will result in needing to clean up unused configs from time to time.
* Zsh/ssh: Something's messed up when I ssh into the Air from my work laptop.
  * Lines double up, backspace doesn't work, etc.
  * Could be a `$TERM` issue.
    * WMBP is xterm-256color.
    * WMBP Tmux is tmux-256color.
    * Air is xterm-256color.
    * Air Tmux is screen-256color.
  * Fixed Air Tmux to use tmux-256color (had to install manually [from here](https://gpanders.com/blog/the-definitive-guide-to-using-tmux-256color-on-macos/#fnref:2)). Now it's _mostly_ good.
* Git: Create a way to view diffs one file at a time.
  * Could be as simple as: List the files to diff; For each, show the diff.
* Zsh: Sandboxed binaries do not get loaded when we try to run a script using such a binary in its shebang.
  * For example, running a script `./index.js` throws an error unless we've run `yarn` or similar earlier to load in Node.
* Git: Figure out a nice way to automate the use of the ignore-revs file.
  * Something like a `[ignore rev]` tag in the commit message can be detected. Perhaps when we commit something, a post-commit hook runs, checks if we committed that tag, adds it to the ignore-revs file, and immediately commits that file. Take care not to somehow accidentally include merge commits that merge in tagged commits…
* Vim/Node: If I try and run Vim in a window where Node has not yet been sandboxed in, coc throws a js error.
  * One approach might be to force-load Node within specified directories (given that the Node topic is active). Could use direnv or something to flag the dirs. So it would load in every shell in that directory on that machine, which is obviously less good than perfect sandboxing, but at least means I don't have to worry about this.
  * Another approach is to tweak Vim specifically to sandbox in Node (again, given the topic). This could be combined with the per-directory approach so that it only happens on this machine, in this directory, when Vim is launched.
* Vim: Leader-f should ignore .gitignored files.
* zsh-abbr: Move the user config file into the fold.
  * It is located at `$ABBR_USER_ABBREVIATIONS_FILE`.
* Zsh: Improve host detection.
  * Look at how https://github.com/olets/hometown-prompt determines whether we're on the "default" host, user, etc.
* Zsh: Put data in a separate file to behaviour.
  * The idea is basically so that I can `source` the file containing the data in order to e.g. regenerate abbreviations, without also running all the behaviour/logic in `.zshrc`.
* Vim: When viewing a man page, a command-like word that happens to occur at the start of a line in the middle of a paragraph will be highlighted as if it's a command.
* Zsh: nvm doesn't immediately detect `.nvmrc` when we do `echo "v16" > .nvmrc`. See if there's a way to force it to check after every command without invoking a performance hit.
* Vim: Why is `J` able to remove `#` in `.zshrc` when joining comment lines, but not in other files?
  * Seems `gq` is similarly able to trim the unnecessary `#` characters.
* Prompt: Consider allowing the prompt to show Git stashes even when on a different branch.
  * At present, the stash indicator only appears if there exists a stash **for the current branch**.
  * Maybe we could colour the stash indicator to indicate stash on current branch vs stash on any branch.
* Zsh: Startup is slow.
* Zsh: `__git_complete_worktree_paths` is broken.
  * `__git_complete_worktree_paths:4: command not found: #`
* Zsh: Print timestamp when a command is started.
  * Ephemeral prompt is perhaps one way to do this.
* X: Run `xcape` when my ErgoDox disconnects, and kill it when it connects.
* Git: Update `wkadd` so that it creates a symlink to the real Git dir.
  * This means I need to look at the contents of the newly-created `.git` file, and create a symlink to that path. Maybe call it something like `.gitdir`.
* Git: Find a way to have `git status` warn if there are hidden (as in `git hide`) files.
  * Could write a function that wraps `status`, first doing the warning thing and then passing over to `status` with all the passed arguments.
  * This might be a change for Git itself: add hook functionality that allows running custom logic on `git status`. Could be useful for all sorts of things, such as checking MR approval status, CI jobs, etc. Async would be ideal.
  * Consider whether it's possible to include this information in `status --short`.
* Vim/Tmux/shell: Make a super cool context-switching tool for switching between repo root and package root in Node projects.
  * Two things essentially need switching: the current directory of the shell, and the working directory of the Vim instance.
  * Do we do this per pane or per window?
    * Perhaps an option for either would be useful.
    * Or is there some neat way we could launch a "subsession" for the inner path?
  * Do we invoke this from Vim or from Tmux?
    * Could easily do both, with `prefix-P` for Tmux and `<leader>p` for Vim.
    * From Tmux: in each pane, check if there are running processes. If so, do `^Z`, then `cd $path`, then `fg`; otherwise just do `cd $path`. (Perhaps use `push-line-or-edit` to ensure we don't mess up prompts that have a half-written command.)
    * From Vim: simply do `:cd $path`. Could we use fzf to list potential paths?
* Git: Update `wkadd` so that it works correctly when checking out a branch that already exists on a remote.
* Prompt: Amend the abbreviation logic a bit. When we're in a subdirectory of a Git root that matches the Git branch, abbreviate leading up to the Git root, and then if necessary abbreviate immediately after it too. So a pattern like `~/git_tree/main/hbotha--move_content_api_to_k8s/webservice/attractions/content` might become `…/hbotha--move_content_api_to_k8s/…/content`. Or perhaps `…/main/hbotha--move_content_api_to_k8s/…/content`, since just the branch name isn't enough to know which project we're in.
* Prompt: Make Git info async so that branch updates in other shells when we switch.
  * Better yet: Add an async indicator next to the Git info that displays when the Git info is out of date. This way, we know when not to trust it, but we retain the historical info that means, "This is what was happening in this shell at the time the last command finished," which is sometimes very useful.
  * It looks like the `TMOUT`/`TRAPALRM` combo makes my shell do the "chomp the previous line" thing. This is annoying. I wonder if it's as simple as fixing the 
