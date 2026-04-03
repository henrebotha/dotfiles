#! /usr/bin/env zsh
d=$(defaults -currentHost find 'NSStatusItem')

[[ $(<<< $d grep -E -c 'NSStatusItem(SelectionPadding|Spacing)') -ge 2 ]] && exit

<<< $d grep -q 'NSStatusItemSelectionPadding' || defaults -currentHost write -globalDomain NSStatusItemSelectionPadding -int 2
<<< $d grep -q 'NSStatusItemSpacing' || defaults -currentHost write -globalDomain NSStatusItemSpacing -int 2
