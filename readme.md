# Self-Signed Certificate Generation Script

This Bash script generates self-signed CA certificates and server certificates, and packages them into PFX format.

## Features

- Supports using existing CA certificates and private keys, or generating new CA certificates
- Can generate server certificates for multiple domain names
- Generated certificates include the SAN (Subject Alternative Name) extension, supporting multiple domain names
- Packages server certificates, private keys, and CA certificates into PFX format for easy deployment

## Usage

1. Download the script file `gen_pfx.sh`.

2. Open a terminal and navigate to the directory where the script is located.

3. Run the script, providing the necessary options and arguments based on your requirements:

   ```bash
   ./gen_pfx.sh [-k <ca_key> -c <ca_cert>] [-n <ca_name>] [domain1 domain2 ...]
   ```
   
   Option descriptions:
   - -k <ca_key>: Specify the path to an existing CA private key file.
   - -c <ca_cert>: Specify the path to an existing CA certificate file.
   - -n <ca_name>: When generating a new CA certificate, specify the name of the CA.
   - domain1 domain2 ...: List of domain names for which to generate server certificates, separated by spaces.

   Examples:
   - Use an existing CA certificate and private key to generate server certificates for the domain names example.com and www.example.com:

   ```bash
   ./gen_pfx.sh -k ca.key -c ca.crt example.com www.example.com
   ```

   - Generate a new CA certificate and server certificate for the domain name example.com:

   ```bash
   ./gen_pfx.sh -n "My Custom CA" example.com
   ```

4. After the script finishes execution, the following files will be generated in the current directory:
- ca_key.pem: CA private key file.
- ca_cert.pem: CA certificate file.
- <domain>_key.pem: Server private key file, where <domain> is the corresponding domain name.
- <domain>_cert.pem: Server certificate file, where <domain> is the corresponding domain name.
- <domain>.pfx: PFX file containing the server certificate, private key, and CA certificate, where <domain> is the corresponding domain n

## Notes
- The generated certificates are for testing and development purposes only. It is not recommended to use self-signed certificates in a production environment.
- Ensure that the script file has executable permissions. If not, you can add executable permissions using the following command:

```bash
chmod +x gen_pfx.sh
```

- The script depends on the OpenSSL tool. Make sure OpenSSL is installed on your system.

## License
This script is released under the MIT License.
