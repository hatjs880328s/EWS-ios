//
//  PKCS.swift
//  impcloud_dev
//
//  Created by Noah_Shan on 2018/12/7.
//  Copyright © 2018 Elliot. All rights reserved.
//

import Foundation
//import CryptoSwift
import Security

class PKCS: NSObject {
    override init() { super.init() }

    @objc func cbcpkcs7(cerpath:String) -> String {

        /// cer path is ok
        let datass = try! Data(contentsOf: URL(string: cerpath)!)
        let strss = String(data: datass, encoding: String.Encoding.ascii)

        /// private key is ok
        let privateKeyPath = cerpath.replace(find: "certificate.cer", replaceStr: "hello_pri.pem")
        let pridata = try! Data(contentsOf: URL(string: privateKeyPath)!)
        let pristrss = String(data: pridata, encoding: String.Encoding.ascii)

        /// p7m file
        let p7mfile = cerpath.replace(find: "certificate.cer", replaceStr: "smime.p7m")

        /// pkcs7 container- create with p7m file
        let pkcs7 = createPKCS7(path: p7mfile)
        /// pkcs7 container- create with exchange att file base 64 str
        /// 此处的base64.p7m是ews附件返回的base64串截取的内容，后缀手动写为p7m
        let pathbase = cerpath.replace(find: "certificate.cer", replaceStr: "macmime2.p7m")
        let base64Data = try! Data(contentsOf: URL(string: pathbase)!)
        let debase64Data = NSData(base64Encoded: base64Data, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        let pkcs7Data = self.createPKCS7(data: debase64Data! as Data)
        /// decrypt
        let decrypted = PKCS7Decrypt.decrypt(pkcs7Data, privateKey: pristrss, certificate: strss)

        let debase64Str = decode64(decrypted!)
        return debase64Str
    }

    func createPKCS7(path:String)->UnsafeMutablePointer<PKCS7>? {
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

    func createPKCS7(data: Data)->UnsafeMutablePointer<PKCS7>? {
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
        let decodedData = Data(base64Encoded: str, options: Data.Base64DecodingOptions.init(rawValue: 0))
        /*
         GB2312 & GBK
         */
        let subStrsData = loopDecodeBASE64(base64Str: str)
//        let gb2300 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_18030_2000.rawValue))
//        let gbk = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GBK_95.rawValue))
//        let gb2312 = CFStringConvertEncodingToNSStringEncoding(UInt32(CFStringEncodings.GB_2312_80.rawValue))

//        let decodedString1 = String(data: subStrsData, encoding: String.Encoding(rawValue: gb2312))
//        let decodedString2 = String(data: subStrsData, encoding: String.Encoding(rawValue: gbk))
//        let decodedString3 = String(data: subStrsData, encoding: String.Encoding(rawValue: gb2300))
        let base64Data = Data(base64Encoded: str, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)

        return subStrsData
    }

    /// smime.p7m
    func loopDecodeBASE64(base64Str: String) -> String {
        let realBase64 = (base64Str as NSString).components(separatedBy: "filename=smime.p7m")[1]//filename=smime.p7m
        let eachLineNumCount: Int = 40
        var resultData: NSString = ""
        let subStrs = realBase64.subStringWithNum(num: eachLineNumCount)
        for i in 0 ..< subStrs.count {
            let subStr = NSString.init(fromBase64String: subStrs[i])
            guard let realSubStr = subStr as String? else { continue }
            resultData = resultData.appending(realSubStr) as NSString
        }
        return resultData as String
    }
}
