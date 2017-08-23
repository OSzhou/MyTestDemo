//
//  InteractionViewController.swift
//  TextKitStudy
//
//  Created by steven on 3/7/16.
//  Copyright © 2016 Steven lv. All rights reserved.
//

import UIKit

class InteractionViewController: UIViewController,UITextViewDelegate {

    var circleView:TextCircleView = TextCircleView()
    
    @IBOutlet weak var textView: UITextView!
    
    var panOffset:CGPoint = CGPoint.zero

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.reloadText()
        self.configuration()
        self.updateExclusionPaths()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateExclusionPaths()

    }
    
    func reloadText()
    {
        let path:String? = Bundle.main.path(forResource: "lorem", ofType: "txt")
        guard path != nil else { return }
        var encoding:String.Encoding = .ascii
        let content:String? = try? String(contentsOfFile: path!, usedEncoding:&encoding)
        guard content != nil else { return }
        self.textView.textStorage.replaceCharacters(in: NSMakeRange(0, 0), with: content!)
    }
    
    func configuration()
    {
        self.textView.addSubview(self.circleView)
        self.circleView.addGestureRecognizer(
            UIPanGestureRecognizer(
                                target: self,
                                action: #selector(InteractionViewController.panGestureRecognizer(_:))
                                 )
        )
//        self.circleView.opaque = false
        self.circleView.frame = CGRect(x: (UIScreen.main.bounds.width-234)/2, y: (UIScreen.main.bounds.height-234)/2, width: 234, height: 234)
        self.circleView.clipsToBounds = true
        self.circleView.backgroundColor = UIColor.clear
        self.textView.layoutManager.hyphenationFactor = 1.0;

    }
    
    
    
    func panGestureRecognizer(_ panGestureRecognizer:UIPanGestureRecognizer)
    {
        
        //MARK:PlanA
        /*
        //这个是手指在self.view这个coordinate system上的location
        let lastLocation:CGPoint = panGestureRecognizer.locationInView(self.view)
        if panGestureRecognizer.state == .Began
        {
            //这个是手指在self.circleView这个coordinate system上的location
            panOffset = panGestureRecognizer.locationInView(self.circleView)
            print("began:\(panOffset)")
        }
        if panGestureRecognizer.state == .Changed
        {
            print("changed:\(panOffset)")

        }
        if panGestureRecognizer.state == .Ended
        {
            print("Ended:\(panOffset)")

        }
        let center:CGPoint = CGPointMake(lastLocation.x-panOffset.x+self.circleView.frame.size.width/2,lastLocation.y-panOffset.y+self.circleView.frame.size.height/2)
        self.circleView.center = center
        */
        //MARK:PlanB
        if panGestureRecognizer.state == .changed || panGestureRecognizer.state == .ended
        {
            let offsetInCircle = panGestureRecognizer.translation(in: self.circleView)
            print("circleViewOffset:\(offsetInCircle)")
            let offsetInView = panGestureRecognizer.translation(in: self.view)
            print("viewOffset:\(offsetInView)")
            self.circleView.center.x += offsetInView.x
            self.circleView.center.y += offsetInView.y
            panGestureRecognizer.setTranslation(CGPoint.zero, in: self.circleView)
        }
        self.updateExclusionPaths()
        
    }
    
    func updateExclusionPaths()
    {
        var ovalFrame = self.textView.convert(self.circleView.bounds, from: self.circleView)
        ovalFrame.origin.x -= self.textView.textContainerInset.left
        ovalFrame.origin.y -= self.textView.textContainerInset.top
        let bezierPaht:UIBezierPath = UIBezierPath(ovalIn: ovalFrame)
        self.textView.textContainer.exclusionPaths = [bezierPaht]
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
