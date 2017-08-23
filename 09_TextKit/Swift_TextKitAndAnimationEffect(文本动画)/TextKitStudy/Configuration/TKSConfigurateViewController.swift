//
//  TKSConfigurateViewController.swift
//  TextKitStudy
//
//  Created by steven on 2/4/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class TKSConfigurateViewController: UIViewController {

    @IBOutlet weak var viewContainerTwo: UIView!
    
    @IBOutlet weak var viewContainerThree: UIView!
    
    @IBOutlet weak var textViewOne: UITextView!
    
    @IBOutlet weak var textViewTwo: UITextView!
    
    @IBOutlet weak var textViewThree: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storageTextOne:NSTextStorage = self.textViewOne.textStorage
        
        let stringULR:String? = Bundle.main.path(forResource: "lorem", ofType: "txt")
        
        if let urlStr:String = stringULR
        {
            do
            {
                let content:String   = try NSString(contentsOfFile: urlStr, encoding: String.Encoding.utf8.rawValue) as String
                print("\(content)")
                
                storageTextOne.replaceCharacters(in: NSMakeRange(0, 0), with: content)
                
                let otherLayoutManager:NSLayoutManager = NSLayoutManager()
                storageTextOne.addLayoutManager(otherLayoutManager)
                
                let otherTextContainer:NSTextContainer = NSTextContainer()
                otherLayoutManager.addTextContainer(otherTextContainer)
                
                let otherTextView:UITextView = UITextView(frame: CGRect.zero, textContainer: otherTextContainer)
                otherTextView.backgroundColor = UIColor.purple
                
//                otherTextView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
                otherTextView.isScrollEnabled = false
                
                self.viewContainerTwo.addSubview(otherTextView)
                
                otherTextView.translatesAutoresizingMaskIntoConstraints = false
                
                self.viewContainerTwo.addConstraints([
                    NSLayoutConstraint(item: otherTextView, attribute: .top, relatedBy: .equal, toItem: self.viewContainerTwo, attribute: .top, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: otherTextView, attribute: .bottom, relatedBy: .equal, toItem: self.viewContainerTwo, attribute: .bottom, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: otherTextView, attribute: .left, relatedBy: .equal, toItem: self.viewContainerTwo, attribute: .left, multiplier: 1, constant: 0),
                    NSLayoutConstraint(item: otherTextView, attribute: .right, relatedBy: .equal, toItem: self.viewContainerTwo, attribute: .right, multiplier: 1, constant: 0)
                    ])
                
                let thirdTextContainer:NSTextContainer = NSTextContainer()
                otherLayoutManager.addTextContainer(thirdTextContainer)
                
                let thirdTextView:UITextView = UITextView(frame: CGRect.zero, textContainer: thirdTextContainer)
//                thirdTextView.autoresizingMask = [.FlexibleWidth,.FlexibleHeight]
                self.viewContainerThree.addSubview(thirdTextView)
                
                thirdTextView.translatesAutoresizingMaskIntoConstraints = false
                self.viewContainerThree.addConstraints(
                    [
                        NSLayoutConstraint(item: thirdTextView, attribute: .top, relatedBy: .equal, toItem: self.viewContainerThree, attribute: .top, multiplier: 1.0, constant: 0.0),
                        NSLayoutConstraint(item: thirdTextView, attribute: .bottom, relatedBy: .equal, toItem: self.viewContainerThree, attribute: .bottom, multiplier: 1.0, constant: 0.0),
                         NSLayoutConstraint(item: thirdTextView, attribute: .left, relatedBy: .equal, toItem: self.viewContainerThree, attribute: .left, multiplier: 1.0, constant: 0.0),
                         NSLayoutConstraint(item: thirdTextView, attribute: .right, relatedBy: .equal, toItem: self.viewContainerThree, attribute: .right, multiplier: 1.0, constant: 0.0)
                    ]
                )
                
                
            }
            catch let error as NSError
            {
                print("\(error)")
            }
            

        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
