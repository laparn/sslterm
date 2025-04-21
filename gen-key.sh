#!/bin/bash
mkdirhier localKeys
cd localKeys
openssl genpkey -algorithm RSA -out ca-key.pem
openssl req -new -x509 -key ca-key.pem -out ca-cert.pem -days 365
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Country Name (2 letter code) [AU]:FR
# State or Province Name (full name) [Some-State]:Moselle
# Locality Name (eg, city) []:Metz
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:Lapre
# Organizational Unit Name (eg, section) []:R&D
# Common Name (e.g. server FQDN or YOUR name) []:a.net
# Email Address []:arnaud.laprevote@gmail.com
openssl genpkey -algorithm RSA -out server-key.pem

openssl req -new -key server-key.pem -out server-csr.pem
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Country Name (2 letter code) [AU]:FR
# State or Province Name (full name) [Some-State]:Moselle
# Locality Name (eg, city) []:Metz
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:Lapre
# Organizational Unit Name (eg, section) []:R&D
# Common Name (e.g. server FQDN or YOUR name) []:a.net
# Email Address []:arnaud.laprevote@gmail.com
# 
# Please enter the following 'extra' attributes
# to be sent with your certificate request
# A challenge password []:123456789
# An optional company name []:Lapre
openssl x509 -req -in server-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out server-cert.pem -days 365
#Certificate request self-signature ok
#subject=C = FR, ST = Moselle, L = Metz, O = Lapre, OU = R&D, CN = a.net, emailAddress = arnaud.laprevote@gmail.com



openssl genpkey -algorithm RSA -out user1-key.pem

# alaprevo@lapre1:~/Source/sslap$ openssl req -new -key user1-key.pem -out user1-csr.pem
# You are about to be asked to enter information that will be incorporated
# into your certificate request.
# What you are about to enter is what is called a Distinguished Name or a DN.
# There are quite a few fields but you can leave some blank
# For some fields there will be a default value,
# If you enter '.', the field will be left blank.
# -----
# Country Name (2 letter code) [AU]:FR
# State or Province Name (full name) [Some-State]:Moselle
# Locality Name (eg, city) []:Metz
# Organization Name (eg, company) [Internet Widgits Pty Ltd]:user1
# Organizational Unit Name (eg, section) []:user1
# Common Name (e.g. server FQDN or YOUR name) []:user1
# Email Address []:user1@planzone.com
# 
# Please enter the following 'extra' attributes
# to be sent with your certificate request
# A challenge password []:123456789
# An optional company name []:user1
openssl x509 -req -in user1-csr.pem -CA ca-cert.pem -CAkey ca-key.pem -CAcreateserial -out user1-cert.pem -days 365
#Certificate request self-signature ok
# subject=C = FR, ST = Moselle, L = Metz, O = user1, OU = user1, CN = user1, emailAddress = user1@planzone.com
openssl pkcs12 -export -out user1.p12 -inkey user1-key.pem -in user1-cert.pem
# Enter Export Password:
# Verifying - Enter Export Password:
