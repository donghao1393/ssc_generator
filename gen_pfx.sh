#!/usr/bin/env bash

# Usage: generate self-signed CA and server certificates, and package into pfx format
# author: Dong, Hao
# version: 1.1

## server
function gen_server() {
	common_name=$(echo ${domain_name} | sed 's@[^a-z]@_@g')

	### SAN
	san_extension=${common_name}.ext
	cat >${san_extension} <<-EOF
		authorityKeyIdentifier=keyid,issuer
		basicConstraints=CA:FALSE
		keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
		subjectAltName = DNS:${domain_name}
	EOF

	private_key=${common_name}_key.pem
	crtsign_req=${common_name}_csr.pem
	certificate=${common_name}_cert.pem
	pfx_bundle=${common_name}.pfx
	### key
	openssl genrsa -out ${private_key} 2048
	### csr
	openssl req -new -key ${private_key} -out ${crtsign_req} -subj "/CN=${domain_name}"
	### cert
	openssl x509 -req -days 365 -in ${crtsign_req} -CA ca_cert.pem -CAkey ca_key.pem -CAcreateserial -out ${certificate} -extfile ${san_extension}
	### pfx
	openssl pkcs12 -export -out ${pfx_bundle} -inkey ${private_key} -in ${certificate} -certfile ca_cert.pem

	echo "Generated server certificate for domain: ${domain_name}"
	rm ${san_extension}
}

usage() {
	echo "Usage: $0 [-k <ca_key> -c <ca_cert>] [-n <ca_name>] [domain1 domain2 ...]"
	echo "Options:"
	echo "  -k <ca_key>                Use existing CA key"
	echo "  -c <ca_cert>               Use existing CA certificate"
	echo "  -n <ca_name>               Generate new CA key and certificate with the specified name"
	echo "  domain1 domain2 ...        List of domain names for which to generate server certificates"
}

declare -a domain_names

while getopts ":k:c:n:" opt; do
	case ${opt} in
	k)
		ca_key=$(echo $OPTARG | cut -d ' ' -f 1)
		;;
	c)
		ca_cert=$(echo $OPTARG | cut -d ' ' -f 2)
		;;
	n)
		ca_name=$OPTARG
		ca_key="ca_key.pem"
		ca_cert="ca_cert.pem"

		echo "Generating new CA certificate with name: ${ca_name}"
		openssl genrsa -out ${ca_key} 2048
		openssl req -new -x509 -days 365 -key ${ca_key} -out ${ca_cert} -subj "/CN=${ca_name}"
		;;
	\?)
		usage
		exit 0
		;;
	esac
done
shift $((OPTIND - 1))

domain_names=("$@")

if ([[ -z "${ca_key}" ]] || [[ -z "${ca_cert}" ]]) && [[ -z "${ca_name}" ]] || [[ ${#domain_names[@]} -eq 0 ]]; then
	usage
	exit 1
fi

for domain_name in ${domain_names[@]}; do
	gen_server
done

echo "All certificates and private keys have been generated successfully."
