GO := go
GO_INSTALL := GOBIN='$(abspath bin)' $(GO) install
PKG := ./...
GOFLAGS :=
STRESSFLAGS :=
TAGS := invariants
TESTS := .

export PATH := $(abspath bin):$(PATH)

.PHONY: all
all:
	@echo usage:
	@echo "  make test"
	@echo "  make testrace"
	@echo "  make stress"
	@echo "  make stressrace"
	@echo "  make stressmeta"
	@echo "  make clean"

bin/crlfmt: go.mod go.sum
	$(GO_INSTALL) -v github.com/cockroachdb/crlfmt

bin/staticcheck: go.mod go.sum
	$(GO_INSTALL) -v honnef.co/go/tools/cmd/staticcheck

override testflags :=
.PHONY: test
test: bin/crlfmt bin/staticcheck
	${GO} test -tags '$(TAGS)' ${testflags} -run ${TESTS} ${PKG}

.PHONY: testrace
testrace: testflags += -race
testrace: test

.PHONY: stress stressrace
stressrace: testflags += -race
stress stressrace: testflags += -exec 'stress ${STRESSFLAGS}' -timeout 0 -test.v
stress stressrace: test

.PHONY: stressmeta
stressmeta: override PKG = ./internal/metamorphic
stressmeta: override STRESSFLAGS += -p 1
stressmeta: override TESTS = TestMeta$$
stressmeta: stress

.PHONY: generate
generate:
	${GO} generate ${PKG}

.PHONY: clean
clean:
	rm -f $(patsubst %,%.test,$(notdir $(shell go list ${PKG})))

git_dirty := $(shell git status -s)

.PHONY: git-clean-check
git-clean-check:
ifneq ($(git_dirty),)
	@echo "Git repository is dirty!"
	@false
else
	@echo "Git repository is clean."
endif

.PHONY: mod-tidy-check
mod-tidy-check:
ifneq ($(git_dirty),)
	$(error mod-tidy-check must be invoked on a clean repository)
endif
	@${GO} mod tidy
	$(MAKE) git-clean-check
