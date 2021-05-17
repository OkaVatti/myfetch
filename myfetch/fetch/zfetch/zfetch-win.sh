#!/bin/sh
#
# ufetch-arch - tiny system info for arch

## INFO

# user is already defined
host="$(cat /etc/hostname)"
os='TORII'
kernel="5.12.2 ARCH"
packages="$(pacman -Q | wc -l)"
shell="ZSH"

## UI DETECTION

parse_rcs() {
	for f in "${@}"; do
		wm="$(tail -n 1 "${f}" 2> /dev/null | cut -d ' ' -f 2)"
		[ -n "${wm}" ] && echo "${wm}" && return
	done
}

rcwm="$(parse_rcs "${HOME}/.xinitrc" "${HOME}/.xsession")"

ui='unknown'
uitype='UI'
if [ -n "${DE}" ]; then
	ui="${DE}"
	uitype='DE'
elif [ -n "${WM}" ]; then
	ui="${WM}"
	uitype='WM'
elif [ -n "${XDG_CURRENT_DESKTOP}" ]; then
	ui="${XDG_CURRENT_DESKTOP}"
	uitype='DE'
elif [ -n "${DESKTOP_SESSION}" ]; then
	ui="${DESKTOP_SESSION}"
	uitype='DE'
elif [ -n "${rcwm}" ]; then
	ui="${rcwm}"
	uitype='WM'
elif [ -n "${XDG_SESSION_TYPE}" ]; then
	ui="${XDG_SESSION_TYPE}"
fi

ui="$(basename "${ui}")"

## DEFINE COLORS

# probably don't change these
if [ -x "$(command -v tput)" ]; then
	bold="$(tput bold)"
	black="$(tput setaf 0)"
	red="$(tput setaf 1)"
	green="$(tput setaf 2)"
	yellow="$(tput setaf 3)"
	blue="$(tput setaf 4)"
	magenta="$(tput setaf 5)"
	cyan="$(tput setaf 6)"
	white="$(tput setaf 7)"
	reset="$(tput sgr0)"
fi

# you can change these
lc="${reset}${bold}${cyan}"         # labels
nc="${reset}${bold}${cyan}"         # user and hostname
ic="${green}"                       # info
c0="${reset}${cyan}"                # first color
c1="${reset}${red}"
c2="${reset}${green}"
c3="${reset}${blue}"
c4="${reset}${yellow}"

## OUTPUT

cat <<EOF

${ic}^  ${nc}${USER}${ic}@${nc}${host}${reset}
${ic}^  ${lc}----------
${ic}^  ${lc}OPSY ~ ${ic}${os}${reset}
${ic}^  ${lc}KRNL ~ ${ic}${kernel}${reset}
${ic}^  ${lc}PKGS ~ ${ic}${packages}${reset}
${ic}^  ${lc}SHLL ~ ${ic}${shell}${reset}
${ic}^  ${lc}DEWM ~ ${ic}${ui}${reset}


EOF
