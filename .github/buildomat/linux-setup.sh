source .github/buildomat/versions.sh

sudo apt-get install -y --no-install-recommends \
    build-essential

pushd /work
curl -sSfL --retry 10 -O "https://go.dev/dl/go$GO_VERSION.linux-amd64.tar.gz"
sha256sum -c "$OLDPWD/.github/buildomat/SHA256SUMS.linux"
tar xf "go$GO_VERSION.linux-amd64.tar.gz"
popd
export PATH="/work/go/bin:$PATH"
