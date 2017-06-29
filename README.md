# dotfiles
Personal environment preferences and settings, mostly for Ubuntu and Cygwin.


## Install
Install the dotfiles by cloning the Git repository and running the dotbot install script:

    git clone https://github.com/jamesbernsen/dotfiles.git ~/dotfiles
    cd ~/dotfiles
    ./install

(When running the install script, optional targets can be added, if a YAML config file exists for them. That is, for target **foo**, a **foo.config.yaml** file must exist in the base directory.)

    ./install foo

### And Then Manually Install (ugh) ###
These items (for now) require a manual check to see if they are installed, and if not, to install them.
* [Curl](https://curl.haxx.se/)
* [AWS CLI](http://docs.aws.amazon.com/cli/latest/userguide/installing.html)
* Node.js and npm (needed for [Leasot](https://github.com/pgilad/leasot) and [dotfiles/git/mdtodo.sh](git/mdtodo.sh))
* [Leasot](https://github.com/pgilad/leasot)
  - npm install --global leasot
* (Cygwin) Deja Vu Sans Mono for Powerline fonts [(in dotfiles/fonts/deja-vu-sans-mono-ttf)](fonts/deja-vu-sans-mono-ttf)
  - Open in Explorer
  - Right-click on each font file and choose Install

Security concerns prevent these items from residing in the repo:
* SSH keys
* AWS credentials file

And (not required), but here's other stuff that I generally like to install:
* [Universal Ctags](https://github.com/universal-ctags/ctags)
* (Ubuntu) Manually select the Droid Sans Mono for Powerline font in Gnome terminal. (Otherwise, we should still get the symbol font, but the patched font looks better.)
  - Edit > Profile Preferences
  - General tab
  - Custom Font: Droid Sans Mono for Powerline 

## Additional resources
* [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Bash prompt](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)
* [Solarized Color Theme for GNU ls](https://github.com/seebi/dircolors-solarized)

## Credits
* Structure and content largely borrowed from [Lars Kappert's dotfiles](https://github.com/webpro/dotfiles)
* Many thanks to the [dotfiles community](https://dotfiles.github.io/).
