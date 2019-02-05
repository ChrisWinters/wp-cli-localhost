#! /bin/bash
#
# Automatic Localhost Domain & WordPress Removal
#
# @cmd domain remove domainname.extension
#
# 01) Delete WordPress
# 02) Delete WordPress Database
# 03) Update /etc/hosts File
# 04) Update & Restart Apache
# 05) Remove Domain From Domain Log
#
# @version 1.0.0
#
# @author Chris Winters https://github.com/ChrisWinters
#
# MIT License
# https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/LICENSE

# Source Config File
source domain-config.sh


# Remove lcoal domain directory
function remove_local_domain(){
	if [[ -d "${SITE_PATH}/${DOMAIN}" ]]; then
		rm -rf ${SITE_PATH}/${DOMAIN}/
		printf "===> Removed WordPress\n"
	fi
}


# Remove database
function remove_database(){
	mysql --login-path=local -e "DROP DATABASE $DB_NAME"
	printf "===> Removed Database $DB_NAME\n"
}


# Update /etc/hosts
function update_hosts_file() {
	printf "===> Updating Hosts Entry; You May Need To Enter Your Password\n"

	sudo sh -c "grep -Fxv \"${HOSTS_ENTRY}\" /etc/hosts > /etc/hosts.temp"

	if [[ -f "/etc/hosts.temp" ]]; then
		sudo sh -c "cp /etc/hosts.temp /etc/hosts"
		sudo sh -c "rm /etc/hosts.temp"

		printf "===> Updated /etc/hosts\n"
	fi
}


# Remove domain from Apache
function update_apache(){
	printf "===> Removing Domain From Apache; You May Need To Enter Your Password\n"

	sudo sh -c "unlink /etc/apache2/sites-enabled/${DOMAIN}.conf"
	sudo sh -c "rm /etc/apache2/sites-available/${DOMAIN}.conf"

	printf "===> Restarting Apache\n"

	sudo sh -c "apache2ctl -k graceful"
}


# Update Domain Log
function update_log() {
	grep -Fxv "${DOMAIN}" ${DOMAINS_LIST} > ${DOMAINS_LIST}.temp

	if [[ -f "${DOMAINS_LIST}.temp" ]]; then
		cp ${DOMAINS_LIST}.temp ${DOMAINS_LIST}
		rm ${DOMAINS_LIST}.temp

		printf "===> Removed Domain From Log\n"
	fi
}


# Run Remove Domain
function remove_domain(){
	# Required
    if [[ $1 == "" ]]; then
	    echo $0: "example ==> domain remove domainname.extension"
	    return 1
    fi

	# Start Display
	clear

	printf "\n\n"

	read -p "== Press [y] to REMOVE ${LOCAL_DOMAIN_URL} " -n 1 -r

	printf "\n"

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		remove_local_domain
		remove_database
		update_hosts_file
		update_apache
		update_log

		printf "===> Domain ${DOMAIN} Removed\n\n"
	fi
}

remove_domain $@
