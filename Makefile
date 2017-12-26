DESTDIR?=/usr/local
install:
	cp issue-certs-nginx $(DESTDIR)/bin/issue-certs-nginx
	cp letsencrypt /etc/nginx/letsencrypt
	cp letsencryptdomains /etc/nginx/letsencryptdomains

.PHONY: install
