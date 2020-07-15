//
//  WBVideoPreview.swift
//  TestCode
//
//  Created by Zhouheng on 2020/6/29.
//  Copyright © 2020 tataUFO. All rights reserved.
//

import UIKit
import AVFoundation

class WBVideoPreview: UIView {

    var captureSessionsion: AVCaptureSession? {
        
        set {
            let layer = self.layer as? AVCaptureVideoPreviewLayer
            layer?.session = newValue
        }
        
        get {
            let layer = self.layer as? AVCaptureVideoPreviewLayer
            return layer?.session
        }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let layer = self.layer as? AVCaptureVideoPreviewLayer
        layer?.videoGravity = .resizeAspectFill
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// open interface
    func captureDevicePointForPoint(_ point: CGPoint) -> CGPoint {
        let layer = self.layer as? AVCaptureVideoPreviewLayer
        return layer?.captureDevicePointConverted(fromLayerPoint: point) ?? .zero
    }
    
    static override var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
}
