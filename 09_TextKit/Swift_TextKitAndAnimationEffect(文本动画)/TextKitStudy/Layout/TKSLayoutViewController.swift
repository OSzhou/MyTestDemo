//
//  TKSLayoutViewController.swift
//  TextKitStudy
//
//  Created by steven on 2/21/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSLayoutViewController: UIViewController, NSLayoutManagerDelegate{
    
    fileprivate lazy var textLayoutManager:TKSOutliningLayoutManager = {
        let layoutManager = TKSOutliningLayoutManager()
        layoutManager.delegate = self
        return layoutManager
    }()
    
    fileprivate lazy var textStorage:TKSLinkDetectingTextStorage = {
        let path:String = Bundle.main.path(forResource: "layout", ofType: "txt")!
        let textStorage:TKSLinkDetectingTextStorage = TKSLinkDetectingTextStorage()
        
        do{
            let text:String = try String(contentsOfFile: path)
            let attributed:NSMutableAttributedString = NSMutableAttributedString(string: text)
            textStorage.setAttributedString(attributed)
        }catch _
        {
            print("Something went wrong!")
            let textStorage:TKSLinkDetectingTextStorage = TKSLinkDetectingTextStorage()
        }
        return textStorage
    }()
    
    fileprivate lazy var textView:UITextView = {
        self.textStorage.addLayoutManager(self.textLayoutManager)
        let textContainer:NSTextContainer = NSTextContainer()
        self.textLayoutManager.addTextContainer(textContainer)
        let textView = UITextView(frame: CGRect.zero, textContainer: textContainer)
        return textView
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.addSubview(self.textView)
        self.textView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addConstraints(
            [
            NSLayoutConstraint(item: self.textView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal, toItem: self.view, attribute: NSLayoutAttribute.top, multiplier: 1, constant: 20),

            NSLayoutConstraint(item: self.view, attribute: .bottom, relatedBy: .equal, toItem: self.textView, attribute: .bottom, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.view, attribute: .leading, relatedBy: .equal, toItem: self.textView, attribute: .leading, multiplier: 1.0, constant: 0),
            NSLayoutConstraint(item: self.view, attribute: .trailing, relatedBy: .equal, toItem: self.textView, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - NSLayoutManager delegate
    
    func layoutManager(_ layoutManager: NSLayoutManager, lineSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return CGFloat(glyphIndex/100)
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, shouldBreakLineByWordBeforeCharacterAt charIndex: Int) -> Bool {
        
        var rangePointer:NSRange = NSMakeRange(NSNotFound, 0)
        
        let URLLink:URL? = layoutManager.textStorage?.attribute(NSLinkAttributeName, at: charIndex, effectiveRange: &rangePointer) as? URL
        if (URLLink != nil) && charIndex > rangePointer.location && charIndex <= NSMaxRange(rangePointer)
        {
            return false
        }else
        {
            return true
        }
    }
    
    func layoutManager(_ layoutManager: NSLayoutManager, paragraphSpacingAfterGlyphAt glyphIndex: Int, withProposedLineFragmentRect rect: CGRect) -> CGFloat {
        return 100
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
