#!/bin/bash

checkinstall_custom() {
	pkgname=$1
	pkgversion=$2
	srcdir=`pwd`
	checkinstall \
		-y \
		--pkgname "${pkgname}-${PKG_SUFFIX}" \
		--pkgversion "$pkgversion" \
		--pkgrelease "$PKG_RELEASE" \
		--pkgsource "$srcdir" \
		--maintainer "$PKG_MAINTAINER" \
		--addso
}

checkinstall_custom "$@"
