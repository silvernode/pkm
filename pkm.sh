# Notes for video:  http://www.youtube.com/watch?v=N8CZhlIssdk
##############################################

# add this to your ~/.bashrc or ~/.zshrc and reload your shell

#------------------------------------------


# find alternative apps if it is installed on your system
find_alt() { for i;do which "$i" >/dev/null && { echo "$i"; return 0;};done;return 1; }

# Use the first program that it detects in the array as the default app
export PKMGR=$(find_alt xbps-install yaourt pacman aptitude apt-get yum zypper emerge)

#-------- Gotbletu Universal Package Manager {{{
#------------------------------------------------------
# legends# {{{
# https://wiki.archlinux.org/index.php/Pacman_Rosetta
# http://old-en.opensuse.org/Software_Management_Command_Line_Comparison
# https://bbs.archlinux.org/viewtopic.php?pid=1281605#p1281605
# Arch			-- pacman, yaourt
# Debian/Ubuntu		-- apt-get(apt), aptitude, dpkg
# Gentoo		-- eclean, emerge, equery, layman
# OpenSuse		-- zypper
# Red Hat/Fedora	-- package-cleanup, rpm, yum
# Suse			-- rug
# Not finish, only tested on Debian, Arch, Fedora so far

# cleanold; removes certain packages that can no longer be downloaded
# cleanall; remove all local cached packages
# list; show the content of an installed package
# localinstall; install package manually such as deb, rpm files downloaded
# own; find a command a package belongs to; ex: pkm-own convert
# purge; uninstall package and purge configuration files (not in /home)
# query; search for an already installed package
# refresh; update repository list
# upgrade; install the newest version from the repositories
# hold/unhold; stop/allow a package from being update
# }}}
# missing
# emerge: autoclean, purge, list, query
# rug: pkm-info, clean, autoremove, autoclean, purge, list, query
# zypper: pkm-info, autoremove, autoclean, purge, list, query
# yum: autoclean, purge
# {{{ apt-get
case "$PKMGR" in
	"apt-get")
		pkm-cleanallall() { sudo apt-get clean ;}
		pkm-cleanallold() { sudo apt-get autoclean ;}
		pkm-dependsreverse() { apt-cache rdepends "$@" ;}
		pkm-download() { wget $(apt-get --print-uris -y install "$@" | grep ^\'| cut -d\' -f2) ;}
		pkm-extract() { ar vx "$@" | tar -zxvf data.tar.gz ;}
		# same as; echo "pkgname hold" | dpkg --set-selections
		pkm-hold() { sudo apt-mark hold "$@" ;}
		pkm-hold-status() { dpkg --get-selections | awk "/${@:-hold}/" ;}
		pkm-info() { apt-cache show "$@" ;}
		pkm-install() { sudo apt-get install --no-install-recommends "$@" ;}
		pkm-list() { dpkg -L "$@" ;}
		pkm-listcache() { ls -1 /var/cache/apt/archives "$@" && \
			echo "pwd: /var/cache/apt/archives" ;}
		pkm-localinstall() { sudo dpkg -i "$@" ;}
		pkm-own() { dpkg -S $(which "$@") ;}
		pkm-purge() { sudo apt-get purge "$@" ;}
		pkm-query() { dpkg --get-selections | grep "$@" ;}
		pkm-refresh() { sudo apt-get update ;}
		pkm-remove() { sudo apt-get remove "$@" ;}
		pkm-remove-orphans() { sudo apt-get autoclean ;}
		pkm-search() { apt-cache search "$@" ;}
		pkm-unhold() { sudo apt-mark unhold "$@" ;}
		pkm-upgrade() { sudo apt-get update && sudo apt-get upgrade ;}
		# PPA on ubuntu base distro (not compatible with debian)
		ppa-add() { sudo add-apt-repository $@ ;}
		ppa-del() { sudo add-apt-repository -r $@ ;}
		ppa-key() { sudo apt-key add $@ ;}
		ppa-list() { ls /etc/apt/sources.list.d ;}
		ppa-purge() { sudo ppa-purge $@ ;}
		# auto get missing gpg keys from launchpad
		ppa-autokey() { sudo apt-get update 2> /tmp/keymissing; \
			for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); \
			do echo -e "\nProcessing key: $key"; gpg --keyserver pool.sks-keyservers.net \
			--recv $key && gpg --export --armor $key | sudo apt-key add -; done ;}
			# these are extra servers, just replace it if one is down
			# keyserver.ubuntu.com
			# pool.sks-keyservers.net
			# subkeys.pgp.net
			# pgp.mit.edu
			# keys.nayr.net
			# keys.gnupg.net
			# wwwkeys.en.pgp.net #(replace with your country code fr, en, de,etc)
			# }}}
			# {{{ aptitude
		;;
	"aptitude")
		pkm-cleanallall() { sudo aptitude clean ;}
		pkm-cleanallold() { sudo aptitude autoclean ;}
		pkm-dependsreverse() { aptitude why "$@" ;}
		pkm-download() { aptitude download "$@" ;} # need a better 1; deb w/ depends
		pkm-extract() { ar vx "$@" | tar -zxvf data.tar.gz ;}
		pkm-hold() { echo "$1 hold" | sudo dpkg --set-selections && \
			dpkg --get-selections | awk "/$1/ && /hold/" ;}
		pkm-hold-status() { dpkg --get-selections | awk "/${@:-hold}/" ;}
		pkm-info() { aptitude show "$@" ;}
		pkm-install() { sudo aptitude install --without-recommends "$@" ;}
		pkm-list() { dpkg -L "$@" ;}
		pkm-listcache() { ls -1 /var/cache/apt/archives "$@" && \
			echo "pwd: /var/cache/apt/archives" ;}
		pkm-localinstall() { sudo dpkg -i "$@" ;}
		pkm-own() { dpkg -S $(which "$@") ;}
		pkm-purge() { sudo aptitude purge "$@" ;}
		pkm-query() { dpkg --get-selections | grep "$@" ;}
		pkm-refresh() { sudo aptitude update ;}
		pkm-remove() { sudo aptitude remove "$@" ;}
		pkm-remove-orphans() { sudo aptitude autoclean ;}
		pkm-search() { aptitude search "$*" ;}
			# fix  maybe with keyword $@ | sed / / ~d/
		pkm-search-description() { aptitude search ~d"$1"~d"$2"~d"$3"~d"$4"~d"$5"~d"$6"~d"$7" ;}
		pkm-unhold() { echo "$1 install" | sudo dpkg --set-selections && \
			dpkg --get-selections | awk "/$1/ && /install/" ;}
		pkm-upgrade() { sudo aptitude update && sudo aptitude upgrade ;}
		# PPA on ubuntu base distro (not compatible with debian)
		ppa-add() { sudo add-apt-repository $@ ;}
		ppa-del() { sudo add-apt-repository -r $@ ;}
		ppa-key() { sudo apt-key add $@ ;}
		ppa-list() { ls /etc/apt/sources.list.d ;}
		ppa-purge() { sudo ppa-purge $@ ;}
		ppa-autokey() { sudo apt-get update 2> /tmp/keymissing; \
			for key in $(grep "NO_PUBKEY" /tmp/keymissing |sed "s/.*NO_PUBKEY //"); \
			do echo -e "\nProcessing key: $key"; gpg --keyserver pool.sks-keyservers.net \
			--recv $key && gpg --export --armor $key | sudo apt-key add -; done ;}
	;;
	# }}}
	# {{{ emerge
	"emerge")
		pkm-remove-orphans() { sudo emerge --depclean ;}
		pkm-cleanall() { sudo eclean distfiles ;}
		pkm-info() { emerge -S "$@" ;}
		pkm-install() { sudo emerge "$@" ;}
		pkm-refresh() { sudo layman -f ;}
		pkm-remove() { sudo emerge -C "$@" ;}
		pkm-search() { emerge -S "$@" ;}
		pkm-upgrade() { sudo emerge -u world ;}
	;;
	# }}}
	# {{{ pacman
	"pacman")
		pkm-build() { tar xvzf "$1" && cd "${1%%.tar.gz}" && makepkg -csi ;}
		pkm-cleanall() { sudo pacman -Sc ;}
		pkm-cleanold() { sudo pacman -Scc ;}
		if type -p downgrade > /dev/null; then
		# require: https://aur.archlinux.org/packages/downgrade/
			pkm-downgrade() { downgrade "$@" ;}
		fi
		pkm-download() { sudo pacman -Sw "$@" ;}
		pkm-info() { for arg in "$@"; do
			pacman -Qi $arg 2> /dev/null \
			|| pacman -Si $arg; done ;}
		pkm-install() { sudo pacman -S "$@" ;}
		pkm-key() { sudo pacman-key --init \
			&& sudo pacman-key --populate archlinux \
			&& sudo pacman-key --refresh-keys ;}
		pkm-list() { pacman -Qql "$@" ;}
		pkm-listcache() { ls -1 /var/cache/pacman/pkg "$@" && \
			echo "pwd: /var/cache/pacman/pkg" ;}
		pkm-localinstall() { sudo pacman --noconfirm -U "$@" ;}
		pkm-own() { pacman -Qo "$@" ;}
		pkm-purge() { sudo pacman -R "$@" ;}
		pkm-query() { pacman -Qqs "$@" ;}
		pkm-query-detail() { pacman -Qs "$@" ;}
		pkm-refresh() { sudo pacman -Syy ;}
		pkm-remove() { sudo pacman -Rcs "$@" ;}
		pkm-remove-nodepends() { sudo pacman -Rdd "$@" ;}
		pkm-remove-orphans() { sudo pacman -Rs $(pacman -Qqtd) ;}
		pkm-search() { pacman -Ss "$@" ;}
		pkm-upgrade() { sudo pacman -Syu ;}
	;;
	# }}}
	# {{{ rug
	"rug")
		pkm-install() { sudo rug install "$@" ;}
		pkm-refresh() { sudo rug refresh ;}
		pkm-remove() { sudo rug remove "$@" ;}
		pkm-search() { rug search "$@" ;}
		pkm-upgrade() { sudo rug update ;}
	;;
	# }}}
	# {{{ yaourt
	"yaourt")
		pkm-build() { tar xvzf "$1" && cd "${1%%.tar.gz}" && makepkg -csi ;}
		pkm-cleanall() { yaourt -Sc ;}
		pkm-cleanold() { yaourt -Scc ;}
		if type -p downgrade > /dev/null; then
		# require: https://aur.archlinux.org/packages/downgrade/
			pkm-downgrade() { downgrade "$@" ;}
		fi
		pkm-download() { sudo pacman -Sw "$@" ;} # need better shit to dl from aur also
		pkm-info() { for arg in "$@"; do
			yaourt -Qi $arg 2> /dev/null \
			|| yaourt -Si $arg; done ;}
		pkm-install() { yaourt --noconfirm -S "$@" ;}
		# https://wiki.archlinux.org/index.php/Pacman-key#Resetting_all_the_keys
		pkm-key() { sudo pacman-key --init \
			&& sudo pacman-key --populate archlinux \
			&& sudo pacman-key --refresh-keys ;}
		pkm-list() { yaourt -Qql "$@" ;}
		pkm-listcache() { ls -1 /var/cache/pacman/pkg "$@" && \
			echo "pwd: /var/cache/pacman/pkg" ;}
		pkm-localinstall() { sudo pacman --noconfirm -U "$@" ;}
		pkm-own() { pacman -Qo "$@" ;}
		pkm-purge() { yaourt -R "$@" ;}
		pkm-query() { pacman -Qqs "$@" ;}
		pkm-query-detail() { yaourt -Qs "$@" ;}
		pkm-refresh() { yaourt -Syy ;}
		pkm-remove() { yaourt -Rcs "$@" ;}
		pkm-remove-nodepends() { yaourt -Rdd "$@" ;}
		pkm-remove-orphans() { yaourt -Rs $(pacman -Qqtd) ;}
		pkm-search() { yaourt --noconfirm "$@" ;}
		pkm-upgrade() { yaourt -Syu ;}	# upgrade everything except aur package
		pkm-upgrade-aur() { yaourt -Sbua ;} # only upgrade aur package
		pkm-upgrade-auto() { yaourt --noconfirm -Syu ;}
		pkm-upgrade-auto-aur() { yaourt --noconfirm -Sbua ;}
	;;
	# }}}
	# {{{ yum
	"yum")
		pkm-cleanall() { sudo yum clean ;}
		pkm-depends() { sudo yum deplist "$@" ;}
		pkm-dependsreverse() { sudo yum resolvedep "$@" ;}
		pkm-info() { for arg in "$@"; do rpm -qi $arg 2> /dev/null || yum info $arg; done ;}
	;;
	# XBPS
	"xbps-install")
		pkm-install() { sudo xbps-install "$@" ;}
		pkm-search() { xbps-query -Rs "$@" ;}
		pkm-remove() { sudo xbps-remove "$@" ;}
		pkm-refresh() { xbps-install -S ;}
		pkm-upgrade() { sudo xbps-install -Su ;}
		pkm-upgrade-auto() { sudo xbps-install -Syu ;}
	;;
	"nix-env")
		pkm-install() { sudo nix-env -i "${@}" ;}
		pkm-search() { nix-env -qa "${@}" ;}
		pkm-remove() { nix-env --uninstall "${@}" ;}
		pkm-refresh() { nix-env -u "${@}" ;}
	;;
esac
