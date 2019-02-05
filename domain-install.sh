#! /bin/bash
#
# Automatic Localhost Domain & WordPress Setup
#
# @cmd domain install domainname.extension
#
# 01) Downloads & Installs WordPress
# 02) Creates WordPress Database
# 03) Creates wp-config.php File
# 04) Automatic 5 Minute Install
# 05) Creates .htaccess & php.ini
# 06) Downloads & Installs Dev Plugins
# 07) Cleans Up WordPress
# 08) Setup WordPress
# 09) Update /etc/hosts File
# 10) Update & Restart Apache
# 11) Logs Installed Domain
#
# @version 1.0.0
#
# @author Chris Winters https://github.com/ChrisWinters
#
# MIT License
# https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/LICENSE

# Source Config File
source domain-config.sh


# Check If User Config Is Configured
function config_check() {
	if [[ $DB_PASS == "PASSWORD" || $DB_PASS == "" ]]; then
	    echo "Error: MySQL and WordPress login details need to be set in the config.sh first."
	    return 1
	fi
}


# Download & unploack WordPress
function wp_core_download() {
	printf "===> Downloading And Unpacking WordPress\n"
	wp core download --path=${LOCAL_DOMAIN_PATH} --quiet
}


# Create Local Database
function mysql_create_database() {
	printf "===> Creating Database: ${DB_NAME}\n"
	mysql --login-path=local -e "CREATE DATABASE ${DB_NAME}"
}


# Setup wp-config.php file
function wp_core_config() {
	printf "===> Creating Configuration File\n"

	wp core config --path=${LOCAL_DOMAIN_PATH} --dbname=${DB_NAME} --dbuser=${DB_USER} --dbpass=${DB_PASS} --quiet --extra-php <<PHP
define('WP_MEMORY_LIMIT', '256M');
define('WP_HTTP_BLOCK_EXTERNAL', false);
define('WP_ACCESSIBLE_HOSTS', 'api.wordpress.org');
define('FS_METHOD', 'direct');
define('ALLOW_UNFILTERED_UPLOADS', true);
@ini_set( 'error_log', '${SITE_PATH}/error.log' );
require_once '${WP_CLI_LOCALHOST_PATH}/backtrace.php';
PHP
}


# Install WordPress & Setup Admin
function wp_core_install() {
	printf "===> Installing WordPress; Please Wait...\n"
	wp core install --path=${LOCAL_DOMAIN_PATH} --url=${LOCAL_DOMAIN_URL} --title=${DOMAIN} --admin_user=${ADMIN_USER} --admin_password=${ADMIN_PASS} --admin_email=${ADMIN_EMAIL} --skip-email --quiet
}


# Create .htacccess & php.ini file
function create_htaccess_php_ini() {
	printf "===> Creating .htaccess And php.ini Files\n"

	echo "# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress" >> ${LOCAL_DOMAIN_PATH}/.htaccess

	# Limited For Dev
	echo "upload_max_filesize = 12M
post_max_size = 13M
memory_limit = 15M" >> ${LOCAL_DOMAIN_PATH}/php.ini
}


# Install Helper Plugins
function wp_plugin_install() {
	printf "===> Downloading And Unpacking Plugins; Please Wait...\n"

	wp plugin install advanced-database-cleaner --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install log-deprecated-notices --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install wordpress-importer --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install advanced-wp-reset --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install debug-bar-cron --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install query-monitor --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install theme-check --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install wp-crontrol --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install rtl-tester --path=${LOCAL_DOMAIN_PATH} --quiet

	wp plugin install debug-bar --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install debug-bar-console --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install debug-bar-extender --path=${LOCAL_DOMAIN_PATH} --quiet

	wp plugin install classic-editor --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin install classic-editor-addon --path=${LOCAL_DOMAIN_PATH} --quiet
}


# Cleanup WordPress Install
function cleanup_wordpress() {
	printf "===> Cleaning Up WordPress\n"

	wp theme delete twentyseventeen --path=${LOCAL_DOMAIN_PATH} --quiet
	wp theme delete twentyfifteen --path=${LOCAL_DOMAIN_PATH} --quiet
	wp theme delete twentysixteen --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin delete akismet --path=${LOCAL_DOMAIN_PATH} --quiet
	wp plugin delete hello --path=${LOCAL_DOMAIN_PATH} --quiet
	rm ${LOCAL_DOMAIN_PATH}/wp-config-sample.php
	rm ${LOCAL_DOMAIN_PATH}/readme.html
	rm ${LOCAL_DOMAIN_PATH}/license.txt
}


