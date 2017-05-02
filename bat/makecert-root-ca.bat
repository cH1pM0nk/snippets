@echo off

set OPENSSL_CONF=./conf/openssl.cnf

if not exist .\conf\ssl.crt mkdir .\conf\ssl.crt
if not exist .\conf\ssl.key mkdir .\conf\ssl.key

if exist al3x-ca-key.crt del al3x-ca-key.crt
if exist al3x-ca-root.crt del al3x-ca-root.crt
if exist al3x-ca-root.pem del al3x-ca-root.pem

echo Erstelle Root-CA Key (.pem) 
bin\openssl genrsa -aes256 -out al3x-ca-key.pem 2048

echo Generiere Root-CA Cert (.pem) - 1024 Tage gültig
bin\openssl req -x509 -new -nodes -extensions v3_ca -key al3x-ca-key.pem -days 1024 -out al3x-ca-root.pem -sha512

::echo Generiere Root-CA Cert (.crt) - 1024 Tage gültig
::bin\openssl req -x509 -new -nodes -extensions v3_ca -key al3x-ca-key.pem -days 1024 -out al3x-ca-root.crt -sha512

set OPENSSL_CONF=
echo.
echo -----
echo Das Root-CA Zertifikat wurde erstellt.
echo.
pause
