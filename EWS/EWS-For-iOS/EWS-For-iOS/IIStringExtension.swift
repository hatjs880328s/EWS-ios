//
//  MyStringExtension.swift
//  SwiftExtension
//
//  Created by 东正 on 15/12/7.
//  Copyright © 2015年 东正. All rights reserved.
//

import UIKit

/**
 数据类型
 
 - NSListType:     顺序集合结构
 - NSSetType:      无顺序集合结构
 - NSObjectType:   系统非集合类型
 - UnNSObjectType: 自定义类型
 */
public enum ObjectType {
    case nsListType
    case nsSetType
    case nsObjectType
    case unNSObjectType
}

public extension String {

    /// 根据给定的num数值，将字符串分割成多段str,每一段str都包含num个字符，最后一段不补齐
    /// dsalsdfjdsla
    /// 0   4   8
    /// - Parameter num: 每段长度
    /// - Returns: 结果集
    func subStringWithNum(num: Int) -> [String] {
        let oldValue = self
        var result = [String]()
        //分成多少段
        let partNum = oldValue.length % num == 0 ? oldValue.length / num : oldValue.length / num + 1
        // 是否有余数-最后一段是否完整 true: 完整 false: 不完整
        let isCBC = oldValue.length % num == 0
        for i in 0 ..< partNum {
            var range: NSRange?
            if  i == partNum - 1 {
                if !isCBC {
                    range = NSRange(location: i * num, length: oldValue.length % num)
                } else {
                    range = NSRange(location: i * num, length: num)
                }
            } else {
                range = NSRange(location: i * num, length: num)
            }
            let partStr = oldValue.substringWithRange(range!)
            result.append(partStr)
        }
        return result
    }
    
