# ---------------------------------------------------------------------------
# Powerlevel10k instant prompt
# Must stay near the top. Initialization code that may require console input
# (password prompts, [y/n] confirmations, etc.) must go above this block;
# everything else may go below.
# ---------------------------------------------------------------------------
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
else
  echo no p10k-instant-prompt-
fi

# ---------------------------------------------------------------------------
# Homebrew environment
# Static equivalent of `eval "$(/opt/homebrew/bin/brew shellenv)"`, avoids a
# subprocess fork on every shell start. Regenerate with `brew shellenv` if
# Homebrew's layout ever changes.
# ---------------------------------------------------------------------------
export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"
export PATH="/opt/homebrew/bin:/opt/homebrew/sbin${PATH+:$PATH}"
[ -z "${MANPATH-}" ] || { export MANPATH="${MANPATH%"${MANPATH##*[!:]}"}"; export MANPATH=":${MANPATH#"${MANPATH%%[!:]*}"}"; }
export INFOPATH="/opt/homebrew/share/info:${INFOPATH:-}"

# ---------------------------------------------------------------------------
# oh-my-zsh
# ---------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled  # disable automatic update checks (slow)

# Which plugins to load. Standard plugins live in $ZSH/plugins/, custom ones
# in $ZSH_CUSTOM/plugins/. Add wisely, as too many plugins slow down startup.
# plugins=(git)

if [[ -f "$ZSH/oh-my-zsh.sh" ]]; then
  source $ZSH/oh-my-zsh.sh
else
  echo oh-my-zsh not installed
fi

# ---------------------------------------------------------------------------
# General preferences
# ---------------------------------------------------------------------------
export EDITOR='nvim'

# ---------------------------------------------------------------------------
# Powerlevel10k theme
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# ---------------------------------------------------------------------------
if [[ -f "/opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
  source /opt/homebrew/share/powerlevel10k/powerlevel10k.zsh-theme
else
  echo powerlevel10k theme not installed
fi
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ---------------------------------------------------------------------------
# History
# ---------------------------------------------------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# ---------------------------------------------------------------------------
# PATH additions
# ---------------------------------------------------------------------------
export PATH="/opt/homebrew/opt/php@8.3/bin:$PATH"
export PATH="/opt/homebrew/opt/php@8.3/sbin:$PATH"
export PATH="/opt/homebrew/opt/node@24/bin:$PATH"
export PATH="/opt/homebrew/opt/curl/bin:$PATH"
export PATH="/Library/Java/JavaVirtualMachines/graalvm-community-openjdk-21/Contents/Home/bin:$PATH"
export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"  # nvim mason bin path
export PATH="$HOME/go/bin:$PATH"                       # go binaries
export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"      # krew path
export PATH="$HOME/tools:$PATH"                        # custom scripts (tmx, gcloud-reauth, ...)

export CLOUDSDK_PYTHON=python3.12

# ---------------------------------------------------------------------------
# Shell plugins: syntax highlighting, autosuggestions, gcloud completion
# ---------------------------------------------------------------------------
export ZSH_HIGHLIGHT_HIGHLIGHTERS_DIR=/opt/homebrew/share/zsh-syntax-highlighting/highlighters
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/google-cloud-sdk/completion.zsh.inc
source /opt/homebrew/share/google-cloud-sdk/path.zsh.inc

# ---------------------------------------------------------------------------
# kubectl completion (cached — regenerating via subprocess on every start is slow)
# ---------------------------------------------------------------------------
KUBE_COMPLETION_CACHE="${XDG_CACHE_HOME:-$HOME/.cache}/kubectl-completion.zsh"
if [ -x /opt/homebrew/bin/kubectl ]; then
  if [[ ! -f "$KUBE_COMPLETION_CACHE" || /opt/homebrew/bin/kubectl -nt "$KUBE_COMPLETION_CACHE" ]]; then
    kubectl completion zsh > "$KUBE_COMPLETION_CACHE"
  fi
  source "$KUBE_COMPLETION_CACHE"
else
  echo kubectl not installed
fi

# ---------------------------------------------------------------------------
# Kubernetes
# ---------------------------------------------------------------------------
export TZ="Europe/Berlin"
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export KUBE_EDITOR="/opt/homebrew/bin/nvim"

# ---------------------------------------------------------------------------
# fzf — `fzf --zsh` already provides completion + key-bindings
# ---------------------------------------------------------------------------
eval "$(fzf --zsh)"

# ---------------------------------------------------------------------------
# Aliases
# ---------------------------------------------------------------------------
alias vim="nvim"
alias vi="nvim"
alias k="kubectl"
alias :q=exit
alias ctx="kubectx"
alias cls="clear && printf '\e[3J'"

# ---------------------------------------------------------------------------
# Secrets — own secrets as env vars, MUST NOT BE VERSIONED
# ---------------------------------------------------------------------------
source ~/.local/krugs/local_credentials.sh

# ---------------------------------------------------------------------------
# GCP: re-auth once every 8h (opens browser login only if stale)
# ---------------------------------------------------------------------------
if [[ -o interactive ]] && command -v gcloud-reauth >/dev/null 2>&1; then
  gcloud-reauth 8
fi

# ---------------------------------------------------------------------------
# Completion system
# ---------------------------------------------------------------------------
FPATH=/opt/homebrew/share/zsh-completions:$FPATH
fpath=(/Users/krugs/.docker/completions $fpath)  # Docker Desktop CLI completions
autoload -Uz compinit
# Only rebuild the completion dump once a day; otherwise skip the (slow) compaudit security check.
zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
if [[ -n "$zcompdump"(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# ---------------------------------------------------------------------------
# Startup profiling (disabled)
# To re-profile: wrap each section above with
#   start=`date +%s.%N`; <section>; end=`date +%s.%N`
#   echo "zshrc loading time for <name>: $(echo "$end - $start" | bc -l)"
# See git history for the full instrumented version.
# ---------------------------------------------------------------------------
