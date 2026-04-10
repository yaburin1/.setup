# =========================
# ① builder stage
# =========================
FROM rust:slim AS builder

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget \
    curl \
    git \
    unzip \
    g++ \
    make \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Node.js（ビルド用途のみ）
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# tree-sitter-cli（ビルド用なのでbuilderに閉じ込める）
RUN npm install -g tree-sitter-cli \
    && npm cache clean --force

#neovimインストール
RUN curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.appimage && \
    chmod u+x nvim-linux-x86_64.appimage && \
    ./nvim-linux-x86_64.appimage --appimage-extract &&\
    rm nvim-linux-x86_64.appimage



# =========================
# ② runtime stage
# =========================
FROM debian:bookworm-slim

# 必要な実行系のみ
RUN apt-get update && apt-get install -y --no-install-recommends \
    sudo \
    git \
    curl \
    wget \
    unzip \
    g++ \
    make \
    ripgrep \
    fd-find \
    sqlite3 \
    libsqlite3-0 \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*


# user作成
RUN adduser --uid 1000 --shell /bin/bash --disabled-password --gecos "" user \
    && usermod -aG sudo user \
    && echo 'user ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


# Neovim設定だけコピー
COPY --chown=user:user ./nvim/ /home/user/.config/nvim/


# tree-sitter-cliだけbuilderから持ってくる
COPY --from=builder /usr/local/bin/tree-sitter /usr/local/bin/tree-sitter

# neovimの実行ファイルを持ってくる
COPY --from=builder /squashfs-root/ /opt/nvim/
RUN ln -s /opt/nvim/AppRun /usr/bin/nvim


USER user

# bash設定
RUN cat <<'EOF' >> /home/user/.bashrc
parse_git_branch() {
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    if [ -n "$branch" ]; then
        echo "($branch)"
    fi
}
export PS1="\[\e[35m\][\w/]\[\e[32m\]\$(parse_git_branch)\[\e[0m\]:"
alias ll='ls -l'
alias la='ls -la'
EOF


ENV LESSCHARSET=utf-8 \
    EDITOR=nvim \
    LANG=C.UTF-8 \
    PATH="${PATH}:/home/user/.local/bin/"

WORKDIR /home/user/work

CMD ["/bin/bash"]
