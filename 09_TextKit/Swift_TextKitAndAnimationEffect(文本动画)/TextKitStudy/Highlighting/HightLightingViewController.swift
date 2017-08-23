//
//  HightLightingViewController.swift
//  TextKitStudy
//
//  Created by steven on 2/4/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class HightLightingViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!

    @IBOutlet weak var bottomInSet: NSLayoutConstraint!
    
    fileprivate lazy var textSotrage:HightLightingTextStorage = {
        let _textStorage:HightLightingTextStorage = HightLightingTextStorage()
        return _textStorage
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.textSotrage.addLayoutManager(self.textView.layoutManager)
        self.textSotrage.replaceCharacters(in: NSMakeRange(0, 0), with: try! String(contentsOfFile: Bundle.main.path(forResource: "iText", ofType: "txt")!, encoding: String.Encoding.utf8))

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShowOrHide:"), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: Selector("keyboardWillShowOrHide:"), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func keyboardWillShowOrHide(_ notifcation:Notification)
    {
        
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
