<?php
/**
 * == About this Gist ==
 * 
 * Code to add to wp-config.php to enhance information available for debugging.
 * You would typically add this code below the database, language and salt settings
 * 
 * Oh.. and *do* make sure you change the path to the log file to a proper file path on your server (make sure it exists).
 * 
 * Set WP_DEBUG_DISPLAY to false if you don't want errors displayed on the screen.
 * Independently of the WP_DEBUG settings, PHP errors, warnings and notices should now appear in your error.log file.
 * 
 * == DO == test whether it's all working by using the code at the end of the gist.
 * 
 * If error logging is not working, try:
 * - Check if the file was created at all, if not, upload an empty (text) file named error.log and try again.
 * - Fiddle around with the CHMOD settings for the error.log file to see what permissions are needed for your server setup.
 * - If you put the error.log outside of the web root: this will not work in all server setups. You may need to move the directory & file to be within the web root.
 *
 * Source: https://gist.github.com/jrfnl/5925642
 */

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */

/**
 * Turn on WP error reporting.
 */
define( 'WP_DEBUG', true );



/**
 * [Optional] Load the development (non-minified) versions of all standard WP scripts and CSS, and disables compression and concatenation.
 *
 * This setting is often also respected by themes and plugins, but no guarantee!
 */
// define( 'SCRIPT_DEBUG', true );


/**
 * [Optional] Save queries for analysis
 * The SAVEQUERIES definition saves the database queries to an array and that array
 * can be displayed to help analyze those queries. The information saves each query,
 * what function called it, and how long that query took to execute.
 *
 * NOTE: This will have a performance impact on your site, so make sure to turn this
 * off when you aren't debugging.
 *
 * To get access to the information, you can add the following snippet to the footer of your theme:
 *
 * <?php
 *	if ( current_user_can( 'administrator' ) ) {
 * 		global $wpdb;
 * 		echo "<pre>";
 * 		print_r($wpdb->queries);
 * 		echo "</pre>";
 *	}
 * ?>
 */
// define('SAVEQUERIES', true);



/**
 * Turn on error logging and show errors on-screen if in debugging mode.
 */
@error_reporting( -1 ); // everything, including E_STRICT and other newly introduced error levels.
@ini_set( 'log_errors', true );
@ini_set( 'log_errors_max_len', '0' );

/**
 * Change the path to one on your webserver, the directory does not have to be in the web root
 * Don't forget to CHMOD this dir+file and add an .htaccess file denying access to all
 * For an example .htaccess file, see https://gist.github.com/jrfnl/5953256
 */
//@ini_set( 'error_log', '/path/to/writable/file/logs/error.log' );

if ( WP_DEBUG !== true ) {
	@ini_set( 'display_errors', false ); // Don't show errors on screen
}
else {
	@ini_set( 'display_errors', true ); // Show errors on screen
	@ini_set( 'html_errors', true );
	@ini_set( 'docref_root', 'http://php.net/manual/' );
	@ini_set( 'docref_ext', '.php' );
	if ( ! extension_loaded( 'xdebug' ) ) {
		@ini_set( 'error_prepend_string', '<span style="color: #ff0000; background-color: transparent;">' );
		@ini_set( 'error_append_string', '</span>' );
	}
}


/**
 * Adds a backtrace to PHP errors.
 * 
 * Copied from: https://gist.github.com/625769
 * Forked from: http://stackoverflow.com/questions/1159216/how-can-i-get-php-to-produce-a-backtrace-upon-errors/1159235#1159235
 * Adjusted by jrfnl.
 */
if ( ! function_exists( 'jrf_process_error_backtrace' ) ) {
	function jrf_process_error_backtrace( $errno, $errstr, $errfile, $errline ) {
		/*
		 * Only show errors which are within the scope of the current error_reporting() setting.
		 * As WP (and plugins/themes) sometimes change the error level, you may want to comment
		 * this out if you want to be sure to see all errors.
		 */
		if( ! ( error_reporting() & $errno ) ) {
			return;
		}

		/**
		 * Make sure all error levels are present. PHP 5.2 compatibility.
		 */
		if ( ! defined( 'E_DEPRECATED' ) ) {
			define( 'E_DEPRECATED', 8192 );
		}
		if ( ! defined( 'E_USER_DEPRECATED' ) )	{
			define( 'E_USER_DEPRECATED', 16384 );
		}
		
	
		switch ( $errno ) {
			case E_WARNING	    :
			case E_USER_WARNING :
			case E_STRICT	       :
			case E_NOTICE	       :
			case E_USER_NOTICE     :
			case E_DEPRECATED      :
			case E_USER_DEPRECATED :
				$type  = 'warning';
				$fatal = false;
				break;
			default			 :
				$type  = 'fatal error';
				$fatal = true;
				break;
		}
		$trace = debug_backtrace();
		array_shift( $trace );
		if ( php_sapi_name() == 'cli' && ini_get( 'display_errors' ) ) {
			echo 'Backtrace from ' . $type . ' \'' . $errstr . '\' at ' . $errfile . ' ' . $errline . ':' . "\n";
			foreach ( $trace as $item ) {
				echo '  ' . ( isset( $item['file'] ) ? $item['file'] : '<unknown file>' ) . ' ' . ( isset( $item['line'] ) ? $item['line'] : '<unknown line>' ) . ' calling ' . $item['function'] . '()' . "\n";
			}
		}
		elseif ( ini_get( 'display_errors' ) ) {
			echo '<p class="error_backtrace">' . "\n";
			echo '  Backtrace from ' . $type . ' \'' . $errstr . '\' at ' . $errfile . ' ' . $errline . ':' . "\n";
			echo '</p>' . "\n";
			echo '<ol class="error_backtrace_list">' . "\n";
			foreach ( $trace as $item ) {
				echo '	<li>' . ( isset( $item['file'] ) ? $item['file'] : '<unknown file>' ) . ' ' . ( isset( $item['line'] ) ? $item['line'] : '<unknown line>' ) . ' calling ' . $item['function'] . '()</li>' . "\n";
			}
			echo '</ol>' . "\n";
		}
		if (  ini_get( 'log_errors' ) ) {
			$items = array();
			foreach ( $trace as $item ) {
				$items[] = ( isset( $item['file'] ) ? $item['file'] : '<unknown file>' ) . ' ' . ( isset( $item['line'] ) ? $item['line'] : '<unknown line>' ) . ' calling ' . $item['function'] . '()';
			}
			$message = 'Backtrace from ' . $type . ' \'' . $errstr . '\' at ' . $errfile . ' ' . $errline . ': ' . trim( join( ' | ', $items ) );
			error_log( $message );
		}
	
		flush();

		if ( $fatal ) {
			exit( 1 );
		}

		return false; // Make sure it plays nice with other error handlers (remove if no other error handlers are set).
	}

	set_error_handler( 'jrf_process_error_backtrace' );
}


/**
 * Now test whether it all works by uncommenting the below line
 *
 * If all is well:
 * - With WP_DEBUG set to true: You should see a red error notice on your screen 
 * - Independently of the WP_DEBUG setting, the below 'error'-message should have been written to your log file. *Do* check whether it has been....
 */
//trigger_error( 'Testing 1..2..3.. Debugging code is working!', E_USER_NOTICE );
