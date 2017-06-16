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
* (Cygwin) Ubuntu Mono derivative Powerline fonts [(in dotfiles/fonts/ubuntu-mono-deriv)](fonts)
* (Ubuntu) Ubuntu Mono derivative Powerline fonts [(in dotfiles/fonts)](fonts)

Security concerns prevent these items from residing in the repo:
* SSH keys
* AWS credentials file

And (not required), but here's other stuff that I generally like to install:
* [Universal Ctags](https://github.com/universal-ctags/ctags)

## Additional resources

* [Awesome Dotfiles](https://github.com/webpro/awesome-dotfiles)
* [Bash prompt](https://wiki.archlinux.org/index.php/Color_Bash_Prompt)
* [Solarized Color Theme for GNU ls](https://github.com/seebi/dircolors-solarized)

## Credits

* Structure and content largely borrowed from [Lars Kappert's dotfiles](https://github.com/webpro/dotfiles)
* Many thanks to the [dotfiles community](https://dotfiles.github.io/).
