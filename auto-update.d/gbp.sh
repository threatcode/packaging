# This file is sourced by bin/auto-update

gbp_conf=debian/gbp.conf

# Add a debian/gbp.conf file
if [ ! -e $gbp_conf ] || ! grep -q kali $gbp_conf || ! grep -q debian-tag $gbp_conf; then
    cat >$gbp_conf <<END
[DEFAULT]
debian-branch = kali/master
debian-tag = kali/%(version)s
pristine-tar = True

[pq]
patch-numbers = False

[dch]
multimaint-merge = True
END
    record_change "Configure git-buildpackage for Kali" $gbp_conf
fi

if [ -e $gbp_conf ] && grep -q "XSBC-Original-Maintainer:" debian/control && ! grep -q "\[import-dsc\]" $gbp_conf; then
    cat >>$gbp_conf << END

[import-dsc]
debian-branch = debian
debian-tag = debian/%(version)s
END
    record_change "Configure gbp import-dsc for a Debian-derived package" $gbp_conf
fi
