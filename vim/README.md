# Vim Files #
My Vim files are based on the environment in the book **Pro Vim** by Mark 
McDonnell, with a few of my own personal changes. The ProVim repo can be found 
at: https://github.com/Integralist/ProVim

Starting from the ProVim repo, I have converted many of the bundles and plugins
into git submodules so that they can be more easily kept up-to-date.

## Installing a Bundle ##
    cd ~/dotfiles/vim/bundle
    git submodule add https://github.com/username/bundlename.git 

## Updating a Bundle ##
    cd ~/dotfiles/vim/bundle/bundlename
    git pull

## Removing a Bundle ##
    cd ~/dotfiles
    git submodule deinit -f vim/bundle/bundlename
    git rm -rf vim/bundle/bundlename
