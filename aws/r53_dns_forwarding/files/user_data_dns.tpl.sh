#!/bin/bash -xe
yum install bind bind-utils -y
cat <<EOF > /etc/named.conf
options {
    directory	"/var/named";
    dump-file	"/var/named/data/cache_dump.db";
    statistics-file "/var/named/data/named_stats.txt";
    memstatistics-file "/var/named/data/named_mem_stats.txt";
    allow-query { any; };
    recursion yes;
    forward first;
    forwarders {
        ${FORWARDER_IP};
    };
    dnssec-enable yes;
    dnssec-validation yes;
    dnssec-lookaside auto;
    /* Path to ISC DLV key */
    bindkeys-file "/etc/named.iscdlv.key";
    managed-keys-directory "/var/named/dynamic";
};
zone "onprem.privatezone.org" IN {
    type master;
    file "onprem.privatezone.org.zone";
    allow-update { none; };
};
zone "aws.privatezone.org" { 
  type forward; 
  forward only;
  forwarders { ${INBOUND_IP1}; ${INBOUND_IP2}; }; 
};
EOF

cat <<EOF > /var/named/onprem.privatezone.org.zone
\$TTL 86400
@   IN  SOA     ns1.mydomain.com. root.mydomain.com. (
        2013042201  ;Serial
        3600        ;Refresh
        1800        ;Retry
        604800      ;Expire
        86400       ;Minimum TTL
)
; Specify our two nameservers
    IN	NS		dnsA.onprem.privatezone.org.
    IN	NS		dnsB.onprem.privatezone.org.
; Resolve nameserver hostnames to IP, replace with your two droplet IP addresses.
dnsA	  IN	A		${DNS_IP_1}
dnsB	  IN	A		${DNS_IP_2}

; Define hostname -> IP pairs which you wish to resolve
@		IN	A	  ${APP_PRIVATE_IP}
app		IN	A	  ${APP_PRIVATE_IP}
EOF

named-checkzone /var/named/onprem.privatezone.org.zone

service named restart
chkconfig named on