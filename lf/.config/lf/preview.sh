#!/usr/bin/env bash

image() {
	if [ -n "$DISPLAY" ]; then
		exit 0
		# printf '{"action": "add", "identifier": "PREVIEW", "x": "%s", "y": "%s", "width": "%s", "height": "%s", "scaler": "contain", "path": "%s"}\n' "$4" "$5" "$(($2-1))" "$(($3-1))" "$1" > "$FIFO_UEBERZUG"
		# exit 1
	else
		exec timg -g"${2}x${3}" -ph  --compress "$1" 2>&-
	fi
}

case "$1" in
    *.tar*) tar tf "$1";;
    *.zip) unzip -l "$1";;
    *.rar) unrar l "$1";;
    *.7z) 7z l "$1";;
    # *.jpg) timg -ph -color8 "$1";;
    *.bmp|*.jpg|*.jpeg|*.png|*.xpm|*.webp|*.gif)
	image "$1" "$2" "$3" "$4" "$5"
	;;
    # *.pdf) pdftotext "$1" -;;
    # *) bat -f -n -r ":$2" --theme gruvbox-dark "$1";;
    # *) bat -f -n -r ":$2" --theme bas16 "$1";;
    # *) exec chroma --unbuffered "$1";;
    *) exec bat -p --theme base16 -f -r ":$2" "$1";;
esac

# Set the path of a previewer file to filter the content of regular files for
# previewing. The file should be executable. Five arguments are passed to the
# file, first is the current file name; the second, third, fourth, and fifth
# are width, height, horizontal position, and vertical position of preview
# pane respectively. SIGPIPE signal is sent when enough lines are read. If the
# previewer returns a non-zero exit code, then the preview cache for the given
# file is disabled. This means that if the file is selected in the future, the
# previewer is called once again. Preview filtering is disabled and files are
# displayed as they are when the value of this option is left empty.


# lf previews files on the preview pane by printing the file until the end or
# the preview pane is filled. This output can be enhanced by providing a
# custom preview script for filtering. This can be used to highlight source
# codes, list contents of archive files or view pdf or image files as text to
# name few. For coloring lf recognizes ansi escape codes.

# In order to use this feature you need to set the value of 'previewer' option
# to the path of an executable file. lf passes the current file name as the
# first argument and the height of the preview pane as the second argument
# when running this file. Output of the execution is printed in the preview
# pane. You may want to use the same script in your pager mapping as well if
# any:

#     set previewer ~/.config/lf/pv.sh
#     map i $~/.config/lf/pv.sh $f | less -R

# For 'less' pager, you may instead utilize 'LESSOPEN' mechanism so that
# useful information about the file such as the full path of the file can be
# displayed in the statusline below:

#     set previewer ~/.config/lf/pv.sh
#     map i $LESSOPEN='| ~/.config/lf/pv.sh %s' less -R $f

# Since this script is called for each file selection change it needs to be as
# efficient as possible and this responsibility is left to the user. You may
# use file extensions to determine the type of file more efficiently compared
# to obtaining mime types from 'file' command. Extensions can then be used to
# match cleanly within a conditional:

#     #!/bin/sh

#     case "$1" in
#         *.tar*) tar tf "$1";;
#         *.zip) unzip -l "$1";;
#         *.rar) unrar l "$1";;
#         *.7z) 7z l "$1";;
#         *.pdf) pdftotext "$1" -;;
#         *) highlight -O ansi "$1";;
#     esac

# Another important consideration for efficiency is the use of programs with
# short startup times for preview. For this reason, 'highlight' is recommended
# over 'pygmentize' for syntax highlighting. Besides, it is also important
# that the application is processing the file on the fly rather than first
# reading it to the memory and then do the processing afterwards. This is
# especially relevant for big files. lf automatically closes the previewer
# script output pipe with a SIGPIPE when enough lines are read. When
# everything else fails, you can make use of the height argument to only feed
# the first portion of the file to a program for preview. Note that some
# programs may not respond well to SIGPIPE to exit with a non-zero return code
# and avoid caching. You may add a trailing '|| true' command to avoid such
# errors:

#     highlight -O ansi "$1" || true

# You may also use an existing preview filter as you like. Your system may
# already come with a preview filter named 'lesspipe'. These filters may have
# a mechanism to add user customizations as well. See the related
# documentations for more information.


