# Puts Homebrew on PATH for this script. Returns 1 if it isn't installed.
# Shared by the install scripts through chezmoi's template include.
load_brew() {
    for candidate in "$(command -v brew 2>/dev/null || true)" \
        /opt/homebrew/bin/brew \
        /usr/local/bin/brew \
        /home/linuxbrew/.linuxbrew/bin/brew \
        /var/home/linuxbrew/.linuxbrew/bin/brew; do
        if [ -n "$candidate" ] && [ -x "$candidate" ]; then
            eval "$("$candidate" shellenv)"
            return 0
        fi
    done
    return 1
}
