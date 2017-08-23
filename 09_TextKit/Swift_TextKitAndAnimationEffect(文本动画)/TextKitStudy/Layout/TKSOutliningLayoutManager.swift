//
//  TKSOutliningLayoutManager.swift
//  TextKitStudy
//
//  Created by steven on 2/17/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSOutliningLayoutManager: NSLayoutManager {
    
    var count:Int = 0;
    
    override func drawGlyphs(forGlyphRange glyphsToShow: NSRange, at origin: CGPoint) {
        super.drawGlyphs(forGlyphRange: glyphsToShow, at: origin)
    }
    
    override func drawUnderline(forGlyphRange glyphRange: NSRange, underlineType underlineVal: NSUnderlineStyle, baselineOffset: CGFloat, lineFragmentRect lineRect: CGRect, lineFragmentGlyphRange lineGlyphRange: NSRange, containerOrigin: CGPoint) {
        super.drawUnderline(forGlyphRange: glyphRange, underlineType: underlineVal, baselineOffset: baselineOffset, lineFragmentRect: lineRect, lineFragmentGlyphRange: lineGlyphRange, containerOrigin: containerOrigin)
        
        //Left border (== position) of first underlined graphly
        let firstPosition:CGFloat = self.location(forGlyphAt: glyphRange.location).x
        var lastPosition:CGFloat;
        if NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)
        {
            lastPosition = self.location(forGlyphAt: NSMaxRange(glyphRange)).x
        }else
        {
            lastPosition = self.lineFragmentUsedRect(forGlyphAt: NSMaxRange(glyphRange)-1, effectiveRange: nil).size.width
        }
        //计算被调用次数
        count += 1
        print("\(self.count)")
        
        var lineFragmentRect = lineRect
        print("containerOrigin:\(containerOrigin)")
        print("前lineFragmentRect:\(lineFragmentRect)")
        
        lineFragmentRect.origin.x += firstPosition
        lineFragmentRect.size.width = lastPosition - firstPosition
        
//
        lineFragmentRect.origin.x += containerOrigin.x
        lineFragmentRect.origin.y += containerOrigin.y
        
        print("后lineFragmentRect:\(lineFragmentRect)")
        lineFragmentRect = lineFragmentRect.integral.insetBy(dx: 0.5, dy: 0.5);

        
        UIColor.red.set()
        UIBezierPath(rect: lineFragmentRect).stroke()

        
        
        
        
    }
    
    
    override func setLineFragmentRect(_ fragmentRect: CGRect, forGlyphRange glyphRange: NSRange, usedRect: CGRect) {
        super.setLineFragmentRect(fragmentRect, forGlyphRange: glyphRange, usedRect: usedRect)
//        var lineFragmentRect = fragmentRect
//        lineFragmentRect = CGRectInset(CGRectIntegral(lineFragmentRect), 0.5, 0.5)
        
        
        //        UIColor.yellowColor().set()
        //        UIGraphicsBeginImageContext(fragmentRect.size)
        //        let context = UIGraphicsGetCurrentContext()
        //        UIGraphicsPushContext(context!)
//        UIColor.yellowColor().set()
        //        CGContextSaveGState(context)
        //        CGContextSetLineWidth(context, 1.0)
        //        CGContextSetLineJoin(context, CGLineJoin.Round)
//        UIBezierPath(rect: lineFragmentRect).stroke()
        
        //        let path = UIBezierPath(rect: lineFragmentRect)
        //        CGContextAddPath(context, path.CGPath)
        //        CGContextStrokePath(context)
        //        CGContextSetStrokeColorWithColor(context, UIColor.yellowColor().CGColor)
        //        CGContextRestoreGState(context)
        //        UIGraphicsPopContext()
        //        UIGraphicsEndImageContext()
        
    }
    
}


