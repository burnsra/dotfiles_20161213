## dotfiles
Every developer should have some dotfiles, these are mine

### Installation
```
sudo xcodebuild -license
git clone https://github.com/burnsra/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule init
git submodule update

export HOMEBREW_CACHE=/Volumes/Revelation/Caches/Homebrew
export HOMEBREW_DEVELOPER=true
ruby install.rb
```
