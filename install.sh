#!/usr/bin/env bash
# Neovim Dotfiles Installer for Linux Mint
# Network operations are non-fatal — the script continues if downloads fail.

set -u

abort() { echo "ERROR: $*" >&2; exit 1; }

echo "============================================"
echo "  Neovim Dotfiles Installer for Linux Mint  "
echo "============================================"
echo ""

# --- System packages ---
echo "==> Updating apt and installing system packages..."
sudo apt update -y || abort "apt update failed"
sudo apt upgrade -y
sudo apt install -y \
	curl wget git tmux neofetch xclip \
	build-essential cmake silversearcher-ag ripgrep fd-find \
	zsh fontconfig || abort "apt install failed"

# --- Nerd Font ---
echo "==> Installing DroidSansM Nerd Font..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
FONT_URL="https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf"
if curl -Lf "$FONT_URL" -o "$FONT_DIR/DroidSansMNerdFont-Regular.otf" 2>/dev/null; then
	fc-cache -fv
	echo "   Font installed. Set terminal font to 'DroidSansM Nerd Font'."
else
	echo "   WARNING: Font download failed. Install manually from nerdfonts.com"
fi

# --- FZF ---
if [ ! -d "$HOME/.fzf" ]; then
	echo "==> Installing fzf..."
	git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf" 2>/dev/null && \
		"$HOME/.fzf/install" --all --no-bash --no-fish 2>/dev/null || \
		echo "   WARNING: fzf install failed"
else
	echo "==> fzf already installed, skipping."
fi

# --- Neovim ---
echo "==> Installing Neovim..."
NVIM_URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
if curl -Lf "$NVIM_URL" -o /tmp/nvim-linux64.tar.gz 2>/dev/null; then
	tar xzf /tmp/nvim-linux64.tar.gz -C /tmp
	rm -rf "$HOME/nvim"
	if [ -d /tmp/nvim-linux-x86_64 ]; then
		mv /tmp/nvim-linux-x86_64 "$HOME/nvim"
	elif [ -d /tmp/nvim-linux64 ]; then
		mv /tmp/nvim-linux64 "$HOME/nvim"
	else
		echo "   WARNING: Could not find extracted nvim directory"
	fi
	rm -f /tmp/nvim-linux64.tar.gz
	echo "   Neovim installed to ~/nvim/bin/nvim"
else
	echo "   WARNING: Neovim download failed"
fi

# --- Shell: zsh + oh-my-zsh ---
echo "==> Setting up zsh + oh-my-zsh..."
ZSHRC="$HOME/.zshrc"

# Install oh-my-zsh FIRST — its installer overwrites .zshrc with a fresh
# template, so anything we append must come after this step.
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	echo "==> Installing oh-my-zsh..."
	RUNZSH=no CHSH=no \
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended 2>/dev/null || \
		echo "   WARNING: oh-my-zsh install failed"
fi

# Add nvim to PATH (after oh-my-zsh so the line isn't wiped by its template)
if ! grep -q 'export PATH="$HOME/nvim/bin:$PATH"' "$ZSHRC" 2>/dev/null; then
	echo 'export PATH="$HOME/nvim/bin:$PATH"' >> "$ZSHRC"
fi

# Dracula zsh theme
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ ! -f "$ZSH_CUSTOM/themes/dracula.zsh-theme" ]; then
	echo "==> Installing Dracula zsh theme..."
	if git clone https://github.com/dracula/zsh.git /tmp/dracula-zsh 2>/dev/null; then
		mkdir -p "$ZSH_CUSTOM/themes"
		cp /tmp/dracula-zsh/dracula.zsh-theme "$ZSH_CUSTOM/themes/"
		cp -r /tmp/dracula-zsh/lib "$ZSH_CUSTOM/themes/" 2>/dev/null || true
		rm -rf /tmp/dracula-zsh
	else
		echo "   WARNING: Dracula theme download failed"
	fi
