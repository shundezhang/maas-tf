#!/bin/bash
sudo snap install juju --channel 3/stable
cat > ~/maas-cloud.yaml <<EOF
clouds:
  maas-one:
    type: maas
    auth-types: [oauth1]
    endpoint: http://10.250.120.2:5240/MAAS
EOF
juju add-cloud --client -f ~/maas-cloud.yaml maas-one
API_KEY=$(lxc exec maas --project maas-repro -- maas apikey --username admin)
cat > ~/maas-creds.yaml <<EOF
credentials:
  maas-one:
    anyuser:
      auth-type: oauth1
      maas-oauth: $API_KEY
EOF
juju add-credential --client -f ~/maas-creds.yaml maas-one
juju bootstrap --bootstrap-series=jammy --constraints "cores=2 mem=4G root-disk=30G" maas-one maas-controller

