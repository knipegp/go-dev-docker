FROM knipegp/docker-base

RUN apt update
RUN apt upgrade -y
RUN apt install -y wget

# Install Go
RUN wget https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.13.7.linux-amd64.tar.gz && \
    rm go1.13.7.linux-amd64.tar.gz

USER developer
WORKDIR /home/developer

ENV PATH="/usr/local/go/bin:${PATH}"

# Install YouCompleteMe
# Add flags to end of command for particular language support
RUN python3 ./.config/nvim/plugged/YouCompleteMe/install.py --go-completer

RUN go get -u golang.org/x/lint/golint
RUN go get -u github.com/go-delve/delve/cmd/dlv

COPY GoPlugIns.vim ./
RUN cat GoPlugIns.vim >> ./dotfiles/vimscripts/PlugIns.vim
