# EWS
exchange-协议【获取数据 &amp; 发送邮件 &amp; 加密解密】

2.0.0 Feature

1.新增发送邮件处理

2.添加SIME.P7M文件解密功能<无UI排版、展示>

##### 目前.P7M文件解密只是在控制台输入，并没有做UI的展示
##### P7M文件解析使用的是OPENSSL PKCS7_DECRYPT函数
##### 解析函数参数有三个：
1. encrypted infos : PKCS7 instance 是一个对象而不是encrypted strvalue
2. pri_key infos : 用户私钥：用于RSA解密信封所用
3. certificate.cer infos: 包含cer证书信息
4. 
##### 传入时将文件转为data-stringvalue传入即可;pri.pem & certificate.cer文件由pfx p12解析所得。 openssl解析cmd：[证书导出参考](https://blog.csdn.net/weixin_39885282/article/details/79933867)
##### 关于ios平台的pfx转pem&cer打算处理C-OPENSSL或者oc&python混编；目前手动解析