    static let random_str_characters = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
    static func randomStr(len: Int) -> String {
        var ranStr = ""
        for _ in 0..<len {
            let index = Int(arc4random_uniform(UInt32(random_str_characters.count)))
            ranStr.append(random_str_characters[random_str_characters.index(random_str_characters.startIndex, offsetBy: index)])
        }
        return ranStr
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    /**
     转化成base64
     
     - returns: base64
     */
    func toBase64String() -> String? {
        let data = self.data(using: String.Encoding.ascii)
        return data?.base64EncodedString(options: NSData.Base64EncodingOptions.endLineWithLineFeed)
    }
    
    /**
     格式化手机号码
     
     - parameter phonenumber: 原来手机号
     */
    func formatPhoneNumber(_ phonenumber: String) -> String {
        //to index  to 这个字母不包含，from index 是包含 INDEX这个数组的
        return phonenumber.substringToIndex(3) + "-" + phonenumber.substringWithRange(NSRange(location: 3, length: 4)) + "-" + phonenumber.substringFromIndex(7)
    }
    
    /**
     拼接url
     */
    func appendUrl(_ nextUrl: String) -> String {
        if(self.contains("?")) {
            return self + "&" + nextUrl
        } else {
            return self + "?" + nextUrl
        }
    }
    
    /**
     版本号比较
     
     - parameter : true 表示输入参数比当前大   false 表示输入参数比当前小
     */
    func isCheckVersion(_ version: String) -> Bool {
        //数据可能为空
        if(version == "" || self == "") {
            
            return false
        }
        
        //如果特殊情况不包含。分隔符
        if !version.contains(".") ||  !self.contains(".") {
            
            return false
        }
        
        let versionArr = version.components(separatedBy: ".")
        let selfArr = self.components(separatedBy: ".")
        
        //如果分隔符数量不足
        if selfArr.count != 3 || versionArr.count != 3 {
            
            return false
        }
        
        //比较第一位
        if versionArr[0].toDouble()! > selfArr[0].toDouble()! {
            
            return true
        } else if versionArr[0].toDouble()! == selfArr[0].toDouble()! {
            //比较第二位
            if versionArr[1].toDouble()! > selfArr[1].toDouble()! {
                
                return true
            } else if versionArr[1].toDouble()! == selfArr[1].toDouble()! {
                //比较第三位
                if versionArr[2].toDouble()! > selfArr[2].toDouble()! {
                    
                    return true
                } else {
                    
                    return false
                }
                
            } else {
                
                return false
            }
        } else {
            
            return false
        }
        
    }
    
    func substringWithRange(_ range: NSRange) -> String {
        let str = self as NSString
        return str.substring(with: range)
    }
    
    func substringFromIndex(_ from: Int) -> String {
        let str = self as NSString
        return str.substring(from: from)
    }
    
    func substringToIndex(_ to: Int) -> String {
        let str = self as NSString
        return str.substring(to: to)
    }
    
    /// 返回时间
    ///
    /// :param format: yyyy-MM-dd HH:mm:ss / yyyy-MM-dd / yyyyMMddHHmmss / MMddHHmmss
    ///
    /// returns: 时间
    func dateValue(_ format: String) -> Foundation.Date? {
        let formats = DateFormatter()
        formats.dateFormat = format
        formats.timeZone = TimeZone(identifier: "UTC")
        return formats.date(from: self)
    }
    
    func pathComponents() -> [String] {
        
        let newNstr = self as NSString
        return newNstr.pathComponents
        
    }
    func absolutePath() -> Bool {
        
        let newNstr = self as NSString
        return newNstr.isAbsolutePath
    }
    
    func lastPathComponent() -> String {
        
        let newNstr = self as NSString
        return newNstr.lastPathComponent
    }
    
    func stringByDeletingLastPathComponent() -> String {
        
        let newNstr = self as NSString
        return newNstr.deletingLastPathComponent
    }
    
    func stringByAppendingPathComponent(_ str: String) -> String {
        
        let newNstr = self as NSString
        return newNstr.appendingPathComponent(str)
    }
    
    func stringByDeletingPathExtension() -> String {
        
        let newNstr = self as NSString
        return newNstr.deletingPathExtension
    }
    func stringByAppendingPathExtension(_ str: String) -> String? {
        
        let newNstr = self as NSString
        return newNstr.appendingPathExtension(str)
    }
    
    func stringByAbbreviatingWithTildeInPath() -> String {
        
        let newNstr = self as NSString
        return newNstr.abbreviatingWithTildeInPath
    }
    
    func stringByExpandingTildeInPath() -> String {
        
        let newNstr = self as NSString
        return newNstr.expandingTildeInPath
    }
    
    func stringByStandardizingPath() -> String {
        
        let newNstr = self as NSString
        return newNstr.standardizingPath
    }
    func stringByResolvingSymlinksInPath() -> String {
        
        let newNstr = self as NSString
        return newNstr.resolvingSymlinksInPath
    }
    func stringsByAppendingPaths(_ paths: [String]) -> [String] {
        
        let newNstr = self as NSString
        return newNstr.strings(byAppendingPaths: paths)
    }
    
    /**
     格式化金额
     
     - returns: string
     */
    func stringFormatterCurrency() -> String {
        
        if(self != "0" && self != "") {
            
            let stringArr = self.components(separatedBy: ".")
            
            let firstString = stringArr.first
            
            let lastString = stringArr.last
            
            if firstString!.length <= 3 {
                
                return self
                
            } else {
                
                let formatter = NumberFormatter()
                formatter.numberStyle = NumberFormatter.Style.decimal
                
                let s = firstString!.toDouble()
                let newAmount = formatter .string(from: NSNumber(value: s! as Double))
                if stringArr.count == 1 {
                    return newAmount!
                } else {
                    return newAmount! + "." + lastString!
                }
            }
        }
        
        return self
        
    }
    
    /// 返回扩展名
    /// :returns: 扩展名
    func pathExtension() -> String {
        let newNstr = self as NSString
        return newNstr.pathExtension
    }
    
    func integerValue() -> Int {
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.integerValue
    }
    
    func longLongValue() -> Int64 {
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.longLongValue
    }
    
    func intValue() -> Int32 {
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.intValue
        
    }
    
    func floatValue() -> Float {
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.floatValue
        
    }
    
    func doubleValue() -> Double {
        
        let newNstr = self.removeSpaces() as NSString
        return newNstr.doubleValue
        
    }
    
    func boolValue() -> Bool? {
        let text = self.removeSpaces().lowercased()
        if(text == "true" || text == "false" || text == "yes" || text == "no" || text == "YES" || text == "NO") {
            let newNstr = self as NSString
            return newNstr.boolValue
            
        } else {
            
            return nil
        }
        
    }
    
    /// 返回长度
    /// :returns: 字符串长度
    public var length: Int {
        get {
            return (self as NSString).length
        }
    }
    
    /**
     return Double
     */
    func toDouble() -> Double? {
        
        let scanner = Scanner(string: self)
        var double: Double = 0
        if scanner.scanDouble(&double) {
            return double
        }
        
        return nil
        
    }
    
    /**
     return Float
     */
    func toFloat() -> Float? {
        
        let scanner = Scanner(string: self)
        var float: Float = 0
        
        if scanner.scanFloat(&float) {
            return float
        }
        
        return nil
        
    }
    
    /**
     returns: UInt
     */
    func toUInt() -> UInt? {
        if let val = Int(self.removeSpaces()) {
            if val < 0 {
                return nil
            }
            return UInt(val)
        }
        
        return nil
    }
    
    func toBool() -> Bool? {
        return self.boolValue()
    }
    
    func stringToBool() -> Bool {
        if self == "true" {
            
            return true
        } else {
            return false
        }
    }
    
    /**
     解析日期字符串
     默认格式yyyy-MM-dd，但可以修改。
     
     - returns: 解析NSDate 如果不是的话，就为空
     */
    func toDate(_ format: String? = "yyyy-MM-dd") -> Foundation.Date? {
        let text = self.removeSpaces().lowercased()
        let dateFmt = DateFormatter()
        dateFmt.timeZone = TimeZone.current
        if let fmt = format {
            dateFmt.dateFormat = fmt
        }
        return dateFmt.date(from: text)
    }
    
    /**
     解析日期字符串
     默认格式yyyy-MM-dd HH-mm-ss，但可以修改。
     
     - returns: 解析NSDate 如果不是的话，就为空
     */
    func toDateTime(_ format: String? = "yyyy-MM-dd HH-mm-ss") -> Foundation.Date? {
        return toDate(format)
    }
    
    /**
     删除最左边和参数一样的字符 若空则删除空格
     
     - returns: Stripped string
     */
    func trimmedLeft (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        if let range = rangeOfCharacter(from: set.inverted) {
            return String(self[range.lowerBound..<endIndex])
        }
        
        return ""
    }
    
    /**
     删除最右边和参数一样的字符 若空则删除空格
     
     - returns: Stripped string
     */
    func trimmedRight (characterSet set: CharacterSet = CharacterSet.whitespacesAndNewlines) -> String {
        if let range = rangeOfCharacter(from: set.inverted, options: NSString.CompareOptions.backwards) {
            return String(self[startIndex..<range.upperBound])
        }
        
        return ""
    }
    
    /**
     删除字符串首部和最后空格
     
     - returns: Stripped string
     */
    func removeSpaces() -> String {
        return trimmedLeft().trimmedRight()
    }
    
    /**
     删除左边和参数相同的字符
     
     - returns: Stripped string
     */
    func removeLeftSpaces(_ str: String) -> String {
        return trimmedLeft(characterSet: CharacterSet(charactersIn: str))
    }
    
    /**
     删除右边和参数相同的字符
     
     - returns: Stripped string
     */
    func removeRightSpaces(_ str: String) -> String {
        return trimmedRight(characterSet: CharacterSet(charactersIn: str))
    }
    
    /// 根据输入的分隔符，把字符串分割成数组
    ///
    /// :return Array
    public func split(_ delimiter: Character) -> [String] {
        return self.components(separatedBy: String(delimiter))
    }
    
    /// 删除字符串前的空格
    ///
    /// :return 没有前置空格的String
    public func lstrip() -> String {
        return self.trim()
    }
    
    /// 删除字符串后的空格
    ///
    /// :return 没有后置空格的String
    public func rstrip() -> String {
        return self.trim()
    }
    
    /// 删除字符串前后的空格
    ///
    /// :return 没有前后空格的String
    public func strip() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    //    /// 字符串拆分成单词数组
    //    func words() -> [String] {
    //        let hasComplexWordRegex = try! NSRegularExpression(pattern: RegexHelper.hasComplexWord, options: [])
    //        let wordRange = NSMakeRange(0, self.characters.count)
    //        let hasComplexWord = hasComplexWordRegex.rangeOfFirstMatch(in: self, options: [], range: wordRange)
    //        let wordPattern = hasComplexWord.length > 0 ? RegexHelper.complexWord : RegexHelper.basicWord
    //        let wordRegex = try! NSRegularExpression(pattern: wordPattern, options: [])
    //        let matches = wordRegex.matches(in: self, options: [], range: wordRange)
    //        let words = matches.map { (result: NSTextCheckingResult) -> String in
    //            if let range = self.rangeFromNSRange(result.range) {
    //                return self.substring(with: range)
    //            } else {
    //                return ""
    //            }
    //        }
    //        return words
    //    }
    
    /// Strip string of accents and diacritics
    func deburr() -> String {
        let mutString = NSMutableString(string: self)
        CFStringTransform(mutString, nil, kCFStringTransformStripCombiningMarks, false)
        return mutString as String
    }
    
    //    /// Converts an NSRange to a Swift friendly Range supporting Unicode
    //    ///
    //    /// :param nsRange the NSRange to be converted
    //    /// :return A corresponding Range if possible
    //    func rangeFromNSRange(_ nsRange : NSRange) -> Range<String.Index>? {
    //
    //        let from16 = utf16.startIndex.advancedBy(nsRange.location, limit: utf16.endIndex)
    //        let to16 = from16.advancedBy(nsRange.length, limit: utf16.endIndex)
    //        if let from = String.Index(from16, within: self),
    //            let to = String.Index(to16, within: self) {
    //                return from ..< to
    //        } else {
    //            return nil
    //        }
    //    }
    
}

infix operator =~

/// Regex match the string on the left with the string pattern on the right
///
/// :return true if string matches the pattern otherwise false
public func =~ (str: String, pattern: String) -> Bool {
    return false
}

/// Concat the string to itself n times
///
/// :return concatenated string
public func * (str: String, n: Int) -> String {
    return ""
}

extension String {
    
