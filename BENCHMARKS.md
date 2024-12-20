```
$ $ZPLUG_REPOS/romkatv/zsh-bench/zsh-bench
```

# Current config

```
==> benchmarking login shell of user hbotha ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=2008.900
first_command_lag_ms=2149.159
command_lag_ms=402.163
input_lag_ms=2.112
exit_time_ms=1684.529
```

## But not as a login shell

```
==> benchmarking interactive shell of user hbotha ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=1542.036
first_command_lag_ms=1690.697
command_lag_ms=341.055
input_lag_ms=1.854
exit_time_ms=1236.949
```

Savings: 466/459/61. Huge.

# No custom prompt

```
==> benchmarking login shell of user hbotha ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=0
first_prompt_lag_ms=1688.594
first_command_lag_ms=1709.256
command_lag_ms=23.875
input_lag_ms=1.590
exit_time_ms=1611.101
```

So we save 320 ms on first prompt lag, 440 ms on first command lag, 379 ms on command lag. That's already huge.

# No `zsh_util_install`

```
==> benchmarking login shell of user hbotha ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=1969.007
first_command_lag_ms=2132.300
command_lag_ms=351.365
input_lag_ms=1.816
exit_time_ms=1636.657
```

Savings: 39/17/51. So a bit, but the prompt is a much bigger issue.

# No brew shellenv

```
==> benchmarking login shell of user hbotha ...
creates_tty=0
has_compsys=1
has_syntax_highlighting=0
has_autosuggestions=1
has_git_prompt=1
first_prompt_lag_ms=1604.298
first_command_lag_ms=1763.611
command_lag_ms=374.343
input_lag_ms=1.822
exit_time_ms=1275.735
```

Savings: 404/386/28. Huge.
