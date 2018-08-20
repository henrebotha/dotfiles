def -params 1 -docstring "colorscheme <name>: enable named colorscheme" \
    -shell-candidates %{
    find -L "${kak_runtime}/colors" "${kak_config}/colors" -type f -name '*\.kak' \
        | while read -r filename; do
            basename="${filename##*/}"
            printf %s\\n "${basename%.*}"
        done | sort -u
  } \
  colorscheme %{ %sh{
    find_colorscheme() {
        find -L "${1}" -type f -name "${2}".kak | head -n 1
    }

    if [ -d "${kak_config}/colors" ]; then
        filename=$(find_colorscheme "${kak_config}/colors" "${1}")
    fi
    if [ -z "${filename}" ]; then
        filename=$(find_colorscheme "${kak_runtime}/colors" "${1}")
    fi

    if [ -n "${filename}" ]; then
        printf 'source %%{%s}' "${filename}"
    else
        echo "echo -markup '{Error}No such colorscheme'"
    fi
}}

%sh{
    autoload_directory() {
        find -L "$1" -type f -name '*\.kak' \
            -exec printf 'try %%{ source "%s" } catch %%{ echo -debug Autoload: could not load "%s" }\n' '{}' '{}' \;
    }

    echo "colorscheme default"

    if [ -d "${kak_config}/autoload" ]; then
        autoload_directory ${kak_config}/autoload
    elif [ -d "${kak_runtime}/autoload" ]; then
        autoload_directory ${kak_runtime}/autoload
    fi

    if [ -f "${kak_runtime}/kakrc.local" ]; then
        echo "source '${kak_runtime}/kakrc.local'"
    fi

    if [ -f "${kak_config}/kakrc" ]; then
        echo "source '${kak_config}/kakrc'"
    fi
}

# Show autoinfo on normal mode inputs
set-option -add global autoinfo normal