    public func isMatch(_ regex: String, options: NSRegularExpression.Options) -> Bool {
        var exp: NSRegularExpression?
        
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
            
        } catch _ as NSError {
            
        }
        
        let matchCount = exp!.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.length))
        return matchCount > 0
    }
    
    public func getMatches(_ regex: String, options: NSRegularExpression.Options) -> [NSTextCheckingResult] {
        
        var exp: NSRegularExpression?
        
        do {
            exp = try NSRegularExpression(pattern: regex, options: options)
            
        } catch _ as NSError {
            
        }
        let matches = exp!.matches(in: self, options: [], range: NSRange(location: 0, length: self.length))
        return matches as [NSTextCheckingResult]
    }
    
    fileprivate var vowels: [String] {
        return ["a", "e", "i", "o", "u"]
    }
    
    fileprivate var consonants: [String] {
        return ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "z"]
    }
    
    //    public func regexMatchesInString(_ regexString:String) -> [String] {
    //
    //        var arr :[String] = []
    //        var rang = (self.characters.indices)
    //        var foundRange:Range<String.Index>?
    //
    //        repeat{
    //
    //            foundRange = self.range(of: regexString, options: NSString.CompareOptions.regularExpression, range: rang, locale: nil)
    //
    //            if let a = foundRange {
    //                arr.append(self.substring(with: a))
    //                rang.lowerBound = a.upperBound
    //            }
    //        }
    //            while foundRange != nil
    //
    //
    //        return arr
    //        //"Hello".regexMatchesInString("[^Hh]{1,}")
    //    }
    
}

