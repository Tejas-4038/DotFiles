
fastfetch() {
  if [[ "$1" == "-d" ]]; then
    command fastfetch "${@:2}"
  elif [[ "$1" == "--config" ]]; then
    command fastfetch "$@"
  else
    command fastfetch --config ~/.config/fastfetch/config-catppuccin.jsonc "$@"
  fi
}

if [[ "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
  fastfetch
fi

eval "$(starship init zsh)"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(git history sudo zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)
export FZF_DEFAULT_COMMAND='fd --type f -H --exclude .git --exclude .wine --exclude .cache'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d -H --exclude .git --exclude .wine --exclude .cache'

alias zshconf="micro ~/.zshrc"
alias ohmyzsh="micro ~/.oh-my-zsh"
#alias hyprconf="cd ~/.config/hypr/"
#alias ghosttyconf="micro ~/.config/ghostty/config"

alias c="clear"
alias size="du -s --si"
alias open='xdg-open'
alias ytvideo="yt-dlp -P ~/Videos"
alias ytaudio="yt-dlp -x --audio-format mp3 -P ~/Audios"
alias speedtest-cli="speedtest-cli --secure"
alias autoremove='yay -Qdtq | yay -Rns -'
alias network='~/.config/rofi/net.sh'
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
