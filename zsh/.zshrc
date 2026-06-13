export QT_QPA_PLATFORMTHEME "qt6ct"
export QT_QPA_PLATFORM "wayland"

f() {
  if [[ "$1" == "-d" ]]; then
    command fastfetch "${@:2}"
  elif [[ "$1" == "--config" ]]; then
    command fastfetch "$@"
  else
    command fastfetch --config ~/.config/fastfetch/config-matugen.jsonc "$@"
  fi
}

if [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
  f
fi

prompt_starship() {
	local surface="#313244"
	local peach="#fab387"
	local green="#a6e3a1"
	local cyan="#97cce8" # custom color (not in cattpuccin)
	local blue="#89b4fa"
	local pink="#f5c2e7"
	local red="#f38ba8"

	# username
	PROMPT="
%F{$surface}%f%K{$surface}󰣇 %n %k%F{$surface}"
	# working directory
	PROMPT+="%K{$peach} %~ %k%f%F{$peach}"
	# green div
	PROMPT+="%K{$green}%k%f%F{$green}"
	# cyan div
	PROMPT+="%K{$cyan}%k%f%F{$cyan}"
	# blue div
	PROMPT+="%K{$blue}%k%f%F{$blue}"
	# time
	PROMPT+="%K{$pink}%f%F{$surface}  %D{%I:%M %p} %f%k%F{$pink}%f"
	# prompt char
	PROMPT+="
%(?.%F{$green}.%F{$red})❯ %f"
}

prompt_simple() {
	local dir=$'\e[36m'
	local success=$'\e[32m'
	local fail=$'\e[31m'
	local rst=$'\e[0m'

	PROMPT="
%{$dir%}%~%{$rst%}
%(?.%{$success%}.%{$fail%})❯ %{$rst%}"
}

# eval "$(starship init zsh)"
# prompt_starship
prompt_simple

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
plugins=(git history sudo)
source $ZSH/oh-my-zsh.sh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f -H --exclude .git --exclude .wine --exclude .cache'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d -H --exclude .git --exclude .wine --exclude .cache'

alias mv='mv -i'
alias zshconf="micro ~/.zshrc"
alias c="clear"
alias size="du -s --si"
alias open='xdg-open'
alias yt-video="yt-dlp -P ~/Videos"
alias yt-audio="yt-dlp -x --audio-format mp3 -P ~/Audios"
alias yt-music='yt-dlp -x --audio-format mp3 --embed-thumbnail --embed-metadata --output "%(title)s.%(ext)s" -P ~/Music'
alias yt-playlist='yt-dlp -x -o "%(playlist_index)s - %(title)s" --embed-thumbnail --embed-metadata --audio-format mp3 -P ~/Music'
alias autoremove='yay -Qdtq | yay -Rns -'
alias reload-waybar='pkill -SIGUSR2 waybar'
alias speedtest='cloudflare-speed-cli'
# alias wl-screenrec='wl-screenrec --codec hevc'
#alias up="sudo dnf update"


function up {
    local counter=${1:-1}
    local dirup="../"
    local out=""
    while (( counter > 0 )); do
        let counter--
        out="${out}$dirup"
    done
    cd $out
}

hyprconf() {
    local flag=$1
    case "$flag" in
        -a)
            micro ~/.config/hypr/appearance.conf
            ;;
        -b)
            micro ~/.config/hypr/binds.conf
            ;;
        -g)
            micro ~/.config/hypr/general.conf
            ;;
        -i)
            micro ~/.config/hypr/input.conf
            ;;
        -r)
            micro ~/.config/hypr/rules.conf
            ;;
        *)
            cd ~/.config/hypr || return
            ;;
    esac
}

function e() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
export EDITOR=micro
#export PATH=$PATH:/home/tejas/.spicetify

export "MICRO_TRUECOLOR=1"

bindkey '^H' backward-kill-word

# Man Page Color Env Vars
export LESS_TERMCAP_mb=$'\e[1;34m'
export LESS_TERMCAP_md=$'\e[1;34m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[1;30;44m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[4;1;32m'
export LESS_TERMCAP_mr=$'\e[7m'
export LESS_TERMCAP_mh=$'\e[2m'
export LESS_TERMCAP_ZN=$'\e[74m'
export LESS_TERMCAP_ZV=$'\e[75m'
export LESS_TERMCAP_ZO=$'\e[73m'
export LESS_TERMCAP_ZW=$'\e[75m'
export MANPAGER='less'
export GROFF_NO_SGR=1

# Created by `pipx` on 2026-06-05 18:41:29
export PATH="$PATH:/home/tejas/.local/bin"
