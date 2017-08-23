//
//  TextCircleView.swift
//  TextKitStudy
//
//  Created by steven on 3/7/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

@IBDesignable
class TextCircleView: UIView {

//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.tintColor.setFill()
        UIBezierPath(ovalIn: self.bounds).fill()
        ("move" as NSString).draw(in: CGRect(x: rect.size.width/2.9, y: rect.size.height/3, width: rect.size.width, height: rect.size.height), withAttributes: [NSForegroundColorAttributeName:UIColor.red,NSFontAttributeName:UIFont.systemFont(ofSize: 18)])

    }


}
