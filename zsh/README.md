# Zsh

## What goes where?

https://unix.stackexchange.com/a/71258/123342

TL;DR:

1. `.zshenv` contains variables like `$PATH` and `$EDITOR` which need to be available to other programs.
2. `.zprofile` is like `.zlogin`; an alternative for people used to ksh. Not intended to be used together.
3. `.zshrc` is for interactive shell configuration. Prompt, colours, etc.
4. `.zlogin` is often used to start X using `startx`. Some systems start X on boot, so this file is not always very useful.
5. `.zlogout` is sometimes used to clear and reset the terminal.

From https://shreevatsa.wordpress.com/2008/03/30/zshbash-startup-files-loading-order-bashrc-zshrc-etc/:

|               | Interactive login | Interactive non-login | Script |
| ---           | ---               | ---                   | ---    |
| /etc/zshenv   | 1                 | 1                     | 1      |
| ~/.zshenv     | 2                 | 2                     | 2      |
| /etc/zprofile | 3                 |                       |        |
| ~/.zprofile   | 4                 |                       |        |
| /etc/zshrc    | 5                 | 3                     |        |
| ~/.zshrc      | 6                 | 4                     |        |
| /etc/zlogin   | 7                 |                       |        |
| ~/.zlogin     | 8                 |                       |        |
| ~/.zlogout    | 9                 |                       |        |
| /etc/zlogout  | 10                |                       |        |

[This SE answer](https://unix.stackexchange.com/a/324391) lays out when and why you want a login shell. In brief:

- A user should have (at most) one login shell per host per terminal.
- Every other shell will be a descendant of the login shell, and therefore will inherit many settings (environment variables, umask, etc) from the login shell. The login initialization files (.login, .profile, etc.) should set the settings that are inheritable, and .bashrc (or whatever else you use) should handle the ones that aren’t (set, shopt, non-exported shell variables, etc).
- Only the login initialization files should do "heavy lifting", i.e. resource-intensive actions, such as heavy singleton background processes, or interactive programs ("Choose windowing system").
- It may be good practice to launch a login shell per shell type, to avoid having e.g. a Bash non-login shell as child of a Zsh login shell.
- macOS Terminal.app launches a login shell per window. This informs how macOS users do things a bit differently with dotfiles.
