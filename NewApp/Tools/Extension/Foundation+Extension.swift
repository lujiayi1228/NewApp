//
//  String+Extension.swift
//  FirstSwiftApp
//
//  Created by weijieMac on 2018/8/10.
//  Copyright © 2018年 Mac. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    /// 使用下标截取字符串 例: "示例字符串"[0..<2] 结果是 "示例"
    subscript (r: Range<Int>) -> String {
        get {
            if (r.lowerBound > count) || (r.upperBound > count) { return "截取超出范围" }
            let startIndex = self.index(self.startIndex, offsetBy: r.lowerBound)
            let endIndex = self.index(self.startIndex, offsetBy: r.upperBound)
            return String(self[startIndex..<endIndex])
        }
    }
    
    
    /// 十六进制字符串转十进制int
    func hexStringToInt() -> Int {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    /// 手机号正则
    ///
    /// - Returns: true or false
    func isPhoneNumber()-> Bool{
        
        for char in self{
            if char == "_"{
                return false
            }
        }
        
        var result = ""
        // - 1、创建规则
        let pattern1 = "1[0-9]{10}"
        //        let pattern1 = "^[a-zA-Z\\u4e00-\\u9fa5][a-zA-Z0-9\\u4e00-\\u9fa5]$"
        // - 2、创建正则表达式对象
        let regex1 = try! NSRegularExpression(pattern: pattern1, options: NSRegularExpression.Options.caseInsensitive)
        // - 3、开始匹配
        let res = regex1.matches(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count))
        // 输出结果
        for checkingRes in res {
            result = result + (self as NSString).substring(with: checkingRes.range)
        }
        if result == self{
            return true
        }else{
            return false
        }
        
    }
}


public extension Double {
    public static func randomDoubleNumber(lower: Double = 0,upper: Double = 100) -> Double {
        return (Double(arc4random())/Double(UInt32.max))*(upper - lower) + lower
    }
}

public extension Int {
    public static func randomIntNumber(lower: Int = 0,upper: Int = Int(UInt32.max)) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower)))
    }
}

public extension CGFloat {
    public static func randomCGFloatNumber(lower: CGFloat = 0,upper: CGFloat = 1) -> CGFloat {
        return CGFloat(Float(arc4random()) / Float(UInt32.max)) * (upper - lower) + lower
    }
}

extension Date {
    var milliStamp : CLongLong {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return millisecond
    }
    
    var timeStamp : Int {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return timeStamp
    }
}