public extension String {
    
    var toInt: Int {
        return Int(self)!
    }
    
    var toInt32: Int32 {
        return Int32(self)!
    }
    
    var toInt64: Int64 {
        // 32 bit check needed
        return (Int(self) != nil) ? Int64(self)! : ((self as NSString).longLongValue)
    }
    
    var toNumber: NSNumber {
        return NSNumber(value: self.toInt as Int)
    }
    
    var toNumber_32Bit: NSNumber {
        return NSNumber(value: self.toInt32 as Int32)
    }
    
    var toNumber_64Bit: NSNumber {
        return NSNumber(value: self.toInt64 as Int64)
    }
}

// MARK: BASIC
public extension String {
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespaces)
    }
    
    func trimNewLine() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    func contains(_ str: String?) -> Bool {
        return (self.range(of: str!) != nil) ? true : false
    }
    
    func replaceCharacterWith(_ characters: String, toSeparator: String) -> String {
        let characterSet = CharacterSet(charactersIn: characters)
        let components = self.components(separatedBy: characterSet)
        let result = components.joined(separator: toSeparator)
        return result
    }
    
    func wipeCharacters(_ characters: String) -> String {
        return self.replaceCharacterWith(characters, toSeparator: "")
    }
    
    func replace(find findStr: String, replaceStr: String) -> String {
        return self.replacingOccurrences(of: findStr, with: replaceStr, options: NSString.CompareOptions.literal, range: nil)
    }
    
    //    func splitStringWithLimit(_ delimiter:String?="", limit:Int=0) -> [String]{
    //        let arr = self.components(separatedBy: (delimiter != nil ? delimiter! : ""))
    //        return Array(arr[0 ..< (limit > 0 ? min(limit, arr.count) : arr.count)])
    //
    //        // use : print(s.split(",", limit:2))  //->["part1","part2"]
    //    }
    
    func createURL() -> URL {
        return URL(string: self)!
    }
    
    func isEmailValid(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: email)
        
        return result
    }
    
    /**
     检查是不是手机号
     
     - returns: true 是手机号
     */
    func isTelNumber() -> Bool {
        let mobile = "^1+[34578]+\\d{9}"
        let newMobile = "/^(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$/"
        let  CM = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
        let  CU = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
        let  CT = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
        let regextestmobile = NSPredicate(format: "SELF MATCHES %@", mobile)
        let regextestNewmobile = NSPredicate(format: "SELF MATCHES %@", newMobile)
        let regextestcm = NSPredicate(format: "SELF MATCHES %@", CM )
        let regextestcu = NSPredicate(format: "SELF MATCHES %@", CU)
        let regextestct = NSPredicate(format: "SELF MATCHES %@", CT)
        if ((regextestmobile.evaluate(with: self) == true)
            || (regextestNewmobile.evaluate(with: self) == true)
            || (regextestcm.evaluate(with: self) == true)
            || (regextestct.evaluate(with: self) == true)
            || (regextestcu.evaluate(with: self) == true)) {
            return true
        } else {
            return false
        }
    }
    
    /**
     验证是不是身份证号
     
     - returns: true 是身份证号
     */
    func isUserIdCard() -> Bool {
        //       let isIDCard1 = "/^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$/"
        //       let isIDCard2 = "/^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|X)$/"
        //        let pattern = "\(isIDCard1)|\(isIDCard2)"
        //        let pattern = "(^[0-9]{15}$)|([0-9]{17}([0-9]|X|x)$)"
        let partternTwo = "^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[X])$)$"
        let regextestcm = NSPredicate(format: "SELF MATCHES %@", partternTwo)
        if(regextestcm.evaluate(with: self) == true) {
            if(self == "111111111111111111") {
                
                return false
            }
            return true
        } else {
            
            return false
        }
    }
    
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func containsEmoji() -> Bool {
        for scalar in unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,
                 0x1F300...0x1F5FF,
                 0x1F680...0x1F6FF,
                 0x2600...0x26FF,
                 0x2700...0x27BF,
                 0xFE00...0xFE0F:
                return true
            default:
                continue
            }
        }
        
        return false
    }
    
    /// 判断是不是Emoji
    ///
    /// - Returns: true false
    func hasEmoji() -> Bool {
        
        let pattern = "[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]"
        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
        return pred.evaluate(with: self)
    }
    
    /// 判断是不是九宫格
    ///
    /// - Returns: true false
    func isNineKeyBoard() -> Bool {
        let other: NSString = "➋➌➍➎➏➐➑➒"
        let len = self.length
        for _ in 0 ..< len {
            if !(other.range(of: self).location != NSNotFound) {
                return false
            }
        }
        
        return true
    }
    
    /**
     判断是不是英文或者数字
     */
    func isEnglishOrNumber() -> Bool {
        let emailRegEx = "^[a-zA-Z0-9]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /**
     判断是不是英文
     */
    func isEnglish() -> Bool {
        let emailRegEx = "^[a-zA-Z]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    /**
     判断是不是数字
     */
    func isNumber() -> Bool {
        let emailRegEx = "^[0-9]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    /**
     判断是不是Double
     */
    func isDouble() -> Bool {
        let emailRegEx = "^[0-9.]+$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    /**
     判断是不是汉字 ➋ 这种东西可能导致 某些机型不能输入汉字
     */
    func isHanZi() -> Bool {
        let emailRegEx = "([\\u4e00-\\u9fa5]{1,4})|([\\u4e00-\\u9fa5]{2,9})"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    /**
     判断是不是汉字英文或者数字
     */
    func isHanZiOrEnglishOrNumber() -> Bool {
        let emailRegEx = "[\\u4e00-\\u9fa5\\w]+"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        
        return emailTest.evaluate(with: self)
    }
    
    /**
     监测对象的类型
     
     - returns: 对象类型ObjectType
     */
    func checkObjectType() -> ObjectType {
        switch self {
        case "NSArray": return .nsListType
        case "NSMutableArray": return .nsListType
        case "Array": return .nsListType
        case "NSSet": return .nsSetType
        case "NSMutableSet": return .nsSetType
        case "Set": return .nsSetType
        case "String": return .nsObjectType
        case "Dictionary": return .nsObjectType
        case "Int": return .nsObjectType
        case "Int8": return .nsObjectType
        case "Int16": return .nsObjectType
        case "Int32": return .nsObjectType
        case "Int64": return .nsObjectType
        case "Float": return .nsObjectType
        case "Double": return .nsObjectType
        case "CGFloat": return .nsObjectType
        default:
            if(self.contains("NS")) {
                return .nsObjectType
            } else {
                return .unNSObjectType
            }
        }
        
    }
    
    /**
     提取字符串中的数字
     [NSCharacterSet alphanumericCharacterSet];          //所有数字和字母(大小写)
     [NSCharacterSet decimalDigitCharacterSet];          //0-9的数字
     [NSCharacterSet letterCharacterSet];                //所有字母
     [NSCharacterSet lowercaseLetterCharacterSet];       //小写字母
     [NSCharacterSet uppercaseLetterCharacterSet];       //大写字母
     [NSCharacterSet punctuationCharacterSet];           //标点符号
     [NSCharacterSet whitespaceAndNewlineCharacterSet];  //空格和换行符
     [NSCharacterSet whitespaceCharacterSet];            //空格
     - returns: 返回数字字符串
     */
    func getNumberForString() -> String {
        
        let str = self as NSString
        
        let numberArr = str.components(separatedBy: CharacterSet.decimalDigits.inverted)
        
        let numberString = (numberArr as NSArray).componentsJoined(by: "")
        
        return numberString
        
    }
    
}

extension String {
    
    /**
     根据类名生成实例对象
     
     - returns: 实例对象
     */
    func classFromString() -> NSObject? {
        // get the project name
        if  let appName: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            let classStringName = "\(appName).\(self)"
            let classType = NSClassFromString(classStringName) as? NSObject.Type
            if let type = classType {
                let newClass = type.init()
                return newClass
            }
        }
        return nil
    }
    
}

// MARK: - 项目逻辑相关
extension String {
    
    /// 判定字符串是否是一个完整的URL
    func isRealUrl() -> Bool {
        let url = URL(string: self)
        if url == nil || url?.scheme == nil || url?.scheme?.length == 0 {
            return false
        }
        return true
    }
    
    func iconUrlIsEqualTo(_ otherUrl: String) -> Bool {
        
        if(!otherUrl.contains("Time=")) { return false }
        if(!self.contains("Time=")) { return false }
        let otherArray = otherUrl.components(separatedBy: "Time=")
        let array = self.components(separatedBy: "Time=")
        if(array[1] == otherArray[1]) { return true }
        
        return false
    }
    
    /**
     转换成UTF8的数组
     
     - returns:
     */
    func toUInt8Map() -> [UInt8] {
        
        return self.utf8.lazy.map({ $0 as UInt8 })
    }
}