fi

# Activate the Dracula theme
if [ -f "$ZSH_CUSTOM/themes/dracula.zsh-theme" ]; then
	if grep -q '^ZSH_THEME=' "$ZSHRC" 2>/dev/null; then
		sed -i 's/^ZSH_THEME=.*/ZSH_THEME="dracula"/' "$ZSHRC"
	else
		echo 'ZSH_THEME="dracula"' >> "$ZSHRC"
	fi
	echo "   Dracula theme activated in .zshrc"
fi

# Set zsh as default shell
if [ "${SHELL##*/}" != "zsh" ]; then
	echo "==> Setting zsh as default shell..."
	chsh -s "$(which zsh)" 2>/dev/null || \
		echo "   WARNING: Run 'chsh -s \$(which zsh)' manually"
	echo "   Log out and back in for zsh to take effect."
else
	echo "==> zsh is already your default shell."
fi

# --- NVM + Node ---
if [ ! -d "$HOME/.nvm" ]; then
	echo "==> Installing nvm..."
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh 2>/dev/null | bash 2>/dev/null || \
		echo "   WARNING: nvm install failed"
fi

export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
	echo "==> Installing Node LTS via nvm..."
	\. "$NVM_DIR/nvm.sh" 2>/dev/null && nvm install --lts 2>/dev/null || \
		echo "   WARNING: Node install failed. Run 'nvm install --lts' manually."
	# tree-sitter CLI (used by nvim-treesitter for some parsers)
	npm install -g tree-sitter-cli 2>/dev/null || echo "   WARNING: tree-sitter-cli install failed"
else
	echo "==> nvm not available, skipping Node."
fi

# --- uv + black (Python formatter) ---
# uv is self-contained (bundles its own Python), so black needs no python3-venv.
if ! command -v uv >/dev/null 2>&1; then
	echo "==> Installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh 2>/dev/null | sh 2>/dev/null || \
		echo "   WARNING: uv install failed"
fi
if command -v uv >/dev/null 2>&1 || [ -x "$HOME/.local/bin/uv" ]; then
	echo "==> Installing black via uv..."
	"$HOME/.local/bin/uv" tool install black 2>/dev/null || uv tool install black 2>/dev/null || \
		echo "   WARNING: black install failed"
fi

# --- Lazygit ---
echo "==> Installing Lazygit..."
LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" 2>/dev/null | \
	grep -Po '"tag_name": *"\K[^"]+' || echo "")
if [ -n "$LAZYGIT_VERSION" ]; then
	LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION#v}_Linux_x86_64.tar.gz"
	if curl -Lf "$LAZYGIT_URL" -o /tmp/lazygit.tar.gz 2>/dev/null; then
		sudo tar xf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit 2>/dev/null || \
			echo "   WARNING: Could not extract lazygit"
		rm -f /tmp/lazygit.tar.gz
		echo "   Lazygit installed."
	else
		echo "   WARNING: Lazygit download failed"
	fi
else
	echo "   WARNING: Could not determine latest lazygit version"
fi

# --- Neovim config ---
echo "==> Installing Neovim config..."
mkdir -p "$HOME/.config"
cp -TRv config/nvim "$HOME/.config/nvim"

# --- Gnome terminal theme (Gogh) ---
echo "==> Applying Gnome terminal theme (Dracula)..."
yes 76 | bash -c "$(wget -qO- https://raw.githubusercontent.com/Gogh-Co/Gogh/master/installs/dracula.sh)" 2>/dev/null || \
	echo "   Gogh theme skipped (not critical)."

echo ""
echo "============================================"
echo "  Installation complete!"
echo "============================================"
echo ""
echo "Next steps:"
echo "  1. Log out and back in for zsh to become your default shell."
echo "  2. Set terminal font to: DroidSansM Nerd Font"
echo "  3. Run: nvim  (lazy.nvim will auto-install all plugins)"
echo ""
