#!/bin/sh
# $Xorg: xinitrc.cpp,v 1.3 2000/08/17 19:54:30 cpqbld Exp $

LANG=es_ES.utf8
LC_CTYPE="es_ES.utf8"
LC_NUMERIC="es_ES.utf8"
LC_TIME="es_ES.utf8"
LC_COLLATE="es_ES.utf8"
LC_MONETARY="es_ES.utf8"
LC_MESSAGES="es_ES.utf8"
LC_PAPER="es_ES.utf8"
LC_NAME="es_ES.utf8"
LC_ADDRESS="es_ES.utf8"
LC_TELEPHONE="es_ES.utf8"
LC_MEASUREMENT="es_ES.utf8"
LC_IDENTIFICATION="es_ES.utf8"
LC_ALL=es_ES.utf8

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap
urxvtd=/usr/bin/urxvtd
autocutsel=$(which autocutsel)

# merge in defaults and keymaps
[ -f $sysresources ] && xrdb -merge $sysresources
[ -f $sysmodmap ] && xmodmap $sysmodmap
[ -f $userresources ] && xrdb -merge $userresources
[ -f $usermodmap ] && xmodmap $usermodmap
[ -f $urxvtd ] && urxvtd -q &

# Unify PRIMARY selection and CLIPBOARD
[ -z "$autocutsel" ] && [ -f $autocutsel ] && autocutsel &
[ -z "$autocutsel" ] && [ -f $autocutsel ] && autocutsel -s PRIMARY &

setxkbmap es && setxkbmap -option ctrl:swapcaps && setxkbmap -option ctrl:nocaps

case $WMANAGER in
    xmonad)
        xmonad
        ;;
    wmaker)
        wmaker
        ;;
    *)
        awesome -c $HOME/.config/awesome/awesome.lua
esac

#:wq[ "$WMANAGER" = "xmonad" ] && ~/.cabal/bin/xmonad || awesome -c $HOME/.config/awesome/awesome.lua
