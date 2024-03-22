# 自签名证书生成脚本

这个 Bash 脚本可以生成自签名的 CA 证书和服务器证书,并将其打包为 PFX 格式。

## 功能特点

- 支持使用现有的 CA 证书和私钥,或生成新的 CA 证书
- 可以为多个域名生成服务器证书
- 生成的证书包括 SAN (Subject Alternative Name) 扩展,支持多域名
- 将服务器证书、私钥和 CA 证书打包为 PFX 格式,便于部署

## 使用方法

1. 下载脚本文件 `gen_pfx.sh`。

2. 打开终端,切换到脚本所在目录。

3. 运行脚本,根据需要提供相应的选项和参数:

   ```bash
   ./gen_pfx.sh [-k <ca_key> -c <ca_cert>] [-n <ca_name>] [domain1 domain2 ...]
   ```

   选项说明:
   - -k <ca_key>: 指定现有的 CA 私钥文件路径。
   - -c <ca_cert>: 指定现有的 CA 证书文件路径。
   - -n <ca_name>: 生成新的 CA 证书时,指定 CA 的名称。
   - domain1 domain2 ...: 要生成服务器证书的域名列表,用空格分隔。
   示例:
   - 使用现有的 CA 证书和私钥,为域名 example.com 和 www.example.com 生成服务器证书:

   ```bash
    ./gen_pfx.sh -k ca.key -c ca.crt example.com www.example.com
   ```

   生成新的 CA 证书,并为域名 example.com 生成服务器证书:

   ```bash
   ./gen_pfx.sh -n "My Custom CA" example.com
   ```

4. 脚本执行完成后,会在当前目录下生成以下文件:
- ca_key.pem: CA 私钥文件。
- ca_cert.pem: CA 证书文件。
- <domain>_key.pem: 服务器私钥文件,其中 <domain> 为相应的域名。
- <domain>_cert.pem: 服务器证书文件,其中 <domain> 为相应的域名。
- <domain>.pfx: 包含服务器证书、私钥和 CA 证书的 PFX 文件,其中 <domain> 为相应的域名。

## 注意事项
生成的证书仅供测试和开发使用,不建议在生产环境中使用自签名证书。
确保脚本文件有可执行权限,如果没有,可以使用以下命令添加可执行权限:

```bash
chmod +x gen_pfx.sh
```

脚本依赖 OpenSSL 工具,确保系统中已安装 OpenSSL。

## 许可证
该脚本基于 MIT 许可证 发布。
