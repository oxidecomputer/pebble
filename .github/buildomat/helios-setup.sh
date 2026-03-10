source .github/buildomat/versions.sh

GO_MAJOR=${GO_VERSION%.*}

pfexec pkg install \
    /developer/build-essential "/ooce/developer/go-${GO_MAJOR/./}@$GO_VERSION"

export PATH="/opt/ooce/go-$GO_MAJOR/bin:$PATH"
