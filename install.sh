read -r -p "Make sure you're in the repo folder. Are you? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY]) 

        # Update and upgrade apt
        sudo apt update -y
        sudo apt upgrade -y

        # Install curl
        sudo apt install curl -y

        # Install neofetch
        sudo apt install neofetch -y

        # Install tmux
        sudo apt install tmux -y

        # Install fzf
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install -y
        sudo apt-get install silversearcher-ag -y

        # Install zsh and ohmyzsh
        sudo apt install zsh -y
        chsh -s $(which zsh)
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

        # Install dracula zsh theme
        git clone https://github.com/dracula/zsh.git temp
        cp temp/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
        cp temp/lib ~/.oh-my-zsh/themes/lib
        rm -r temp/

        # Change gnome terminal theme
        yes 76 | bash -c  "$(wget -qO- https://git.io/vQgMr)"

        # Install nerd font
        mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts 
        curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
        cd -

        # Install nvim latest version
        curl -L -O https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.deb
        sudo dpkg -i nvim-linux64.deb -y
        rm nvim-linux64.deb

        # Install npm
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
        source ~/.zshrc
        nvm install --lts

        # Install neovim basic configs
        cp -TRv config/nvim ~/.config/nvim
        echo "Run nvim and wait until plugins are installed!"

        ;;
    *)
        echo "See ya."
        ;;
esac

