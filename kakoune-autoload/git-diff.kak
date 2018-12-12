# require diff.kak

add-highlighter shared/git-diff group
add-highlighter shared/git-diff/ regex "\{\+[^\n]*?\+\}" 0:green,default
add-highlighter shared/git-diff/ regex "\[-[^\n]*?-\]" 0:red,default

hook -group diff-highlight global WinSetOption filetype=git-diff %{
    add-highlighter window/diff ref diff
    add-highlighter window/git-diff ref git-diff
}
hook -group diff-highlight global WinSetOption filetype=(?!git-diff).* %{
    remove-highlighter window/diff
    remove-highlighter window/git-diff
}
