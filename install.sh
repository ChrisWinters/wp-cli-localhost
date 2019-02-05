#! /bin/bash
#
# Install WP-Cli-Localhost
#
# @cmd ./install.sh
#
# 1) Updates .bashrc
# 2) Creates config.sh
# 3) Creates domains.log
# 4) Sets File Permissions
#
# @version 1.0.0
#
# @author Chris Winters https://github.com/ChrisWinters
#
# MIT License
# https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/LICENSE

# Source Config File
source domain-config.sh


# Update .bashrc if domain function not set
update_bashrc() {
	if [[ -n "$(type -t domain)" ]] && [[ "$(type -t domain)" = function ]]; then
		printf "==> WP-Cli-Localhost Already Installed\n"
		printf "===> To Configure, open: config.sh\n\n"
		printf "      Commands To Use:\n"
		printf "        Install: domain install domainname.extension\n"
		printf "        Remove : domain remove domainname.extension\n"
		printf "        Update : domain update domainname.extension\n"
		printf "        Update : domain update all\n\n"

		create_domain_list_log
		create_user_config
		update_permissions
	else
		# Add Function To .bashrc
		echo -e  "
# Domain Shell Function
domain() {
    # Two Args Required
    if [[ \$# -ne 2 ]]; then
        echo \$0: \"example ==> domain install|remove|update domainname.extension\"
        return 1
    fi

    DIR=\$(pwd);

    # Install Domain
    if [[ \$1 == \"install\" ]] && [[ \$2 != \"\" ]]; then
        cd ${WP_CLI_LOCALHOST_PATH}
        ./domain-install.sh \$2
    fi

    # Remove Domain
    if [[ \$1 == \"remove\" ]] && [[ \$2 != \"\" ]]; then
        cd ${WP_CLI_LOCALHOST_PATH}
        ./domain-remove.sh \$2
    fi

    #Update Domain(s)
    if [[ \$1 == \"update\" ]]; then
        cd ${WP_CLI_LOCALHOST_PATH}

        # Update All Domains
        if [[ \$2 == \"all\" ]]; then
            ./domain-update.sh all
        fi

        # Update A Domain
        if [[ \$2 != \"all\" && -d \"\${SITE_PATH}/${2}\" ]]; then
            ./domain-update.sh \$2
        fi
    fi

	cd \${DIR};
}

# Export Alias
export -f domain \$@
">> ~/.bashrc

		if [[ -z "$PS1" ]] ; then
			printf "\n\n"
		    printf "==> Almost Finished, type: source $HOME/.bashrc\n"
		    printf "===> To Configure, open: config.sh\n\n"
			printf "      Then Use The Commands Below:\n"
			printf "        Install: domain install domainname.extension\n"
			printf "        Remove : domain remove domainname.extension\n"
			printf "        Update : domain update domainname.extension\n"
			printf "        Update : domain update all\n\n"
		else
			source $HOME/.bashrc
			printf "==> WP-Cli-Localhost Installed\n"
		    printf "===> To Configure, open: config.sh\n\n"
			printf "      Commands To Use:\n"
			printf "        Install: domain install domainname.extension\n"
			printf "        Remove : domain remove domainname.extension\n"
			printf "        Update : domain update domainname.extension\n"
			printf "        Update : domain update all\n\n"
		fi

		create_domain_list_log
		create_user_config
		update_permissions
	fi
}


# Create Domains Log File
create_domain_list_log() {
	if [[ ! -f ${DOMAINS_LIST} ]]; then
		echo "" > ${DOMAINS_LIST}
	fi
}


# Create User config.sh File
create_user_config() {
	if [[ ! -f ${WP_CLI_LOCALHOST_PATH}/config.sh ]]; then
		touch ${WP_CLI_LOCALHOST_PATH}/config.sh
		cat > ${WP_CLI_LOCALHOST_PATH}/config.sh <<EOF
#! /bin/bash
#
# User Configuration File | This File Was Generated When WP-Cli-Localhost Was Installed
# Override Variables From domain-config.sh
#

# Database Login Details
DB_USER="root";
DB_PASS="PASSWORD";
DB_HOST="localhost";

# WordPress Super User
ADMIN_USER="WORDPRESS";
ADMIN_PASS="WORDPRESS";
ADMIN_EMAIL="nobody@domain.com";

# WordPress GMT Offset
GMT_OFFSET="-4";

# WordPress Category Base
CATEGORY_BASE="/topics";

# Default WordPress Category Name & Slug
CATEGORY_NAME="Updates";
CATEGORY_SLUG="updates";

# WordPress Tag Base
TAG_BASE="/tags";
EOF
	fi
}


# Update File Permissions
update_permissions() {
	chmod 755 ${WP_CLI_LOCALHOST_PATH}
	chmod 644 ${WP_CLI_LOCALHOST_PATH}/backtrace.php
	chmod 644 ${WP_CLI_LOCALHOST_PATH}/config.sh; chmod +x ${WP_CLI_LOCALHOST_PATH}/config.sh;
	chmod 644 ${WP_CLI_LOCALHOST_PATH}/domain-config.sh; chmod +x ${WP_CLI_LOCALHOST_PATH}/domain-config.sh;
	chmod 644 ${WP_CLI_LOCALHOST_PATH}/domain-install.sh; chmod +x ${WP_CLI_LOCALHOST_PATH}/domain-install.sh;
	chmod 644 ${WP_CLI_LOCALHOST_PATH}/domain-remove.sh; chmod +x ${WP_CLI_LOCALHOST_PATH}/domain-remove.sh;
	chmod 644 ${WP_CLI_LOCALHOST_PATH}/domain-update.sh; chmod +x ${WP_CLI_LOCALHOST_PATH}/domain-update.sh;
}


# Run Install
function install() {
	# Start Display
	clear

	printf "\n\n"

	read -p "== Press [y] to setup WP-Cli-Localhost " -n 1 -r

	printf "\n\n"

	if [[ $REPLY =~ ^[Yy]$ ]]; then

		update_bashrc

	fi
}

install
