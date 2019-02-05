# Shell Scripts For WordPress Theme & WordPress Plugin Developers - WP-Cli-Localhost

Created for WordPress Theme and WordPress Plugin developers. WP-Cli-Localhost is a collection of shell scripts that interface with wp-cli to allow for quick and easy management of locally hosted WordPress websites.

1) Rapid Setup of Localhost Domain & WordPress
	* Automatically Updates Apache and /etc/hosts
	* Cleans WordPress Setup, No Content
	* Developer & Debug Plugins Installed
	* Advanced Debug Backtrace Configuration
2) Rapid Removal of Localhost Domain & WordPress 
	* WordPress, Database, Apache and Hosts Configurations
3) Automatically Update Localhost WordPress Installs
	* Automatically Loops Through Locally Created Domains
		* Or Directly Target A Domain
	* Automatically Updates WordPress, Themes, and Plugins
4) Run With Alias Shell Function Command "domain"
	* Works From Any Location


## Requirements

1) Requires a LAMP Stack (Linux, Apache, MySQL, PHP)
	* Built and tested on Linux Mint using Bash 4.3.11(1)-release
2) Requires [WP-CLI](https://wp-cli.org/)
	* Built using version 2.1.0

[Git](https://git-scm.com/downloads) is optional but recommended.


## Download / Clone

[Download](https://github.com/ChrisWinters/wp-cli-localhost/releases) or [clone](https://github.com/ChrisWinters/wp-cli-localhost.git) WP-Cli-Localhost to an accessible location for your user (not /Private), something like ``` ~/ ``` or the location of localhost domains ``` /var/www/html ```.

Then open the ``` wp-cli-localhost ``` directory.


## Installation

Set the proper file permission on the install.sh file and run the script.

```
cd wp-cli-localhost/
chmod +x install.sh
./install.sh
source ~/.bashrc
```

This will add the 'domain' shell function alias to your .bashrc file, and set the file permissions for all other shell scripts. As well, the files ``` domains.log ``` & ``` config.sh ``` were created, which have been added to the .gitignore file.

**Errors:** If you are still receiving permission errors, first try resetting the file permissions on the install.sh file ``` chmod 644 install.sh; chmod +x install.sh; ```. If you are still receiving errors, set the proper permissions on the /wp-cli-localhost/ directory: ``` cd ../; chmod 755 wp-cli-localhost; ```


## Configuration

Within the ``` wp-cli-localhost ``` directory open the user ``` config.sh ``` file in an editor. The settings within the user config.sh override the settings within domain-config.sh file.

The default config.sh includes settings typically used for WordPress installs.

01) DB_USER 			Update If Different
02) DB_PASS 			Set Proper Password
03) DB_HOST 			Update If Different
04) ADMIN_USER 			WordPress Admin Username
05) ADMIN_PASS 			WordPress Admin Password
06) ADMIN_EMAIL 		Set If Your Localhost Has Mail
07) GMT_OFFSET 			Your Local GMT Offset
08) CATEGORY_BASE 		WordPress Category Base	
09) CATEGORY_NAME 		WordPress Default Category Name
10) CATEGORY_SLUG 		WordPress Default Category Slug
11) TAG_BASE 			WordPress Tag Base


## Commands

Type 'domain' for a quick usage reference.

**Add or Remove A Domain and WordPress**
* Usage: domain add|del domain-name.extension
	* Example: domain add testdomain.localhost
	* Example: domain del testdomain.localhost

**Update WordPress, Themes, and Plugins**
* Usage: domain update all|domain-name.extension
	* Example: domain update all
	* Example: domain update testdomain.localhost


## Upgrading

Git users simply need to ``` git pull ``` the changes, otherwise [download](https://github.com/ChrisWinters/wp-cli-localhost/releases) the latest release and replace the files. The ``` config.sh ``` and ``` domains.log ``` files are unique to your install and need to remain in the active wp-cli-localhost location.

Check the [CHANGELOG.md](https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/CHANGELOG.md) for release notes.


## Removing

1) Delete the wp-cli-localhost directory
2) Optional: The domain() function was added to ``` ~/.bashrc ```
	* This function will not error if wp-cli-localhost is missing
	* To remove the domain function, edit your ``` ~/.bashrc ``` as root, delete the entire domain() function and the export line below the function. Once done type ``` source ~/.bashrc ```.


## Donations

If WP-Cli-Localhost saved you some time, helped you with your development needs, or if you would like to support my efforts, then I would gladly and greatly appreciate a donated cup of coffee. Thank you in advance for your support!

<a href="https://www.buymeacoffee.com/TavXZIxkm" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>


## To Do List

A wish list of things that may or may not get completed.

* Move install.sh to Makefile
* Move domains.log to NoSQL
* Add check for backtrace.php to make sure wp-config.php has permission to include from backtrace location
* Add version check command that responds with the current version and release version with update notice
* Port to various Operating Systems, starting with Windows 10


## Credits

Code to add to wp-config.php to enhance information available for debugging via [backtrace.php](https://gist.github.com/jrfnl/5925642)


## MIT License

[License](https://raw.githubusercontent.com/ChrisWinters/wp-cli-localhost/master/LICENSE)

Copyright 2019 Chris Winters https://github.com/ChrisWinters/

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
