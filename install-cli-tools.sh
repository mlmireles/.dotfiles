#!/usr/bin/env bash
#
# Installs the tools from README.md that have a scriptable, unattended
# install path (Homebrew formula/cask, or an official install script).
# Tools that require manual/interactive setup (YouCompleteMe, vim-go,
# the tmux-config reference dotfiles) are left out — see README.md.
#
# Usage:
#   ./install-cli-tools.sh            # install everything
#   ./install-cli-tools.sh zsh tmux   # install only the named tools
#   ./install-cli-tools.sh --list     # list available tool names

set -uo pipefail

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This script assumes macOS + Homebrew; other platforms aren't supported." >&2
  exit 1
fi

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_brew() {
  if ! command_exists brew; then
    install_brew
  fi
}

install_brew() {
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_zsh() {
  brew install zsh
}

install_oh_my_zsh() {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
}

install_vim() {
  brew install vim
  sh <(curl -fsSL https://raw.githubusercontent.com/amix/vimrc/master/install_awesome_vimrc.sh)
}

install_tmux() {
  brew install tmux
}

install_z() {
  brew install z
}

install_go() {
  brew install go
}

install_nvm() {
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
}

require_nvm() {
  export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
  if [[ ! -s "$NVM_DIR/nvm.sh" ]]; then
    install_nvm
  fi
  # shellcheck disable=SC1091
  \. "$NVM_DIR/nvm.sh"
}

install_node() {
  require_nvm
  nvm install node
}

install_polymer() {
  npm install -g bower
  npm install -g polymer-cli
}

install_pyenv() {
  brew install pyenv
}

install_mongodb() {
  brew tap mongodb/brew
  brew install mongodb-community
}

install_sdkman() {
  curl -s "https://get.sdkman.io" | bash
}

install_postman() {
  brew install --cask postman
}

# name -> function
TOOLS=(brew zsh oh_my_zsh vim tmux z go nvm node polymer pyenv mongodb sdkman postman)

tool_label() {
  case "$1" in
    brew) echo "Homebrew" ;;
    oh_my_zsh) echo "oh-my-zsh" ;;
    *) echo "$1" ;;
  esac
}

if [[ "${1:-}" == "--list" ]]; then
  printf '%s\n' "${TOOLS[@]}"
  exit 0
fi

require_brew

selected=("${TOOLS[@]}")
if [[ $# -gt 0 ]]; then
  selected=("$@")
fi

failed=()
for tool in "${selected[@]}"; do
  if [[ ! " ${TOOLS[*]} " =~ " ${tool} " ]]; then
    echo "Unknown tool: $tool (use --list to see available names)" >&2
    failed+=("$tool")
    continue
  fi
  echo "==> $(tool_label "$tool")"
  if ! "install_${tool}"; then
    echo "!! Failed to install $(tool_label "$tool")" >&2
    failed+=("$tool")
  fi
done

if [[ ${#failed[@]} -gt 0 ]]; then
  echo
  echo "Finished with failures: ${failed[*]}" >&2
  exit 1
fi

echo
echo "All done."
