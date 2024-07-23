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

        # Install xclip
        sudo apt install xclip -y

        # Install cmake
        curl -L -O https://github.com/Kitware/CMake/releases/download/v3.25.0/cmake-3.25.0.tar.gz
        tar -zxvf cmake-3.25.0.tar.gz && cd cmake-3.25.0.tar.gz/
        ./bootstrap && make && make install
        export PATH=$HOME/cmake-install/bin:$PATH
        export CMAKE_PREFIX_PATH=$HOME/cmake-install:$CMAKE_PREFIX_PATH
        rm cmake-3.25.0.tar.gz && rm -r cmake-3.25.0

        # Install fzf
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install -y
        sudo apt-get install silversearcher-ag -y

        # Install ripgrep
        curl -LO https://github.com/BurntSushi/ripgrep/releases/download/13.0.0/ripgrep_13.0.0_amd64.deb
        sudo dpkg -i ripgrep_13.0.0_amd64.deb
        rm ripgrep_13.0.0_amd64.deb

        # Change gnome terminal theme
        yes 76 | bash -c  "$(wget -qO- https://git.io/vQgMr)"

        # Install nerd font
        mkdir -p ~/.local/share/fonts && cd ~/.local/share/fonts 
        curl -LO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/DroidSansMono.tar.xz
        tar -xzf DroidSansMono.tar.xz
        ls | grep -v .otf$ | xargs rm
        sudo fc-cache -f -v
        cd -

        # Install nvim latest version
        curl -L -O https://github.com/neovim/neovim/releases/download/stable/nvim-linux64.tar.gz 
        tar xzvf nvim-linux64.tar.gz && mv nvim-linux64 nvim
        echo "alias nvim='~/nvim/bin/nvim" >> ~/.zshrc
        rm nvim-linux64.tar.gz 

        # Install npm
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash
        source ~/.zshrc
        nvm install --lts

        # Install lazygit
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' |  sed -E 's/.*"v*([^"]+)".*/\1/')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        sudo tar xf lazygit.tar.gz -C /usr/local/bin lazygit

        # Install neovim basic configs
        cp -TRv config/nvim ~/.config/nvim

        # Install zsh and ohmyzsh
        sudo apt install zsh -y
        chsh -s $(which zsh)
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" -y

        # Install dracula zsh theme
        git clone https://github.com/dracula/zsh.git temp
        cp -r temp/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
        cp -r temp/lib ~/.oh-my-zsh/themes/lib
        rm -r temp/

        echo "Installation complete. Re-login to apply zsh changes."
        echo "Run nvim and wait until plugins are installed!"
        ;;
    *)
        echo "See ya."
        ;;
esac

