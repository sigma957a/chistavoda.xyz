.PHONY: renew check install-hooks help

DOMAIN ?= chistavoda.xyz
export DOMAIN

help:
	@echo "make renew   — ./renew-wildcard.sh (preflight + renew if needed)"
	@echo "make check   — CHECK_ONLY=1 ./renew-wildcard.sh"
	@echo "make force   — FORCE=1 ./renew-wildcard.sh"
	@echo "Requires root + FORNEX_API in env (sudo -E)."

renew:
	sudo -E ./renew-wildcard.sh

check:
	sudo -E CHECK_ONLY=1 ./renew-wildcard.sh

force:
	sudo -E FORCE=1 ./renew-wildcard.sh

install-hooks:
	install -d /usr/local/lib/wildcard-ssl
	cp -a lib hooks renew-wildcard.sh /usr/local/lib/wildcard-ssl/
	chmod 755 /usr/local/lib/wildcard-ssl/renew-wildcard.sh \
	  /usr/local/lib/wildcard-ssl/hooks/*.sh
	ln -sfn /usr/local/lib/wildcard-ssl/renew-wildcard.sh /usr/local/sbin/renew-wildcard
	@echo "Installed: /usr/local/sbin/renew-wildcard"
