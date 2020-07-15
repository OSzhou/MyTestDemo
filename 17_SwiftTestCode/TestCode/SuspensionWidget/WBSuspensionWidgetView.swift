//
//  WBSuspenionWidgetView.swift
//  TestCode
//
//  Created by Zhouheng on 2020/6/3.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit

class WBSuspensionWidgetView: UIView {

    var image: UIImage?
    var imageSize: CGSize = .zero
    var zoomScale: CGFloat = 1
    let dotW: CGFloat = 17
    var lastPoint: CGPoint = .zero
    
    init(_ image: UIImage, zoomScale: CGFloat, frame: CGRect) {
        self.image = image
        self.imageSize = image.size
        self.zoomScale = zoomScale
        super.init(frame: frame)
        setupUI()
    }
    
    func updateZoomScale(_ zoomScale: CGFloat) {
        if zoomScale < screenWidth / imageSize.width {
            self.zoomScale = screenWidth / imageSize.width

        } else {
            self.zoomScale = zoomScale
        }
        
        imageContainerView.frame = CGRect(x: 0, y: 0, width: imageSize.width * zoomScale, height: imageSize.height * zoomScale)
        magnifyImageView.transform = CGAffineTransform(scaleX: self.zoomScale, y: self.zoomScale)
        
        if lastPoint != .zero {
            updateFrame(lastPoint)
        }
    }
    
    func updateFrame(_ cPoint: CGPoint) {
        
        let magnifyW = self.frame.size.width - 4
        var xPan: CGFloat = cPoint.x * zoomScale - magnifyW / 2
        if xPan < 0 {
            xPan = 0
        }
        if xPan > imageSize.width * zoomScale - magnifyW {
            xPan = imageSize.width * zoomScale - magnifyW
        }
        
        var yPan: CGFloat = cPoint.y * zoomScale - magnifyW / 2
        if yPan < 0 {
            yPan = 0
        }
        if yPan > imageSize.height * zoomScale - magnifyW {
            yPan = imageSize.height * zoomScale - magnifyW
        }
        
        let imageCW = imageSize.width * zoomScale
        let imageCH = imageSize.height * zoomScale
        imageContainerView.frame = CGRect(x: -xPan, y: -yPan, width: imageCW, height: imageCH)
        
        // 线头上的圆点
        var xDot: CGFloat = cPoint.x * zoomScale - dotW / 2
        if xDot < 0 {
            xDot = 0
        }
        if xDot > imageCW - dotW {
            xDot = imageCW - dotW
        }
        
        var yDot: CGFloat = cPoint.y * zoomScale - dotW / 2
        if yDot < 0 {
            yDot = 0
        }
        if yDot > imageCH - dotW {
            yDot = imageCH - dotW
        }
        headerDot.frame = CGRect(x: xDot, y: yDot, width: dotW, height: dotW)
        lastPoint = cPoint
    }
    
    private func updateImageAnchorPoint() {
        let p = headerDot.convert(headerDot.center, to: magnifyImageView)
        let x = p.x / imageSize.width
        let y = p.y / imageSize.height
        magnifyImageView.layer.anchorPoint = CGPoint(x: x, y: y)
    }
    
    private func setupUI() {
        self.backgroundColor = .white

        self.addSubview(containerView)
        let W = self.frame.size.width - 4
        containerView.frame = CGRect(x: 2, y: 0, width: W, height: W)
        containerView.addSubview(imageContainerView)
        imageContainerView.frame = CGRect(x: 0, y: 0, width: imageSize.width * zoomScale, height: imageSize.height * zoomScale)
        
        imageContainerView.addSubview(magnifyImageView)
        magnifyImageView.frame = CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height)
        magnifyImageView.transform = CGAffineTransform(scaleX: zoomScale, y: zoomScale)
        
        imageContainerView.addSubview(headerDot)
        headerDot.frame = CGRect(x: W / 2 - dotW / 2, y: W / 2 - dotW / 2, width: dotW, height: dotW)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// MARK: --- lazy loading
    lazy var containerView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        return view
    }()
    
    lazy var imageContainerView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var magnifyImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.anchorPoint = CGPoint(x: 0, y: 0)
        iv.image = image
        return iv
    }()
    
    lazy var headerDot: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: 0, width: dotW, height: dotW))
        iv.backgroundColor = .purple
        return iv
    }()
}
