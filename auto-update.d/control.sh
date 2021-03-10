# This file is sourced by bin/auto-update

control_file=debian/control
copyright_file=debian/copyright

SOURCE=$(awk '/^Source:/ {print $2}' $control_file)
CURDIR_NAME=$(basename $PWD)

if [ "$CURDIR_NAME" != "$SOURCE" ]; then
    echo "WARNING: $PWD is not named after the source package ($SOURCE)"
fi

# Maintainer
if grep -q -E "Maintainer: .*(kali|offensive-security|hertzog|sophie@freexian)" $control_file; then
    sed -i -e "s|^Maintainer: .*|Maintainer: Kali Developers <devel@kali.org>|i" $control_file
else
    sed -i -e "s|^Maintainer: \(.*\)|XSBC-Original-Maintainer: \1\nMaintainer: Kali Developers <devel@kali.org>|i" $control_file
fi
record_change "Update Maintainer field" $control_file

# Vcs-*
sed -i \
    -e "s|^Vcs-Git: .*|Vcs-Git: https://gitlab.com/kalilinux/packages/$SOURCE.git|i" \
    -e "s|^Vcs-Browser: .*|Vcs-Browser: https://gitlab.com/kalilinux/packages/$SOURCE|i" \
    $control_file
record_change "Update Vcs-* fields" $control_file

# Homepage
sed -i \
    -e "s|^Homepage: http://www.kali.org|Homepage: https://www.kali.org|i" \
    $control_file
if [ -e $copyright_file ]; then
    sed -i \
	-e "s|^Source: http://www.kali.org|Source: https://www.kali.org|i" \
	$copyright_file
    extra=$copyright_file
fi
record_change "Use HTTPS url for www.kali.org" $control_file $extra
