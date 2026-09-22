.DEFAULT_GOAL := help

TARGET ?= $(HOME)
PACKAGES ?= $(patsubst packages/%/,%,$(wildcard packages/*/))
STOW = stow --dir="$(CURDIR)/packages" --target="$(TARGET)" --no-folding --verbose

.PHONY: help check install uninstall

help:
	@printf '%s\n' \
	  'make check       Preview symlink changes' \
	  'make install     Create or refresh symlinks' \
	  'make uninstall   Remove managed symlinks' \
	  'Add PACKAGES="zsh git" to select packages (default: all).'

check: STOW_ACTION = --simulate --restow
install: STOW_ACTION = --restow
uninstall: STOW_ACTION = --delete

check install uninstall:
	@if [ -z "$(strip $(PACKAGES))" ]; then \
	  printf '%s\n' 'No packages yet. Add a folder under packages/; see README.md.'; \
	else \
	  $(STOW) $(STOW_ACTION) $(PACKAGES); \
	fi
