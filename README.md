# nginx-letsencrypt

Simplify the process of setting up nginx with letsencrypt in a
configuration managed environment.

## Motiviation

Letsencrypt's `certbot` utility makes the process of obtaining domain
validated TLS certificates a breeze. It implements the ACME client
protocol and offers multiple options to perform said domain
validation. Unfortunately however, none of the options provided enable
streamlined issuing of certificates in a managed nginx configuration
environment:

- The built-in `--nginx` flag works well, however it mutates nginx
  configuration files which doesn't play nice with configuration
  management tools that assume immutable files.

- The manual "certonly" modes can be setup with immutable
  configuration, however they require either manual bootstrapping or
  additional configuration:
  - standalone: requires shutting down nginx (for issuing and renewal)
  - dns verification: requires the server to have access to DNS
    configuration. This requires isolation of DNS management to
    domains associated with a given server.
  - webroot: does not require a server shutdown and offers isolation,
    however it requires manual intervention to bootstrap a system with
    an initial certificate, since nginx will not start if the `ssl`
    directive is set and there are no certificates. (Therefore, one
    would be required to first configure the webroot, run certbot and
    then add an ssl entry).

The solution proposed by nginx-letsencrypt is to combine the webroot
"certonly" modus operandi with self-signed bootstrapping certificates
and an includable ssl configuration file.
	
## Overview
nginx-letsencrypt comes in two parts: an nginx configuration file
"letsencrypt" that should be included by server blocks that enable
HTTPS, and a shell-script "nginx-letsencrypt" that wraps
certbot. Server configuration blocks (in /etc/nginx/sites-enabled)
include the letsencrypt ssl configuration file and the wrapper script
takes care of issuing a certificate for all domains use by virtual
hosts.

## Usage
A certificate will be issued for all server names defined in server
blocks that contain 'include letsencrypt'. Obtaining certificates
requires the following steps:

1. Add `include letsencrypt;` to all server blocks that should enable
   HTTPS.
2. Run `nginx-letsencrypt`.

*Note regarding certificate renewal: certbot will automatically add a
cron entry to renew certificates. No manual intervention is needed.*

## Example
Given the following server block configuration in
/etc/nginx/sites-enabled/server:

    server {
        server_name foo.example.org bar.example.com;
        listen 80;
	    listen [::]:80;
	    include letsencrypt;

        root /srv/www;
		location / {
		    index index.html;
		}
    }
	
Running `nginx-letsencrypt` will issue certificates for
"foo.example.org" and "bar.example.com".

## Copying
This project is released under the terms of the GPL license. See
LICENSE for details.
