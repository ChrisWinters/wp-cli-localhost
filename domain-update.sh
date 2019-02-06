#! /bin/bash
#
# Update WordPress, Plugins & Themes
#
# @cmd domain update all
# @cmd domain update domainname.extension
#
# @version 1.0.0
#
# @author Chris Winters https://github.com/ChrisWinters
#
# MIT License
# https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/LICENSE

# Run Updater
update() {
	# Required
    if [[ $1 == "" ]]; then
	    echo $0: "=domain=> usage example: domain update all"
	    echo $0: "                         domain update domainname.extension"
	    return 1
    fi

	# Source Config File
	source domain-config.sh

	# Required
    if [[ $1 != "all" && ! -d ${SITE_PATH}/${1} ]]; then
	    echo $0: "=domain=> usage example: domain update all"
	    echo $0: "                         domain update domainname.extension"
	    return 1
    fi

    # Update All Domains
    if [[ $1 == "all" ]]; then
		printf "\n=domain=> Updating All Domains\n"
		sleep 1

		while read DOMAIN_NAME; do
			printf "==> Updating: ${DOMAIN_NAME}\n"
			wp core update --path=${SITE_PATH}/${DOMAIN_NAME}
			wp plugin update --path=${SITE_PATH}/${DOMAIN_NAME} --all
			wp theme update --path=${SITE_PATH}/${DOMAIN_NAME} --all
		done < ${WP_CLI_LOCALHOST_PATH}/domains.log

		printf "\n=domain=> Update Completed\n\n"
	fi

	# Update Single Domain
	if [[ $1 != "" && -d ${SITE_PATH}/${1} ]]; then
		printf "=domain=> Updating ${1}\n"
		sleep 1

		wp core update --path=${SITE_PATH}/${1}
		wp plugin update --path=${SITE_PATH}/${1} --all
		wp theme update --path=${SITE_PATH}/${1} --all

		printf "\n=domain=> Update Completed\n\n"
	fi
}

update $@
