# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Settings here will override settings in existing env vars or in bin/solr.

# Expert: If you want finer control over memory options, specify them directly
# Comment out SOLR_HEAP if you are using this though, that takes precedence
SOLR_JAVA_MEM="-Xms1g -Xmx1g"

# Alfresco configuration. This file is automatically included by solr. You can define your custom settings here
SOLR_OPTS="$SOLR_OPTS -Dsolr.jetty.request.header.size=1000000 -Dsolr.jetty.threads.stop.timeout=300000 -Ddisable.configEdit=true"

# Location where Solr should write logs to. Absolute or relative to solr start dir
SOLR_LOGS_DIR=../../logs
LOG4J_PROPS=$SOLR_LOGS_DIR/log4j.properties

# ssl.repo.client.keystore
# [!] You need to use your local path for this property
SOLR_SSL_KEY_STORE=/tmp/alfresco-mtls-tutorial/keystores/solr/ssl.repo.client.keystore
SOLR_SSL_KEY_STORE_TYPE=JCEKS
SOLR_SSL_KEY_STORE_PASSWORD=keystore

# ssl.repo.client.truststore
# [!] You need to use your local path for this property
SOLR_SSL_TRUST_STORE=/tmp/alfresco-mtls-tutorial/keystores/solr/ssl.repo.client.truststore
SOLR_SSL_TRUST_STORE_TYPE=JCEKS
SOLR_SSL_TRUST_STORE_PASSWORD=truststore

# Jetty mTLS configuration
SOLR_SSL_NEED_CLIENT_AUTH=true
