#! /bin/bash
#
# Update WordPress, Plugins & Themes
#
# @cmd domain update domainname.extension
# @cmd domain update
#
# @version 1.0.0
#
# @author Chris Winters https://github.com/ChrisWinters
#
# MIT License
# https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/LICENSE

# Run Updater
update() {
	# Source Config File
	source domain-config.sh

	# Required
    if [[ $1 == "" ]]; then
	    echo $0: "example ==> domain update all"
	    echo $0: "example ==> domain update domainname.extension"
	    return 1
    fi

	# Required
    if [[ $1 != "all" && ! -d ${SITE_PATH}/${1} ]]; then
	    echo $0: "example ==> domain update all"
	    echo $0: "example ==> domain update domainname.extension"
	    return 1
    fi

    # Update All Domains
    if [[ $1 == "all" ]]; then
		while read DOMAIN_NAME; do
			printf "\n==> Updating: ${DOMAIN_NAME}\n"
			wp core update --path=${SITE_PATH}/${DOMAIN_NAME}
			wp plugin update --path=${SITE_PATH}/${DOMAIN_NAME} --all
			wp theme update --path=${SITE_PATH}/${DOMAIN_NAME} --all
			printf "\n"
		done < ${WP_CLI_LOCALHOST_PATH}/domains.log
	fi

	# Update Single Domain
	if [[ $1 != "" && -d ${SITE_PATH}/${1} ]]; then
		printf "\n==> Updating: ${1}\n"
		wp core update --path=${SITE_PATH}/${1}
		wp plugin update --path=${SITE_PATH}/${1} --all
		wp theme update --path=${SITE_PATH}/${1} --all
		printf "\n"
	fi
}

update $@
