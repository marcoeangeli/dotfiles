# Dotfiles

Personal configuration managed with Git and [GNU Stow](https://www.gnu.org/software/stow/), one of the approaches linked from the [dotfiles guide](https://dotfiles.github.io/tutorials/).

This repository starts empty. Add configurations gradually, one tool at a time.

## Layout

Each directory under `packages/` is a Stow package. Its contents mirror paths inside your home directory. For example, once added:

```text
packages/
  zsh/
    .zshrc                  → ~/.zshrc
  git/
    .gitconfig              → ~/.gitconfig
  nvim/
    .config/
      nvim/
        init.lua            → ~/.config/nvim/init.lua
```

Keep documentation and scripts at the repository root; only package contents are linked. Use simple package names without spaces, such as `zsh`, `git`, and `nvim`.

## Setup on a new Mac

With Git, Homebrew, and access to this private GitHub repository:

```sh
mkdir -p ~/Projects
git clone https://github.com/marcoeangeli/dotfiles.git ~/Projects/dotfiles
cd ~/Projects/dotfiles
brew bundle
make check
make install
```

On Linux, install `stow` and `make` with your package manager instead of using Homebrew.

## Add your first dotfile

For an existing regular `~/.zshrc`, first review its contents for credentials. Then back it up and move it into a new package:

```sh
cd ~/Projects/dotfiles
mkdir -p packages/zsh
cp -ip ~/.zshrc ~/.zshrc.before-dotfiles
mv -i ~/.zshrc packages/zsh/.zshrc
make check PACKAGES=zsh
make install PACKAGES=zsh
ls -l ~/.zshrc
```

If the file is already a symlink, check where it points before migrating it. If it does not exist yet, create `packages/zsh/.zshrc` and run the same check/install commands.

After installation, `~/.zshrc` is a symlink to the file in this repository. Editing either path updates the same file. Keep the repository in place while its links are installed.

Commit and push your configuration:

```sh
git status
git diff
git add packages/zsh/.zshrc
git diff --cached
git commit -m "Add zsh configuration"
git push
```

For an application that uses `~/.config`, create the matching path inside its package, such as `packages/nvim/.config/nvim/init.lua`. Move only the configuration you intend to track.

## Everyday commands

Run these from the repository:

| Command | Effect |
| --- | --- |
| `make check` | Preview changes for all packages; write nothing. |
| `make install` | Create or refresh links for all packages. |
| `make install PACKAGES="zsh git"` | Link only the named packages. |
| `make uninstall PACKAGES=zsh` | Remove a package's managed links; keep its repository files. |
| `make uninstall` | Remove all managed links; keep repository files. |

Run `make check` and `make install` after adding, renaming, or removing files, or after pulling updates. Edits to an already linked file are visible immediately, although an application may need to reload its configuration. Uninstall a package before deleting its directory.

The Makefile explicitly targets your home directory, since Stow's default target would be `~/Projects/dotfiles` for this layout. It also uses `--no-folding` to create real parent directories and symlink individual files, including files under `.config`. An alternate destination is supported with `TARGET=/path/to/existing/directory`.

## Existing files and private settings

Stow reports conflicts instead of overwriting existing files. If a target already exists, compare it with the repository version, back it up outside the repository, and move it aside before trying again. Avoid `stow --adopt` unless you specifically intend to move existing target files into the repository and replace its versions.

Keep tokens, passwords, private keys, and machine-specific secrets outside Git, even for a private repository. The `.gitignore` excludes `.env`, `.env.*`, and `*.local`, but cannot identify secrets embedded in other files. Git ignore rules do not control Stow: keep private files outside `packages/` as well.

For example, a tracked `.zshrc` can load an untracked `~/.zshrc.local`:

```sh
[ ! -f "$HOME/.zshrc.local" ] || . "$HOME/.zshrc.local"
```

## References

- [Dotfiles tutorials](https://dotfiles.github.io/tutorials/)
- [Getting started with dotfiles](https://webpro.nl/articles/getting-started-with-dotfiles)
- [GNU Stow manual](https://www.gnu.org/software/stow/manual/)
