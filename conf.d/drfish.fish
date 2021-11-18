# set -x theme_newline_cursor yes
# set -x SHELL fish
# set -x TERM xterm-256color
# set -x EDITOR nvim
# set -x BROWSER vivaldi-stable
# set -x GPG_TTY (tty)

# Clear this so my custom function can do its thing.
set fish_greeting

# I use this dir for random things, so just make it here.
mkdir -p ~/run

# Override some tide colors.
# Don't run these all the time, just once on initial setup to override color.
# set -U tide_git_prompt_bg_color 99C794
# set -U tide_jobs_color 99C794
# set -U tide_status_success_color 99C794

# fish_vi_key_bindings
fish_default_key_bindings
