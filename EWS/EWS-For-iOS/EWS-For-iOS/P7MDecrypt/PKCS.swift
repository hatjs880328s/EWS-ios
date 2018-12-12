//
//  PKCS.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2018/12/7.
//  Copyright © 2018 Elliot. All rights reserved.
//

import Foundation
import Security

/*
 这里是一个示例：
 需要的证书 & 解析的数据都已经持久化到本地
 需要解析的数据就是 获取附件中smime.p7m 返回的数据中<content></content>内的字符串 = encryptedStr
 获取下来encryptedStr 将它转为nsdata作为 [self.createPKCS7(data: debase64Data! as Data)]的参数传入即可
 */
class PKCS: NSObject {
    override init() { super.init() }

    @objc func cbcpkcs7(cerpath:String) -> String {

        let realPath = Bundle.main.path(forResource: "certificate", ofType: "cer")!

        /// cer path is ok
        let datass = NSData(contentsOfFile: realPath)
        let strss = String(data: datass! as Data, encoding: String.Encoding.ascii)

        /// private key is ok
        let privateKeyPath = realPath.replace(find: "certificate.cer", replaceStr: "hello_pri.pem")
        let pridata = NSData(contentsOfFile: privateKeyPath)
        let pristrss = String(data: pridata! as Data, encoding: String.Encoding.ascii)

        /// pkcs7 container- create with exchange att file base 64 str
        /// 此处的base64.p7m是ews附件返回的base64串截取的内容，后缀手动写为p7m
        let pathbase = realPath.replace(find: "certificate.cer", replaceStr: "macmime.p7m")
        let base64Data = NSData(contentsOfFile: pathbase)
        let debase64Data = NSData(base64Encoded: base64Data! as Data, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let pkcs7Data = self.createPKCS7(data: debase64Data! as Data)
        /// decrypt
        let decrypted = PKCS7Decrypt.decrypt(pkcs7Data, privateKey: pristrss, certificate: strss)

        /// debase64
        let debase64Str = decode64(decrypted!)
        print(debase64Str)

        return debase64Str
    }

    /// 文件路径 生成 pkcs7 对象
    private func createPKCS7(path:String)->UnsafeMutablePointer<PKCS7>? {
        do {
            guard let realPath = URL(string: path) else { return nil }
            let data = try Data(contentsOf: realPath)
            let receiptBIO = BIO_new(BIO_s_mem())
            BIO_write(receiptBIO, (data as NSData).bytes, Int32(data.count))
            let pkcs7 = d2i_PKCS7_bio(receiptBIO, nil)
            return pkcs7
        }catch{}
        return nil
    }

    /// 数据流 生成 pkcs7 对象
    private func createPKCS7(data: Data)->UnsafeMutablePointer<PKCS7>? {
        let receiptBIO = BIO_new(BIO_s_mem())
        BIO_write(receiptBIO, (data as NSData).bytes, Int32(data.count))
        let pkcs7 = d2i_PKCS7_bio(receiptBIO, nil)
        return pkcs7
    }

    @discardableResult
    func decode64(_ base64Str: String) -> String {
        var str = base64Str
        str = str.replace(find: "\n", replaceStr: "")
        str = str.replace(find: "\r", replaceStr: "")
        let subStrsData = loopDecodeBASE64(base64Str: str)
//        let gb2300 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
//        let decodedString1 = String(data: subStrsData, encoding: String.Encoding(rawValue: gb2312))

        return subStrsData
    }

    /// 循环解析base64 4 * 6 = 3 * 8
    /// 这里比较粗暴的解析了base64编码
    func loopDecodeBASE64(base64Str: String) -> String {
        let realBase64 = (base64Str as NSString).components(separatedBy: "filename=smime.p7m")[1]//filename=smime.p7m
        let eachLineNumCount: Int = 40
        var resultData: NSString = ""
        let subStrs = realBase64.subStringWithNum(num: eachLineNumCount)
        for i in 0 ..< subStrs.count {
            let subStr = NSString.init(fromBase64String: subStrs[i])
            if let realSubStr = subStr as String? {
                resultData = resultData.appending(realSubStr) as NSString
            }else{
                resultData = resultData.appending(subStrs[i]) as NSString
            }

        }
        return resultData as String
    }
}
