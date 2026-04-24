# .bashrc
# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

###追加設定##################################################################################

##### iced 入力補完設定 #####################################################################
#GPUを使う
export WGPU_BACKEND=vulkan

#IME(fcitx5)
export GTK_IM_MODULE=fcitx
export QT_IM_MODULE=fcitx
export XMODIFIERS=@im=fcitx
export SDL_IM_MODULE=fcitx
export GLFW_IM_MODULE=ibus
# fcitx5 --disable=wayland -d  --verbose '*'=0
sudo xset -r 49

# iced(winit)でIMEを使う時指定(.cargo/config.toml)
# [env]
# WAYLAND_DISPLAYA={value="",force=true}

#x11(Xwayland)カーソルサイズ変更
export XCURSOR_SIZE=12

# 環境変数###################################################################################

#表示形式
parse_git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo "($branch)"
    fi
}
PS1="\[\e[35m\][\w/]\[\e[32m\]\$(parse_git_branch)\[\e[0m\]:"

export LESSCHARSET=utf-8
export BROWSER=wslview
export EDITOR=nvim


# export LANG=ja_JP.UTF-8
# export LANGUAGE=ja_JP:ja

#MasonのLSPサーバーのパスを通す
# export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"
# export PATH="$HOME/.local/bin:$PATH"

############################################################################################

#alias
alias la='ls -al'
alias ll='ls -l'

alias win='cd /mnt/c/Users/yabur/Desktop/'

# フォルダ名のみでその階層に移動できるようにする(>bash4.0)
# shopt -s autocd
# alias ...='cd ../..'
# alias ....='cd ../../..'

#############################################################################################

#atcoder
ulimit -s unlimited #スタックサイズ解除

anew() {
    local acdir contest current_dir tmp bindir
    local problems=()

    acdir=$(find "$HOME"/*atcoder/compete.toml 2>/dev/null | head -n 1 | xargs dirname)
    if [[ -z "$acdir" ]]; then
        echo "atcoderディレクトリが見つかりません"
        return 1
    fi

    current_dir=$(pwd)

    # コンテスト名を決定（引数優先、なければ現在ディレクトリから抽出）
    if [[ "$1" =~ ^(abc|arc|agc|ahc)[0-9]+$ ]]; then
        contest="$1"
        shift
    elif [[ "$1" =~ ^[0-9]+$ ]]; then
        contest="abc$1"
        shift
    elif [[ "$1" =~ ^([a-h]|ex|f2)$ && "$current_dir" =~ atcoder/(abc|arc|agc|ahc)[0-9]+ ]]; then
        tmp=${current_dir#*atcoder/}
        contest=${tmp%%/*}
    else
        if ! tmp_arr=($(
            "${acdir}/random_atcoder" \
            -f "${acdir}/difficlt_abc_20260330.csv" \
            -e "${acdir}/submitted_abc.csv" \
            200 600
        )); then
            echo "random_atcoder failed"
            return 1
        fi        
        contest="${tmp_arr[0]}"
        problems+=("${tmp_arr[1]}")

        shift

        if [[ -z "$contest" || ${#problems[@]} -eq 0 ]]; then
            echo "使い方: anew <contest> [problem...] または問題ディレクトリ内で anew <problem...>"
            return 1
        fi
    fi

    # 残引数から問題レターを抽出
    for item in "$@"; do
        [[ $item =~ ^([a-h]|ex|f2)$ ]] && problems+=("$item")
    done

    bindir="$acdir/$contest/src/bin"

    # 未初期化コンテスト: cargo compete new
    if [[ ! -d "$bindir" ]]; then
        if [[ ${#problems[@]} -gt 0 ]]; then
            cargo compete new "$contest" --open --problems "${problems[@]}"
        else
            cargo compete new "$contest"
            xdg-open "https://atcoder.jp/contests/$contest/tasks/${contest}_a"
            nvim "$bindir/a.rs"
        fi
        cd "$bindir" || return
        return
    fi

    # 既存コンテスト: cargo compete add
    cd "$bindir" || return
    if [[ ${#problems[@]} -gt 0 ]]; then
        problem=${problems[0]}
    else
        problem="a"
    fi
    problem_file="${bindir}/${problem}.rs"

    if [[ -e $problem_file ]]; then
        xdg-open "https://atcoder.jp/contests/$contest/tasks/${contest}_${problem}"
        nvim $problem_file
    else
        cargo compete add "$contest" "$problem" --open
    fi
}

atest() {
    cargo compete test "$1"
}

. "$HOME/.cargo/env"

