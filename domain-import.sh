#! /bin/bash
#
# Download / Install Theme Unit Test Data
#
# @cmd domain import domainname.extension
#
# @version 1.0.0
#
# @author Chris Winters https://github.com/ChrisWinters
#
# MIT License
# https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/LICENSE

# Source Config File
source domain-config.sh


# Download Unit Test Data
function get_xml_file() {
	if [[ ! -f themeunittestdata.wordpress.xml ]]; then
		wget https://raw.githubusercontent.com/WPTRT/theme-unit-test/master/themeunittestdata.wordpress.xml
		printf "===> Theme Unit Test Data XML File Downloaded\n"
	fi
}


# Active WordPress Importer Plugin
function activate_importer () {
	wp plugin install wordpress-importer --activate --path=${LOCAL_DOMAIN_PATH}
	printf "===> WordPress Importer Activated\n"
}


# Run WP Import
function wp_import () {
	printf "===> Starting Import, This Will Take A Few Minutes...\n\n"
	wp import themeunittestdata.wordpress.xml --authors=create --path=${LOCAL_DOMAIN_PATH}
	printf "\n===> Import Completed\n"
}


# Run Remove Domain
function import() {
	# Required
    if [[ $1 == "" ]]; then
	    echo $0: "example ==> domain import domainname.extension"
	    return 1
    fi

	# Start Display
	clear

	printf "\n\n"

	read -p "== Press [y] to IMPORT Theme Unit Test Data for ${LOCAL_DOMAIN_URL} " -n 1 -r

	printf "\n"

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		get_xml_file
		activate_importer
		wp_import

		printf "===> Ctrl+Click to open: ${LOCAL_DOMAIN_URL}\n\n"
	fi
}

import $@
