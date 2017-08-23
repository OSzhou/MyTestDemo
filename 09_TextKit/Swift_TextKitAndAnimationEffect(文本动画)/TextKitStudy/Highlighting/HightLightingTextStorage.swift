//
//  HightLightingTextStorage.swift
//  TextKitStudy
//
//  Created by steven on 2/4/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class HightLightingTextStorage: NSTextStorage {
    fileprivate lazy var imp:NSMutableAttributedString = {
        var imp:NSMutableAttributedString = NSMutableAttributedString(string: "")
        return imp
    }()
    
    static var iExpression:NSRegularExpression?
    
    override internal init()
    {
        super.init()
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override  var string:String {
        get{
            return self.imp.string
        }
    }
    
    override  func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        return self.imp.attributes(at: location, effectiveRange: range)
    }
    
    override  func replaceCharacters(in range: NSRange, with str: String) {
        
        self.imp.replaceCharacters(in: range, with: str)
        self.edited(.editedCharacters, range: range, changeInLength: str.characters.count)
        
    }
    
    override  func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        self.imp.setAttributes(attrs, range: range)
        self.edited(.editedAttributes, range: range, changeInLength: 0)
    }
    
    override func processEditing() {
        super.processEditing()

        HightLightingTextStorage.iExpression = try? NSRegularExpression(
            pattern:"i[\\p{Alphabetic}&&\\p{Uppercase}][\\p{Alphabetic}]+",
            options: NSRegularExpression.Options(rawValue: 0))
        print("\(HightLightingTextStorage.iExpression)")
        
        let paragraphRange:NSRange = (self.string as NSString).paragraphRange(for: self.editedRange)
        
        self.removeAttribute(NSForegroundColorAttributeName, range: paragraphRange)
        
        HightLightingTextStorage.iExpression?.enumerateMatches(in: self.string, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: paragraphRange, using: {
                [weak self](result:NSTextCheckingResult?, flags:NSRegularExpression.MatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                    if let textResult = result {
                        self?.addAttribute(NSForegroundColorAttributeName, value: UIColor.red, range: textResult.range)
                    }
        })
        
        
        
    }

}
