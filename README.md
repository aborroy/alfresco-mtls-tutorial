# Alfresco mTLS configuration tutorial

This project includes a sample configuration for Alfresco Repository using Docker Images for mTLS communication with SOLR.
Additionally, some useful resources for SOLR are provided, in order to deploy this service using the ZIP Distribution file.

Alfresco Repository and SOLR are using the `classical` certificates format. More details available in [https://github.com/Alfresco/alfresco-ssl-generator#parameters](https://github.com/Alfresco/alfresco-ssl-generator#parameters)

You should review volumes, configuration, modules & tuning parameters before using this composition in **Production** environments.

## Project structure

```
.
├── alfresco
│   └── Dockerfile
├── docker-compose.yml
├── keystores
│   ├── alfresco
│   │   ├── keystore
│   │   ├── keystore-passwords.properties
│   │   ├── ssl-keystore-passwords.properties
│   │   ├── ssl-truststore-passwords.properties
│   │   ├── ssl.keystore
│   │   └── ssl.truststore
│   ├── client
│   │   └── browser.p12
│   └── solr
│       ├── ssl-keystore-passwords.properties
│       ├── ssl-truststore-passwords.properties
│       ├── ssl.repo.client.keystore
│       └── ssl.repo.client.truststore
└── search-configuration
    ├── run.sh
    ├── solr.in.sh
    └── solrcore.properties
```

* `.env` includes Docker environment variables to set Docker Image release numbers and the local IP for SOLR Server
* `alfresco` folder includes configuration for ACS Repository Docker Image using mTLS
* `docker-compose.yml` is a Docker Compose template to use ACS Repository Community with mTLS Communication
* `keystores` folder includes keystore and truststores files for Alfresco Repository and SOLR (classic format, with password files)
* `search-configuration` folder includes some resources to configure SOLR from ZIP Distribution file

# How to use this composition

## Start Docker

Find out your local IP using `ifconfig` command or equivalent and set this value in `.env` file.

```
$ ifconfig en0
en0: flags=8863<UP,BROADCAST,SMART,RUNNING,SIMPLEX,MULTICAST> mtu 1500
	options=400<CHANNEL_IO>
	ether 38:f9:d3:2e:e7:7d
	inet6 fe80::1488:a382:ba82:bdc3%en0 prefixlen 64 secured scopeid 0x6
	inet 192.168.1.38 netmask 0xffffff00 broadcast 192.168.1.255
	nd6 options=201<PERFORMNUD,DAD>
	media: autoselect
	status: active

$ vi .env
SOLR_LOCAL_IP=192.168.1.38
```

Start docker and check the ports are correctly bound.

```bash
$ docker-compose up -d
$ docker ps --format '{{.Names}}\t{{.Image}}\t{{.Ports}}'
proxy_1               angelborroy/acs-proxy:1.0.0               80/tcp, 0.0.0.0:8080->8080/tcp
share_1               alfresco/alfresco-share:6.2.1             8000/tcp, 8080/tcp
activemq_1            alfresco/alfresco-activemq:5.15.8         0.0.0.0:5672->5672/tcp, ...
postgres_1            postgres:11.7                             0.0.0.0:5432->5432/tcp
alfresco_1            alfresco-solr-docker-mtls_alfresco        8080/tcp, 0.0.0.0:8443->8443/tcp
transform-core-aio_1 alfresco/alfresco-transform-core-aio:2.3.5 0.0.0.0:8090->8090/tcp
```

## Access

Use the following username/password combination to login.

 - User: admin
 - Password: admin

Alfresco and related web applications can be accessed from the below URIs when the servers have started.

```
http://localhost:8080/alfresco      - Alfresco Repository
http://localhost:8080/share         - Alfresco Share
```

# Instructions to setup mTLS Communication when using local deployment for SOLR

In order to apply this configuration when deploying Search Services in a local environment, following steps should be followed.

## Alfresco configuration

For these steps, Search Services is expected to be installed in `/tmp/alfresco-search-services` folder and this project folder in `/tmp/alfresco-mtls-tutorial`

Download and unzip SOLR Zip Distribution file in `/tmp`

```
$ cd /tmp

$ wget https://download.alfresco.com/cloudfront/release/community/SearchServices/2.0.0/alfresco-search-services-2.0.0.zip

$ unzip alfresco-search-services-2.0.0.zip
```
Add the following values to your `/opt/alfresco-search-services/solrhome/templates/rerank/conf/solrcore.properties` file

```
alfresco.secureComms=https
alfresco.encryption.ssl.keystore.location=/tmp/alfresco-mtls-tutorial/keystore/ssl-repo-client.keystore
alfresco.encryption.ssl.keystore.passwordFileLocation=
alfresco.encryption.ssl.keystore.type=JCEKS
alfresco.encryption.ssl.truststore.location=/tmp/alfresco-mtls-tutorial/keystore/ssl-repo-client.truststore
alfresco.encryption.ssl.truststore.passwordFileLocation=
alfresco.encryption.ssl.truststore.type=JCEKS
```

Add the following values to your `/tmp/alfresco-search-services/solr.in.sh` file (or to `solr.in.cmd` file if you are installing SOLR in Windows)

```
$ vi /opt/alfresco-search-services/solr.in.sh
SOLR_HOST=localhost
SOLR_PORT=8443
SOLR_SSL_TRUST_STORE=/tmp/alfresco-mtls-tutorial/keystore/ssl-repo-client.truststore
SOLR_SSL_TRUST_STORE_TYPE=JCEKS
SOLR_SSL_TRUST_STORE_PASSWORD=truststore
SOLR_SSL_KEY_STORE=/opt/alfresco-mtls-tutorial/keystore/ssl-repo-client.keystore
SOLR_SSL_KEY_STORE_TYPE=JCEKS
SOLR_SSL_KEY_STORE_PASSWORD=keystore
SOLR_SSL_NEED_CLIENT_AUTH=true
```

Start SOLR using the following parameters:

```
$ /etc/alfresco-search-services/solr/bin/solr start -a "-Dcreate.alfresco.defaults=alfresco \
-Dsolr.ssl.checkPeerName=false \
-Dsolr.allow.unsafe.resourceloading=true" -f
```

Once SOLR is started, you should be able to perform queries from Alfresco Share in http://localhost:8080/share

## Additional material

You can find a presentation related with this sample in https://www.slideshare.net/angelborroy/alfresco-certificates
