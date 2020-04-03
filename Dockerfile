FROM knipegp/docker-base:0.0.1

USER root
WORKDIR /root

RUN apt-get update && apt-get install -y gdb python3 python3-pip

# Install Go
RUN curl -LO https://dl.google.com/go/go1.13.7.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go1.13.7.linux-amd64.tar.gz && \
    rm go1.13.7.linux-amd64.tar.gz

USER developer
WORKDIR /home/developer

ENV PATH="/usr/local/go/bin:~/go/bin:${PATH}"

# Install YouCompleteMe
# Add flags to end of command for particular language support
RUN python3 ./.config/nvim/plugged/YouCompleteMe/install.py --go-completer

RUN go get -u golang.org/x/lint/golint
RUN go get -u github.com/go-delve/delve/cmd/dlv
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN curl -sSfL \
    https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh \
    | sh -s -- -b "$(go env GOPATH)"/bin v1.23.3

RUN pip3 install --user gdbgui==0.13.2.0
COPY GoPlugIns.vim ./
RUN cat GoPlugIns.vim >> ./dotfiles/vimscripts/PlugIns.vim
