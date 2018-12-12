# EWS-ios
### 我也不知道为何起了个英文名字，也许就是因为香吧。
### 获取服务地址 、 发送普通邮件 、 获取邮件列表等不在本文讨论内容范围，如有需要直接点击
[懒人通道](https://github.com/hatjs880328s/EWS-ios)
### 关于exchange邮件加密协议PKCS7的安利
#### 其加密步骤主要分为一下几步：
1. a发送邮件给b,a生成一个对称加密算法(如DES)秘钥des_key
2. a使用des_key将要传输的明文（邮件内容）进行加密
3. a使用b的公钥将des_key加密得到des_key_key
4. a将des_key_key & 加密后的邮件内容一同发送给b
5. b得到加密后传输过来的密文，首先使用自己的私钥将des_key_key解密得到des_key
6. 然后使用des_key将加密后的邮件内容解密得到明文
7. 上面提到的不对称加密算法常用RSA,对称加密算法常用DES,如果感兴趣自行google
### How 2 decryte the encrypted email 代码    [别废话，直接上代码]
1. 关于证书的导入，目前方式是手动解析.pfx 转为带有公钥的.cer 文件和带有私钥的.pem文件；openssl cmd google即可，比较简单。
2. 代码中使用了openssl库来做p7m文件的解析，使用了PKCS7_decrypted(pkcs7 *pkc, cerInfo *str ...)函数，函数第一个参数是PKCS7对象，就是我们需要解析的.p7m文件数据流；第二个就是第一步中提到的.cer文件内容字符串；第三个参数是.pem私钥内容

`
/// 使用数据流创建pkcs7对象
private func createPKCS7(data: Data)->UnsafeMutablePointer<PKCS7>? {
let receiptBIO = BIO_new(BIO_s_mem())
BIO_write(receiptBIO, (data as NSData).bytes, Int32(data.count))
let pkcs7 = d2i_PKCS7_bio(receiptBIO, nil)
return pkcs7
}
`

`
/// 将certificate文件数据流转换decrypted所能使用的对象
X509 *getCert(const char *certificate) {
BIO *membuf = BIO_new(BIO_s_mem());
BIO_puts(membuf, certificate);
X509 *x509 = PEM_read_bio_X509(membuf, NULL, NULL, NULL);
return x509;
}
`

`
/// 转换pem数据流信息为decrypted所能使用的对象
EVP_PKEY *getKey(const char *privateKey) {
BIO *membuf = BIO_new(BIO_s_mem());
BIO_puts(membuf, privateKey);
EVP_PKEY *key = PEM_read_bio_PrivateKey(membuf, NULL, 0, NULL);
return key;
}
`

3. 幸福的使用char *data = decrypt(pkcs7, pkey, cert)函数得到解密后的信息。
4. 关于以上代码的解析，apple的security-session有比较好的介绍与实践，这里也不多说。（如此晦涩，真的无奈）

#### 问题：
1. 目前pfx文件导出pem & cer手动转换，下一步会使用openssl库进行一定的coding 当然更为直接的方式就是使用oc混编python，让python去做这件事情了。（学了python之后唯一做的就是CI静态检测脚本，觉得很委屈）。如果有更好的方式欢迎issues
