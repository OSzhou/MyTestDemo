//
//  FMMagnifyViewController.swift
//  TestCode
//
//  Created by Zhouheng on 2020/6/28.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class FMMagnifyViewController: UIViewController {
    
    // magnify --- begin
    let magnifyW: CGFloat = 150
    let multiple: CGFloat = 1
    var zoomScale: CGFloat = 0
    static var image: UIImage? = UIImage(named: "beauty_03")
    let imageSize: CGSize = image?.size ?? .zero
    // magnify --- end
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .gray
        setupUI()
    }
    
    private func setupUI() {
        zoomScale = screenWidth / imageSize.width
        
        view.addSubview(scrollView)
        
        scrollView.addSubview(normalImageView)
        normalImageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        
        scrollView.setZoomScale(zoomScale, animated: false)
        
        view.addSubview(magnifyView)
        magnifyView.frame = CGRect(x: 0, y: 88, width: magnifyW, height: magnifyW - 2)
        
    }
    
    @objc func panGesture(_ gesture: UIPanGestureRecognizer) {
        
        let cPoint = gesture.location(in: gesture.view)
        magnifyView.updateFrame(cPoint)
        
    }
    
    lazy var normalImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = FMMagnifyViewController.image
        iv.isUserInteractionEnabled = true
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:)))
        iv.addGestureRecognizer(pan)
        return iv
    }()
    
    lazy var magnifyView: WBSuspensionWidgetView = {
        let view = WBSuspensionWidgetView(FMMagnifyViewController.image!, zoomScale: zoomScale, frame: CGRect(x: 0, y: 0, width: magnifyW, height: magnifyW - 2))
        
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView(frame: CGRect(x: 0, y: 88, width: screenWidth, height: screenHeight - 88 - 34))
        sv.delegate = self
        sv.maximumZoomScale = 2
        sv.minimumZoomScale = self.zoomScale
        sv.contentSize = self.imageSize
        sv.panGestureRecognizer.minimumNumberOfTouches = 2
        return sv
    }()
}

extension FMMagnifyViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return normalImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        zoomScale = scrollView.zoomScale
        magnifyView.updateZoomScale(zoomScale)
    }
}
