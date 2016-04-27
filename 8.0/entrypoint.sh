#!/bin/bash

set -e
set -x

# set odoo database host, port, user and password
: ${PGHOST:=$DB_PORT_5432_TCP_ADDR}
: ${PGPORT:=$DB_PORT_5432_TCP_PORT}
: ${PGUSER:=${DB_ENV_POSTGRES_USER:='postgres'}}
: ${PGPASSWORD:=$DB_ENV_POSTGRES_PASSWORD}
export PGHOST PGPORT PGUSER PGPASSWORD

if [[ ! -d /var/lib/odoo/etc ]]; then
   mkdir -p /var/lib/odoo/etc
   mv /etc/odoo/openerp-server.conf /var/lib/odoo/etc/openerp-server.conf
fi
rm -f /etc/odoo/openerp-server.conf
ln -s /var/lib/odoo/etc/openerp-server.conf /etc/odoo/openerp-server.conf
chown -R odoo /etc/odoo /var/lib/odoo

case "$1" in
	--)
		shift
		exec gosu odoo openerp-server "$@"
		;;
	-*)
		exec gosu odoo openerp-server "$@"
		;;
	*)
		exec gosu odoo "$@"
esac

exit 1