# Setup WordPress
function setup_wordpress() {
	printf "===> Setting Up WordPress; Please Wait...\n"

	wp comment delete 1 --path=${LOCAL_DOMAIN_PATH} --force --quiet
	wp post delete 1 --path=${LOCAL_DOMAIN_PATH} --force --quiet
	wp post delete 2 --path=${LOCAL_DOMAIN_PATH} --force --quiet
	wp post delete 3 --path=${LOCAL_DOMAIN_PATH} --force --quiet

	wp option delete mailserver_login --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option delete mailserver_pass --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option delete mailserver_port --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option delete mailserver_url --path=${LOCAL_DOMAIN_PATH} --quiet

	wp option update gmt_offset $GMT_OFFSET --path=${LOCAL_DOMAIN_PATH} --quiet

	wp term update category 1 --name=$CATEGORY_NAME --slug=$CATEGORY_SLUG --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update permalink_structure $PERMALINK --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update category_base $CATEGORY_BASE --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update tag_base $TAG_BASE --path=${LOCAL_DOMAIN_PATH} --quiet

	wp option update ping_sites "" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update avatar_default "blank" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update close_comments_days_old "365" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update close_comments_for_old_posts "1" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update comment_moderation "1" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update comment_registration "1" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update thread_comments "1" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update show_avatars "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update use_smilies "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update uploads_use_yearmonth_folders "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update thumbnail_crop "" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update thumbnail_size_h "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update thumbnail_size_w "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update large_size_h "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update large_size_w "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update medium_large_size_h "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update medium_large_size_w "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update medium_size_h "0" --path=${LOCAL_DOMAIN_PATH} --quiet
	wp option update medium_size_w "0" --path=${LOCAL_DOMAIN_PATH} --quiet

	wp transient delete --all --path=${LOCAL_DOMAIN_PATH} --quiet
}


# Update Local Hosts File
function update_hosts_file() {
	if grep -q "${DOMAIN}" /etc/hosts; then
		printf "===> Domain Found Within Hosts Entry\n"
	else
		printf "===> Adding Hosts Entry; You May Need To Enter Your Password\n"
		sudo sh -c "echo ${HOSTS_ENTRY} >> /etc/hosts"

		if grep -q "${DOMAIN}" /etc/hosts; then
			printf "===> Domain Added To /etc/hosts\n"
		else
			printf "===> Manual Action Required: echo \"${HOSTS_ENTRY}\" | sudo sh -c tee -a /etc/hosts > /dev/null\n"
		fi
	fi
}


# Update Apache
function update_apache() {
	printf "===> Adding Domain To Apache; You May Need To Enter Your Password\n"

	sudo sh -c "echo '<VirtualHost *:80>
	ServerName ${DOMAIN}
	ServerAlias www.${DOMAIN}
	DocumentRoot /var/www/html/${DOMAIN}
	<Directory /var/www/html/${DOMAIN}/>
	Options -Indexes +FollowSymLinks
	AllowOverride All AuthConfig
	Order allow,deny
	allow from all
	</Directory>
	</VirtualHost>' >> /etc/apache2/sites-available/${DOMAIN}.conf"

	sudo sh -c "ln -sfn ../sites-available/${DOMAIN}.conf /etc/apache2/sites-enabled/${DOMAIN}.conf"

	printf "===> Restarting Apache\n"

	sudo sh -c "apache2ctl -k graceful"
}


# Log Domain
function log_domain() {
	echo ${DOMAIN} >> ${DOMAINS_LIST}
	printf "===> Domain Logged\n"
}


# Run Install Domain
function install_domain() {
	# Required
    if [[ $1 == "" ]]; then
	    echo $0: "example ==> domain install domainname.extension"
	    return 1
    fi

    # Check User Config Is Setup
	config_check

	# Start Display
	clear

	printf "\n\n"

	read -p "== Press [y] to setup ${LOCAL_DOMAIN_URL} " -n 1 -r

	printf "\n"

	if [[ $REPLY =~ ^[Yy]$ ]]; then
		wp_core_download
		mysql_create_database
		wp_core_config
		wp_core_install
		create_htaccess_php_ini
		wp_plugin_install
		cleanup_wordpress
		setup_wordpress
		update_hosts_file
		update_apache
		log_domain

		printf "===> Domain Ready: ${LOCAL_DOMAIN_URL}/wp-admin/\n\n"
	fi
}

install_domain $@
