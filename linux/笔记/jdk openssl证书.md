```
cd /usr/java/jdk1.6.0_45/jre/lib/security
keytool -list -keystore cacerts -storepass changeit | grep digicertglobalrootca
keytool -list -keystore cacerts -storepass changeit | grep baltimorecybertrustca
```