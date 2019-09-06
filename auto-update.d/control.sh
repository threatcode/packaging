# This file is sourced by bin/auto-update

SOURCE=$(awk '/^Source:/ {print $2}' debian/control)
CURDIR_NAME=$(basename $PWD)

if [ "$CURDIR_NAME" != "$SOURCE" ]; then
    echo "WARNING: $PWD is not named after the source package ($SOURCE)"
fi

# Maintainer
if grep -q -E "Maintainer: .*(kali|offensive-security|hertzog|sophie@freexian)" debian/control; then
    sed -i -e "s|^Maintainer: .*|Maintainer: Kali Developers <devel@kali.org>|i" debian/control
else
    sed -i -e "s|^Maintainer: \(.*\)|XSBC-Original-Maintainer: \1\nMaintainer: Kali Developers <devel@kali.org>|i" debian/control
fi
record_change "Update Maintainer field" debian/control

# Vcs-*
sed -i \
    -e "s|^Vcs-Git: .*|Vcs-Git: https://gitlab.com/kalilinux/packages/$SOURCE.git|i" \
    -e "s|^Vcs-Browser: .*|Vcs-Browser: https://gitlab.com/kalilinux/packages/$SOURCE|i" \
    debian/control
record_change "Update Vcs-* fields" debian/control

# Homepage
sed -i \
    -e "s|^Homepage: http://www.kali.org|Homepage: https://www.kali.org|i" \
    debian/control
if [ -e debian/copyright ]; then
    sed -i \
	-e "s|^Source: http://www.kali.org|Source: https://www.kali.org|i" \
	debian/copyright
    extra=debian/copyright
fi
record_change "Use HTTPS url for www.kali.org" debian/control $extra
