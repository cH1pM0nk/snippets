@echo off

echo.
echo SSL Certificate Generator (with local Root-CA)
echo ==============================================================================
echo Init..

set FQDN=%1
set SSL_ROOT_PATH=C:\xampp\apache

:: Path of Root-CA Key & Certificate
set SSL_CA_KEY=%SSL_ROOT_PATH%\conf\ssl.key\al3x-ca-key.pem
set SSL_CA_CERT=%SSL_ROOT_PATH%\conf\ssl.crt\al3x-ca-root.pem

set SSL_VALIDITY_PERIOD=365

:: Path of OpenSSL config file
set OPENSSL_CONF=%SSL_ROOT_PATH%\conf\openssl.cnf

cd %TEMP% > NUL
if not exist %SSL_ROOT_PATH%\conf\ssl.crt mkdir %SSL_ROOT_PATH%\conf\ssl.crt
if not exist %SSL_ROOT_PATH%\conf\ssl.key mkdir %SSL_ROOT_PATH%\conf\ssl.key

if exist %FQDN%-key.pem del %FQDN%-key.pem > NUL
if exist %FQDN%-pub.pem del %FQDN%-pub.pem > NUL
if exist %FQDN%.csr del %FQDN%.csr > NUL

echo ------------------------------------------------------------------------------
echo Generate a unique server keyfile with 4096 bit..
echo '%SSL_ROOT_PATH%\bin\openssl genrsa -out %FQDN%-key.pem 4096'
pause
%SSL_ROOT_PATH%\bin\openssl genrsa -out %FQDN%-key.pem 4096

echo ------------------------------------------------------------------------------
echo Creating the SSL server certificate request (.csr), SHA512..
echo '%SSL_ROOT_PATH%\bin\openssl req -new -key %FQDN%-key.pem -out %FQDN%.csr -sha512'
pause
%SSL_ROOT_PATH%\bin\openssl req -new -key %FQDN%-key.pem -out %FQDN%.csr -sha512

echo ------------------------------------------------------------------------------
echo Sign the certificate with local Root-CA cert for %SSL_VALIDITY_PERIOD% days..
echo %SSL_ROOT_PATH%\bin\openssl x509 -req -in %FQDN%.csr -CA %SSL_CA_CERT% -CAkey %SSL_CA_KEY% -CAcreateserial -out %FQDN%-pub.pem -days %SSL_VALIDITY_PERIOD% -sha512
pause
%SSL_ROOT_PATH%\bin\openssl x509 -req -in %FQDN%.csr -CA %SSL_CA_CERT% -CAkey %SSL_CA_KEY% -CAcreateserial -out %FQDN%-pub.pem -days %SSL_VALIDITY_PERIOD% -sha512

del .rnd > NUL
del %FQDN%.csr > NUL
move /y %FQDN%-key.pem %SSL_ROOT_PATH%\conf\ssl.key
move /y %FQDN%-pub.pem %SSL_ROOT_PATH%\conf\ssl.crt

echo ------------------------------------------------------------------------------
echo Certificate was successfully created and signed by virtual Root-CA!
echo.
echo Public SSL certificate: %SSL_ROOT_PATH%\conf\ssl.crt\%FQDN%-pub.pem
echo Server keyfile: %SSL_ROOT_PATH%\conf\ssl.key\%FQDN%-key.pem
echo Done.
echo.

pause
