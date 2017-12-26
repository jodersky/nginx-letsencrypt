#
# Regular cron jobs for the nginx-letsencrypt package
#
0 4	* * *	root	[ -x /usr/bin/nginx-letsencrypt_maintenance ] && /usr/bin/nginx-letsencrypt_maintenance
