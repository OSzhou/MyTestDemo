//
//  MultiColumnAndPagesViewController.swift
//  TextKitStudy
//
//  Created by steven on 3/10/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class MultiColumnAndPagesViewController: UIViewController {

    @IBOutlet weak var backgroundScrollView: UIScrollView!
    
    
    fileprivate lazy var layoutManager:NSLayoutManager = {
        let localLayoutManager:NSLayoutManager = NSLayoutManager()
        return localLayoutManager
    }()
    
    fileprivate lazy  var textStorage:NSTextStorage? = {
        let contentPath:String? = Bundle.main.path(forResource: "content", ofType: "txt")
        guard contentPath != nil else {return nil}
        let contentString:String? = try? String(contentsOfFile: contentPath!)
        guard contentString != nil else {return nil}
        let localTextStorage:NSTextStorage = NSTextStorage(string: contentString!)
        return localTextStorage
        }()
    
    deinit {
        print("销毁")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundScrollView.translatesAutoresizingMaskIntoConstraints = false
        self.textStorage?.addLayoutManager(self.layoutManager)
        self.layoutTextContainer()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -layoutTextContainer
    func layoutTextContainer() {
        
        var lastRenderGlyph:Int = 0
        var currentXOffset:CGFloat = 0
        while lastRenderGlyph < self.layoutManager.numberOfGlyphs
        {
            let textViewFrame:CGRect = CGRect(x: currentXOffset, y: 10, width: self.backgroundScrollView.bounds.width/2,
                height: self.backgroundScrollView.bounds.height-20)
            let columnSize:CGSize = CGSize(
                width: textViewFrame.width-20,
                height: textViewFrame.height-10)
            let textContainer:NSTextContainer = NSTextContainer(size: columnSize)
            self.layoutManager.addTextContainer(textContainer)
            
            let textView:UITextView = UITextView(frame: textViewFrame, textContainer: textContainer)
            textView.isScrollEnabled = false
            self.backgroundScrollView.addSubview(textView)
            
            lastRenderGlyph = NSMaxRange(self.layoutManager.glyphRange(for: textContainer))
            currentXOffset += textViewFrame.width
            
        }
        
        let contentSize:CGSize = CGSize(width: currentXOffset, height: self.backgroundScrollView.bounds.height)
        self.backgroundScrollView.contentSize = contentSize
        
        
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
