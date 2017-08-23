//
//  TKSLinkDetectingTextStorage.swift
//  TextKitStudy
//
//  Created by steven on 2/17/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSLinkDetectingTextStorage: NSTextStorage {
    
    fileprivate lazy var imp:NSMutableAttributedString = {
        var _imp:NSMutableAttributedString = NSMutableAttributedString()
        return _imp
    }()
    
    
    override var string:String
    {
        get{
            return self.imp.string
        }
    }
    
    override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
        
        return self.imp.attributes(at: location, effectiveRange: range)
    }
    
    override func replaceCharacters(in range: NSRange, with str: String) {
        self.beginEditing()
        self.imp.replaceCharacters(in: range, with: str)
        self.edited(.editedCharacters, range: range, changeInLength: str.characters.count)
        
        
        
        
        
        self.endEditing()
    }
    
    override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
        self.beginEditing()
        self.imp.setAttributes(attrs, range: range)
        self.edited(.editedAttributes, range: range, changeInLength: 0)
        self.endEditing()
    }
    
    override func processEditing() {
        super.processEditing()

        //添加下划线
        let linkDetector:NSDataDetector? = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range:NSRange = (self.string as NSString).paragraphRange(for: NSMakeRange(0, self.string.characters.count))
        
        self.imp.removeAttribute(NSLinkAttributeName, range: range)
        self.imp.removeAttribute(NSForegroundColorAttributeName, range: range)
        self.imp.removeAttribute(NSUnderlineStyleAttributeName, range: range)
        
        if linkDetector != nil
        {
            linkDetector!.enumerateMatches(in: self.imp.string, options:NSRegularExpression.MatchingOptions(rawValue: 0), range: range) { [weak self](textCheckingResult:NSTextCheckingResult?, flags:NSRegularExpression.MatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
                if textCheckingResult != nil
                {
                    self?.imp.addAttribute(NSLinkAttributeName, value: textCheckingResult!.url!, range: textCheckingResult!.range)
//                    self?.imp.addAttribute(NSForegroundColorAttributeName, value: UIColor.yellowColor(), range: textCheckingResult!.range)
                    self?.imp.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: textCheckingResult!.range)
                }
            }
            
        }

    }
}
