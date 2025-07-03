# my desktop environment
> Collections of apps, utils, tweaks, preferences, hacks, and configs in my desktop environments


## Windows
- [Executor](https://executor.dk/)
- [Ditto](https://ditto-cp.sourceforge.io/) 
- [Greenshot](https://getgreenshot.org/)
  - `${YYYY}\${MM}\${capturetime:d"yyyy-MM-dd_HH_mm_ss"}-${title}`
  - see $work gist, this syntax has changed I think it's more like `$(YYYY)` now...
- [KeePassXC](https://keepassxc.org/)
- [AutoHotkey](https://www.autohotkey.com/)
  - expansion example
    - `::xxq::Quetzalcoatlus`
- WSL
  - [Oh my posh](https://ohmyposh.dev/) nicer out of the box PS1 than I could ever come up with myself
  
## Linux / bspwm
- [KeePassXC](https://keepassxc.org/)
- [copyq](https://hluk.github.io/CopyQ/)
- [peek](https://github.com/phw/peek)
- [arandr](http://christian.amsuess.com/tools/arandr/)
- [feh](https://feh.finalrewind.org/)
- [flameshot](https://flameshot.org/)
- [light-locker](https://github.com/the-cavalry/light-locker)
- [rofi](https://davatorium.github.io/rofi/)
- [sxhkd](https://github.com/baskerville/sxhkd)
- firefox
  - [uBlock Origin](https://addons.mozilla.org/en-US/firefox/addon/ublock-origin/)
  - [Privacy Badger](https://addons.mozilla.org/en-US/firefox/addon/privacy-badger17)
  
## CLI / languages
- [jq](https://jqlang.github.io/jq/)
- [rhich](https://www.learning-perl.com/2012/02/learning-perl-challenge-rhich/)
  ```alias rhich="perl -MEnv=@PATH -E '$r=shift; say for grep { /$r/ } map {  glob \"$_/*\" } @PATH'"```
- [plenv](https://xdg.me/setting-up-a-perl-development-environment-with-plenv/)
- [perl-local-lib](https://perladvent.org/2009/3/)

## App Themes
- [Dracula](https://draculatheme.com/)
- [Qogir-theme](https://github.com/vinceliuice/Qogir-theme)

## Todo
  - [oh my bash](https://github.com/ohmybash/oh-my-bash)
    - `export PROMPT_DIRTRIM=0`
  - fonts (look at oh my posh,so clean) 

### dotfiles
  - Emacs & Theme
  - correct GTK dot file
  - polybar config is not mine. need to customize it. If I'm going to use it.

### .local ($PATH)
  - textglow (imagemagick) place in .local
  - aws cli

### apps/utils
  - perl (plenv I think)
  - mypy (python virtual env)
    - build my own python, don't whatever you do use system py to make virtual environments or you'll always be update/upgrading them
  - ta-lib
  - stripe

### reminders
  - never install RESH
  - Do you really need figlet?