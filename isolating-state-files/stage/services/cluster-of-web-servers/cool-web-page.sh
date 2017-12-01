#!/bin/bash

cat > index.html << EOF
<h1> Welcome to my cool web page! </h1>
<p> This page has a DB address: ${db_address} and Port: ${db_port}</p>
EOF

nohup busybox httpd -f -p "${server_port}" &
