packages := $(shell cd arch-pkgs; ls -d */ | sed 's,/,,')
repos := xmonad-setup emacs-setup dotfiles\
 bc-extensions onboard-layouts games-setup
everything := $(packages) $(repos) hidpi xmonad-xsession

all: $(everything)

# make print-packages, etc.
print-%  : ; @echo $* = $($*)

.PHONY: $(everything)

clean:
	$(MAKE) -C arch-pkgs clean

$(packages):
	$(MAKE) -C arch-pkgs $@

$(repos):
	$(MAKE) -C $@ install

Iot:
	$(MAKE) -C arch-pkgs Iot

hidpi:
	$(MAKE) -C dotfiles hidpi

enable-anbox:
	$(MAKE) -C dotfiles $@

xmonad-xsession:
	$(MAKE) -C xmonad-setup xsession

emacs-setup-w-extras: emacs-setup emacs-pkg-setup
	$(MAKE) -C emacs-setup mu4e
	$(MAKE) -C emacs-setup mbsync

links:
	$(MAKE) -C xmonad-setup links
	$(MAKE) -C dotfiles links
	$(MAKE) -C emacs-setup links

clean-links:
	$(MAKE) -C xmonad-setup clean-links
	$(MAKE) -C dotfiles clean-links
	$(MAKE) -C emacs-setup clean-links

dotfiles: bc-extensions onboard-layouts
xmonad-setup: Xmonad
mobile-studio-pro: hidpi

base: necessities emacs-setup dotfiles
X11: base xmonad-setup
account: dotfiles emacs-setup xmonad-setup

git-sub-update:
	git submodule update --recursive --remote

git-sub-master:
	git submodule -q foreach git pull --rebase -q origin master

# in a submodule with detached head to go to origin master of submodule.
# git push origin HEAD:master
